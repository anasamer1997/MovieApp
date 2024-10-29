//
//  TrendingViewModel.swift
//  Movie_App
//
//  Created by anas amer on 29/10/2024.
//

import Foundation
@MainActor
class TrendingViewModel:ObservableObject{
    @Published var trendingMovies:[MovieModel] = []
    @Published var isloading  = false
    @Published var errorMsg = ""
    @Published var showError  = false
    private var service:MovieService = MovieService()
    
    
    func fetchData() async{
        if !firstLaunch{
            print("TrendingViewModel fetchData")
            await fetchLocalData()
        }else{
            Task{
                await fetchTrendingMovies()
            }
        }
    }
    
    func fetchLocalData() async {
        if let trendingMovies: [MovieModel] = await CoreDataStorageService.shared.loadMoviesFromLocalStorage(.trending), !trendingMovies.isEmpty {
            print("Loaded \(trendingMovies.count) trending movies.")
            self.trendingMovies = trendingMovies
        }
    }
    func fetchTrendingMovies()async{
        isloading = true
        do {
            let response : MovieResponse = try await service.fetchData(api: ApiConistructor(endPoint: .trending))
            trendingMovies = response.results
            isloading = false
            await CoreDataStorageService.shared.saveMoviesInDB(response.results, .trending)
        } catch {
            isloading = false
            errorMsg = "Error: \(error.localizedDescription)"
            showError = true
        }
        
    }
}
