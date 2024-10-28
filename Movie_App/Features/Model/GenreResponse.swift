//
//  GenryModel.swift
//  MovieApp
//
//  Created by anas amer on 25/10/2024.
//

import Foundation
struct GenreModel:Identifiable,Codable{
    let id: Int
    let name:String
}


struct GenreResponse:Decodable{
    let genres:[GenreModel]
}
