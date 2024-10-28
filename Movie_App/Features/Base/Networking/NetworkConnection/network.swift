//
//  network.swift
//  WeatherApp
//
//  Created by anas amer on 30/08/2024.
//

import Foundation
import Network

final class NetworkManager: ObservableObject {
    static let shared = NetworkManager() // Singleton instance
    private var monitor: NWPathMonitor
    @Published var isConnected: Bool = false

    private init() {
        monitor = NWPathMonitor()
        startMonitoring()
    }

    private func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = (path.status == .satisfied)
            }
        }
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }

    deinit {
        monitor.cancel() // Stop monitoring when the instance is deallocated
    }
}
