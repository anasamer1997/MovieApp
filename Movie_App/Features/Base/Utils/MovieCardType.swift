//
//  MovieCardType.swift
//  MovieApp
//
//  Created by anas amer on 23/10/2024.
//

import Foundation


enum MovieCardType{
    case poster ,grid
}

extension MovieCardType{
    
    var widthPercent:Double{
        switch self {
        case .poster:
            return 0.45
        case .grid:
            return 0.4
        }
    }
    var heightPercent:Double{
        switch self {
        case .poster:
            return 0.35
        case .grid:
            return  0.15
        }
    }
}
