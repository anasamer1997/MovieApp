//
//  HomeView.swift
//  MovieApp
//
//  Created by anas amer on 23/10/2024.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var network: NetworkManager
    var body: some View {
        VStack {
            
            if !network.isConnected{
                NetworkView()
                    .frame(height: 50)
            }else{
                
                NavigationStack{
                    ScrollView (showsIndicators: false){
                        LazyVStack(alignment:.leading,spacing: 20){
                            
                            Text("What do you want to watch?")
                                .poppins(.bold, 20)
                            TrendingMoviesView()
                            TopRatedMoviesView()
                            GenreView()
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




#Preview {
    HomeView()
}
