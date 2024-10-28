//
//  PreviewProvider.swift
//  Movie
//
//  Created by Ahmed Ali on 19/04/2023.
//

import SwiftUI

extension Preview {
    static var dev: DeveloperPreview {
        DeveloperPreview.instance
    }
}

class DeveloperPreview {
    static let instance = DeveloperPreview()
    private init() {}
    
    let movie = MovieModel(
        backdropPath: "/3P52oz9HPQWxcwHOwxtyrVV1LKi.jpg",
        id: 102,
        genreIDS: [1],
        overview: "",
        title:"The Shawshank Redemption",
        posterPath:"/to0spRl1CMDvyUbOnbb4fTk3VAd.jpg", 
        releaseDate: "10-2-2023",
        voteAverage: 10.0,
        voteCount: 1
    )
    
        let genre = GenreModel(id: 28, name: "Action")
    
    let review = Review(author: "Test author", authorDetails: AuthorDetails(name: "name", username: "surename", avatarPath: nil, rating: 2), content: "content", createdAt: "2-23-2025", id: "15", updatedAt: "2-6-2052", url: "")
}
