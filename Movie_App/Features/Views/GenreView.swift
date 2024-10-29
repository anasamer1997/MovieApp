//
//  GenreView.swift
//  Movie_App
//
//  Created by anas amer on 29/10/2024.
//

import Foundation
import SwiftUI

struct GenreView: View {
    @StateObject private var viewModel = MoviesOfSelectedGenreViewModel()
    @Namespace private var namespace
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack{
                    ForEach(viewModel.genres){ genre in
                        GenreCard(genre: genre, namesapce: namespace, selectedGenre:$viewModel.selectedGenre)
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    viewModel.selectedGenre = genre
                                    Task{
                                        await viewModel.fetchMoviesForSelectedGenrer()
                                    }
                                }
                            }
                    }
                }
            }
            LazyVGrid(columns: [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())],spacing: 10) {
                ForEach(viewModel.movies){ movie in
                    NavigationLink(destination: MovieDetailes(movie: movie,movieType: viewModel.getMovieTypeBaesdOnGenre(movie.genreIDS))) {
                        MovieCard(movie: movie, type: .grid)
                    }
                }
            }
        } .task {
            await viewModel.fetchData()
        }
    }
}

