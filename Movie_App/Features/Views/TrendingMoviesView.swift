//
//  TrendingMoviesView.swift
//  Movie_App
//
//  Created by anas amer on 29/10/2024.
//

import Foundation
import SwiftUI

struct TrendingMoviesView: View {
    @StateObject private var viewModel = TrendingViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Trending Movies")
                .font(.headline)
                .padding(.leading)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(viewModel.trendingMovies) { movie in
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
