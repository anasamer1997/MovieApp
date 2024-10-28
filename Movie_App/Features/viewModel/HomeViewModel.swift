
import Foundation
import Combine


public enum Status {
    case loading
    case error(String)
    case populated
}

@MainActor
class HomeViewModel : ObservableObject{
    
    static let shared = HomeViewModel()
    
    @Published var topRatedMovies:[MovieModel] = []
    @Published var trendingMovies:[MovieModel] = []
    @Published var moviesSelectedGenre:[MovieModel] = []
    var filteredData:[MovieModel] = []
    @Published var genres:[GenreModel] = []
    @Published var errorMsg = ""
    @Published var selectedGenre = DeveloperPreview.instance.genre
    @Published var selectedMovie:MovieModel? = nil
    @Published var isloading  = false
    @Published var showError  = false
    private var service:MovieService = MovieService()
    private var cancellables = Set<AnyCancellable>()
    
    func getMovieTypeBaesdOnGenre(_ ids:[Int])-> [String]{
        var types:[String] = []
        for item in genres{
            if ids.contains(item.id){
                types.append(item.name)
            }
        }
        
        return types
    }
    func fetchData() async{
        if !LaunchManager.shared.isFirstLaunch(){
            Task {
                if let trendingMovies: [MovieModel] = await CoreDataStorageService.shared.loadMoviesFromLocalStorage(.trending), !trendingMovies.isEmpty {
                    print("Loaded \(trendingMovies.count) trending movies.")
                    self.trendingMovies = trendingMovies
                }
                
                if let genres: [GenreModel] = await CoreDataStorageService.shared.loadMoviesFromLocalStorage(.genre),!genres.isEmpty {
                    print("Loaded \(genres.count) genres.")
                    self.genres = genres
                    self.selectedGenre = self.genres.first!
                }
                
                if let selectedGenreMovies: [MovieModel] = await CoreDataStorageService.shared.loadMoviesFromLocalStorage(.selectedGenreMovies), !selectedGenreMovies.isEmpty {
                    print("Loaded \(selectedGenreMovies.count) selected genre movies.")
                    self.filteredData = selectedGenreMovies
                    let newList = filteredData.filter { movie in
                        movie.genreIDS.contains(selectedGenre.id)
                    }
                    self.moviesSelectedGenre = newList
                }

//                if let topRatedMovies: [MovieModel] = await CoreDataStorageService.shared.loadMoviesFromLocalStorage(.topRated),!topRatedMovies.isEmpty {
//                    print("Loaded \(topRatedMovies.count) top-rated movies.")
//                    self.topRatedMovies = topRatedMovies
//                }

               
            }
        }else{
            if NetworkManager.shared.isConnected{
                Task{
                    await fetchTrendingMovies()
                    await fetchTopRatedMovies()
                    await fetchGerne()
                    await fetchMoviesForSelectedGenrer()
                }
            }
        }
    }
    
    func fetchTrendingMovies()async{
        isloading = true
        do {
            let response : MovieResponse = try await service.fetchData(api: ApiConistructor(endPoint: .trending))
            trendingMovies = response.results
          
           await CoreDataStorageService.shared.saveMoviesInDB(response.results, .trending)
        } catch {
            errorMsg = "Error: \(error.localizedDescription)"
            showError = true
        }
    }
    
    func fetchTopRatedMovies()async{
        do {
            let response : MovieResponse = try await service.fetchData(api: ApiConistructor(endPoint: .topRated))
            topRatedMovies = response.results
          await  CoreDataStorageService.shared.saveMoviesInDB(response.results, .topRated)
        } catch {
            errorMsg = "Error: \(error.localizedDescription)"
            showError = true
          
        }
    }
    
    func fetchGerne()async{
        do {
            let response : GenreResponse = try await service.fetchData(api: ApiConistructor(endPoint: .genre))
            genres = response.genres
            if let genre = genres.first{
                selectedGenre = genre
                await fetchMoviesForSelectedGenrer()
            }
            await CoreDataStorageService.shared.saveMoviesInDB(response.genres, .genre)
        }catch {
            errorMsg = "Error: \(error.localizedDescription)"
            showError = true
        }
    }
    
    func fetchMoviesForSelectedGenrer()async{
        if NetworkManager.shared.isConnected{
            isloading = true
            do {
                let api = ApiConistructor(endPoint: .discoverMovies,params: [
                    "with_genres": "\(selectedGenre.id)"
                ])
                let response : MovieResponse = try await service.fetchData(api: api)
                moviesSelectedGenre = response.results
                await CoreDataStorageService.shared.saveMoviesInDB(response.results, .selectedGenreMovies)
                isloading = false
            } catch {
                isloading = false
                errorMsg = "Error: \(error.localizedDescription)"
                showError = true
            }
            
        }else{
            let newList = self.filteredData.filter { movie in
                movie.genreIDS.contains(selectedGenre.id)
            }
            self.moviesSelectedGenre = newList
        }
    }
}
