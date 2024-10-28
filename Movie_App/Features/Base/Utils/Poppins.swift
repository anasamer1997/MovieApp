//
//  Poppins.swift
//  MovieApp
//
//  Created by anas amer on 23/10/2024.
//

import Foundation


enum Poppins:String{
    case black,bold,regular,medium,light,semiBold
    
    var fontName:String{
        "Poppins-\(self.rawValue.capitalizeFirstLetter)"
    }
}
