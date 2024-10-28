//
//  UserDefualts.swift
//  MovieApp
//
//  Created by anas amer on 28/10/2024.
//

import Foundation
class LaunchManager {
    static let shared = LaunchManager()
    
    private init() {}
    
    func isFirstLaunch() -> Bool {
        let launchedBefore = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        if !launchedBefore {
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
            UserDefaults.standard.synchronize()
            return true
        }
        return false
    }
}
