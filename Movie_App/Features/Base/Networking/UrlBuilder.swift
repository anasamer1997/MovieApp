//
//  UrlBuilder.swift
//  MovieApp
//
//  Created by anas amer on 24/10/2024.
//

import Foundation

enum UrlBuilderError :Error{
    case invaledPath
    case invaledUrl
}

enum UrlBuilder{
    
    static func build(api:ApiConistructor) throws -> URL{
        guard var urlComponents = URLComponents(string: api.endPoint.fullPath) else{
            throw UrlBuilderError.invaledPath
        }
        urlComponents.queryItems = buildQueryParams(api.params,["api_key":Constants.apiKey])
        guard let url = urlComponents.url else{  throw UrlBuilderError.invaledUrl}
        return url
    }
    
    static func buildQueryParams(_ param:Parameters...) -> [URLQueryItem]{
        param.flatMap { $0 }.map { URLQueryItem(name: $0.key, value: $0.value)
        }
    }
}
