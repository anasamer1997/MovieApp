//
//  CustomImageView.swift
//  MovieApp
//
//  Created by anas amer on 23/10/2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct CustomImageView: View {
    let itemWidth:CGFloat
    let itemHeight:CGFloat
    let movie:MovieModel
    var movieImageType:MovieImageType = .poster
    
    var body: some View {
        
        WebImage(url:URL(string: movie.getImageType(for: movieImageType))) { image in
            image
                .resizable()
                .scaledToFit()
                .aspectRatio(contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 20))
          
        } placeholder: {
            ZStack{
                Color.appGrayColor1
                
            }
        }
        .frame(width: itemWidth,height: itemHeight)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    CustomImageView(itemWidth: 200, itemHeight: 150,movie: DeveloperPreview.instance.movie)
}
