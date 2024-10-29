//
//  TopRatedMoviesView.swift
//  Movie_App
//
//  Created by anas amer on 29/10/2024.
//

import Foundation
import SwiftUI

struct TopRatedMoviesView: View {
    @StateObject private var viewModel = TopViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Top Movies")
                .font(.headline)
                .padding(.leading)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(viewModel.movies) { movie in
                        NavigationLink(destination: MovieDetailes(movie: movie,movieType: [""])) {
                            MovieCard(movie: movie, type: .poster)
                        }
                    }
                }
            }
            .task {
                await viewModel.fetchData()
            }
        }
    }
}
