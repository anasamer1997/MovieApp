//
//  MovieCard.swift
//  MovieApp
//
//  Created by anas amer on 23/10/2024.
//

import SwiftUI

struct MovieCard: View {

    let movie:MovieModel
    let type:MovieCardType
    
    var body: some View {
        CustomImageView(itemWidth: itemWidth, itemHeight:itemHeight, movie: movie)
    }
}


extension MovieCard{
    var itemWidth:Double{
        screenWidth * type.widthPercent
    }
    var itemHeight:Double{
        screenHeight * type.heightPercent
    }
}
#Preview {
    MovieCard(movie: DeveloperPreview.instance.movie,type: .grid)
}
