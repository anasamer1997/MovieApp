//
//  MovieModel.swift
//  MovieApp
//
//  Created by anas amer on 23/10/2024.
//

import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let weatherCodeIcon = try? JSONDecoder().decode(WeatherCodeIcon.self, from: jsonData)

import Foundation

// MARK: - MovieResponse
struct MovieResponse: Codable {
    let page: Int
    let results: [MovieModel]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - MovieModel
struct MovieModel: Codable,Identifiable {
    let backdropPath: String?
    let id: Int
    let genreIDS:[Int]
    let overview,title: String
    let posterPath :String?
    let releaseDate: String?
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
     
        case backdropPath = "backdrop_path"
        case id
        case genreIDS = "genre_ids"
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

enum MovieImageType{
    case poster,backdrop
}
extension MovieModel{
  
    var imageUrlString:String{
        return  Constants.imageBaseUrl + posterPath.stringValue
    }
    func getImageType(for type: MovieImageType) -> String{
        switch type {
        case .poster:
            Constants.imageBaseUrl + (posterPath == nil ? backdropPath.stringValue : posterPath.stringValue)
        case .backdrop:
            Constants.imageBaseUrl + (backdropPath == nil ? posterPath.stringValue : backdropPath.stringValue)
        }
    }
 
}
