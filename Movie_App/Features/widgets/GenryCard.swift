//
//  GenryCard.swift
//  MovieApp
//
//  Created by anas amer on 25/10/2024.
//

import SwiftUI

struct GenreCard: View {
    let genre:GenreModel
    let namesapce:Namespace.ID
    @Binding var selectedGenre:GenreModel
    
    var body: some View {
        Text(genre.name)
            .poppins(genre.id == selectedGenre.id ? .bold : .medium,18)
            .background(
                ZStack{
                    if selectedGenre.id == genre.id{
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.appGrayColor1)
                            .frame(height: 3)
                            .offset(y:20)
                            .matchedGeometryEffect(id: "genrecard", in: namesapce)
                    }
                }
            ).padding()
    }
}

#Preview {
    GenreCard(genre: DeveloperPreview.instance.genre,namesapce: Namespace().wrappedValue,selectedGenre: .constant(DeveloperPreview.instance.genre))
}
