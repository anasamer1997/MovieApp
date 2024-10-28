//
//  HomeView.swift
//  MovieApp
//
//  Created by anas amer on 23/10/2024.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var network: NetworkManager
    @StateObject var viewModel = HomeViewModel()
    @Namespace var namesapce
    var body: some View {
        VStack {
            
            if !network.isConnected{
                NetworkView()
                    .frame(height: 50)
            }else{
                if viewModel.isloading{
                    LoadingView()
                }else{
                    VStack{
                        
                        NavigationStack{
                            ScrollView (showsIndicators: false){
                                LazyVStack(alignment:.leading,spacing: 20){
                                    
                                    Text("What do you want to watch?")
                                        .poppins(.bold, 20)
                                    
                                    Text("Trinding Movies")
                                    TrindingView
                                    Text("Top Movies")
                                    TopMoviesView
                                    GenreView
                                    if viewModel.moviesSelectedGenre.isEmpty{
                                        NoDataView
                                    }else{
                                        selectedGenreMoviesView
                                    }
                                    
                                }
                            }
                            .preferredColorScheme(.dark)
                            .padding()
                            .background(.appBackground)
                        }
                        
                    }
                }
            }
        }
        .background(Color.appBackground)
        .onAppear {
            Task {
                await viewModel.fetchData()
            }
        }
    }
}

extension HomeView{
    
    @ViewBuilder
    private var TrindingView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(viewModel.trendingMovies) { movie in
                    NavigationLink(destination: MovieDetailes(movie: movie,movieType: viewModel.getMovieTypeBaesdOnGenre(movie.genreIDS))) {
                        MovieCard(movie: movie, type: .poster)
                    }
                }
            }
        }
    }   
    @ViewBuilder
    private var TopMoviesView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(viewModel.topRatedMovies) { movie in
                    NavigationLink(destination: MovieDetailes(movie: movie,movieType: viewModel.getMovieTypeBaesdOnGenre(movie.genreIDS))) {
                        MovieCard(movie: movie, type: .poster)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private  var GenreView : some View{
        
        ScrollView(.horizontal,showsIndicators: false) {
            LazyHStack{
                ForEach(viewModel.genres){ genre in
                    GenreCard(genre: genre, namesapce: namesapce, selectedGenre:$viewModel.selectedGenre)
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                viewModel.selectedGenre = genre
                                Task{
                                    await viewModel.fetchMoviesForSelectedGenrer()
                                }
                            }
                        }
                }
            }.scrollTargetBehavior(.paging)
        }
    }
    @ViewBuilder
    private var selectedGenreMoviesView : some View{
        LazyVGrid(columns: [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())],spacing: 10) {
            ForEach(viewModel.moviesSelectedGenre){ movie in
                NavigationLink(destination: MovieDetailes(movie: movie,movieType: viewModel.getMovieTypeBaesdOnGenre(movie.genreIDS))) {
                    MovieCard(movie: movie, type: .grid)
                }
            }
        }
    }
    @ViewBuilder
    private var NoDataView: some View{
        Text("No movies found")
    }
}

#Preview {
    HomeView(namesapce:Namespace() )
}
