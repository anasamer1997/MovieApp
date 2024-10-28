//
//  BackgroundDataRefresh.swift
//  MovieApp
//
//  Created by anas amer on 27/10/2024.
//

import Foundation
import BackgroundTasks

func scheduleAppRefresh() {
    let request = BGAppRefreshTaskRequest(identifier: "myapprefresh2")
    request.earliestBeginDate = Calendar.current.date(byAdding: .hour, value: 4, to: Date()) // Schedule every 4 hours
    do {
        try BGTaskScheduler.shared.submit(request)
        print("Scheduled app refresh successfully")
    } catch {
        print("Scheduling Error \(error.localizedDescription)")
    }
}
