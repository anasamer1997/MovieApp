//
//  DetailesModel.swift
//  MovieApp
//
//  Created by anas amer on 25/10/2024.
//

import Foundation

@MainActor
class DetailesViewModel:ObservableObject{
    let movie:MovieModel
    let detailesViewSections:[DetailViewSection] = [.AboutMovie,.Reviews]
    private let service:MovieService = MovieService()
    @Published var selectedSection :DetailViewSection = .AboutMovie
    @Published var reviews :[Review] = []
    @Published var isloading  = false
    @Published var showError  = false
    @Published var errorMsg  = ""
    
    
    init(movie: MovieModel) {
        self.movie = movie
    }
    
    func fetchReviews() async{
        isloading = true
        do {
            let response : ReviewsResponse = try await service.fetchData(api: ApiConistructor(endPoint: .movieReviews(movie.id)))
            reviews = response.results
            isloading = false
        } catch {
            isloading = false
            showError = true
            errorMsg = "Error: \(error.localizedDescription)"
        }
    }
}
