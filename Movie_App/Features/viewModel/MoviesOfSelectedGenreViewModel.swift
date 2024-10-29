//
//  MoviesOfSelectedGenreViewModel.swift
//  Movie_App
//
//  Created by anas amer on 29/10/2024.
//

import Foundation

@MainActor
class MoviesOfSelectedGenreViewModel:ObservableObject{
    @Published var movies:[MovieModel] = []
    @Published var filteredMovies:[MovieModel] = []
    @Published var genres:[GenreModel] = []
    @Published var isloading  = false
    @Published var errorMsg = ""
    @Published var showError  = false
    @Published var selectedGenre = DeveloperPreview.instance.genre
    private var service:MovieService = MovieService()
    
    
    
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
        if !firstLaunch{
            print("MoviesOfSelectedGenreViewModel fetchData")
            await fetchLocalData()
        }else{
            Task{
                await fetchGerne()
            }
          
        }
    }
    
    func fetchLocalData() async {
        Task{
            if let gerneMovies: [MovieModel] = await CoreDataStorageService.shared.loadMoviesFromLocalStorage(.genre), !gerneMovies.isEmpty {
                print("Loaded \(gerneMovies.count) trending movies.")
                self.movies = gerneMovies
            }
            
            if let selectedGenreMovies: [MovieModel] = await CoreDataStorageService.shared.loadMoviesFromLocalStorage(.selectedGenreMovies), !selectedGenreMovies.isEmpty {
                print("Loaded \(selectedGenreMovies.count) selected genre movies.")
                self.filteredMovies = selectedGenreMovies
                let newList = filteredMovies.filter { movie in
                    movie.genreIDS.contains(selectedGenre.id)
                }
                self.movies = newList
            }
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
                movies = response.results
                isloading = false
                await CoreDataStorageService.shared.saveMoviesInDB(response.results, .selectedGenreMovies)
                
            } catch {
                isloading = false
                errorMsg = "Error: \(error.localizedDescription)"
                showError = true
            }
            
        }else{
            let newList = self.filteredMovies.filter { movie in
                movie.genreIDS.contains(selectedGenre.id)
            }
            self.movies = newList
        }
    }
}
