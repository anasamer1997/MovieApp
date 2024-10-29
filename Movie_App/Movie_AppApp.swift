//
//  Movie_AppApp.swift
//  Movie_App
//
//  Created by anas amer on 28/10/2024.
//

import SwiftUI

@main
struct Movie_AppApp: App {
    @Environment(\.scenePhase) var scenePhase
    @StateObject private var networkManager = NetworkManager.shared
    @State private var topRatedMoviesVM = TopViewModel()
    @State private var trendingMoviesVM = TrendingViewModel()
    
    init(){
        
    }
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(networkManager)
        }
        .onChange(of: scenePhase) {
            switch scenePhase {
            case .active:
                LaunchManager.shared.isFirstLaunch()
            case .background:
                scheduleAppRefresh()
                
            default: break
            }
        }
        .backgroundTask(.appRefresh("myapprefresh2")) {
            print("backgroundTask")
            await topRatedMoviesVM.fetchTopMovies()
            await trendingMoviesVM.fetchTrendingMovies()
        }
    }
}
