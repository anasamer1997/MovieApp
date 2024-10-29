//
//  UserDefualts.swift
//  MovieApp
//
//  Created by anas amer on 28/10/2024.
//

import Foundation

var firstLaunch = false

class LaunchManager {
    static let shared = LaunchManager()
    
    private init() {}
    func isFirstLaunch() {
        if firstLaunch == false{
            let launchedBefore = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
            if !launchedBefore {
                UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
                UserDefaults.standard.synchronize()
                firstLaunch = true
            }
        }
    }
}
