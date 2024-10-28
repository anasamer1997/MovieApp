//
//  movierService.swift
//  MovieApp
//
//  Created by anas amer on 24/10/2024.
//

import Foundation

enum MovieServiceError:Error{
    case invalidResponse
    case noInternetConnection
}
actor MovieService{
    func fetchData<T:Decodable>(api: ApiConistructor) async throws -> T{
        guard NetworkManager.shared.isConnected else{
            throw MovieServiceError.noInternetConnection
        }
        let url  = try UrlBuilder.build(api: api)
        let (data,response) = try await URLSession.shared.data(from: url)
        guard let res = response as? HTTPURLResponse , res.statusCode >= 200 && res.statusCode < 300 else{
            throw MovieServiceError.invalidResponse
        }
        return try JSONDecoder().decode(T.self, from: data)
    }
}
