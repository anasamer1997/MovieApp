//
//  TopViewModel.swift
//  Movie_App
//
//  Created by anas amer on 29/10/2024.
//

import Foundation

@MainActor
class TopViewModel:ObservableObject{
    @Published var movies:[MovieModel] = []
    @Published var isloading  = false
    @Published var errorMsg = ""
    @Published var showError  = false
    private var service:MovieService = MovieService()
    
    func fetchData() async{
        if !firstLaunch{
            print("TopViewModel fetchData")
            await fetchLocalData()
        }else{
            Task{
                await fetchTopMovies()
            }
            
        }
    }
    
    func fetchLocalData() async {
        if let topRatedMovies: [MovieModel] = await CoreDataStorageService.shared.loadMoviesFromLocalStorage(.topRated), !topRatedMovies.isEmpty {
            print("Loaded \(topRatedMovies.count) trending movies.")
            self.movies = topRatedMovies
        }
    }
    
    func fetchTopMovies()async{
        isloading = true
        do {
            let response : MovieResponse = try await service.fetchData(api: ApiConistructor(endPoint: .topRated))
            movies = response.results
            isloading = false
            await CoreDataStorageService.shared.saveMoviesInDB(response.results, .topRated)
        } catch {
            isloading = false
            errorMsg = "Error: \(error.localizedDescription)"
            showError = true
        }
       
    }
}
