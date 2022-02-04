//
//  AerialMetricsApp.swift
//  Aerial Metrics
//
//  Created by Marcus Rossel on 25.01.22.
//

import SwiftUI

@main
struct AerialMetricsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.commands {
            SidebarCommands()
        }
    }
}
