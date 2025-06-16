//
//  CryptoTrackerApp.swift
//  CryptoTracker
//
//  Created by MAC on 16/06/2025.
//

import SwiftUI

@main
struct CryptoTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
                    .navigationBarHidden(true)
            }
        }
    }
}
