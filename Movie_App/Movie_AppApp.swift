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
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(networkManager)
        }
        .onChange(of: scenePhase) {
            switch scenePhase {
            case .background:
                scheduleAppRefresh()
                
            default: break
            }
        }
        .backgroundTask(.appRefresh("myapprefresh2")) {
            print("backgroundTask")
            await HomeViewModel.shared.fetchTrendingMovies()
            await HomeViewModel.shared.fetchTopRatedMovies()
        }
    }
}
