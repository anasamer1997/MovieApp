//
//  DiscoverResponse.swift
//  MovieApp
//
//  Created by Raphael Cerqueira on 18/01/21.
//

import Foundation

struct DiscoverResponse: Decodable {
    var page: Int?
    var results: [MovieModel]?
    var totalResults: Int?
    var totalPages: Int?
}
