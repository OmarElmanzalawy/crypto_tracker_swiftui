//
//  CryptoTrackerApp.swift
//  CryptoTracker
//
//  Created by MAC on 16/06/2025.
//

import SwiftUI

@main
struct CryptoTrackerApp: App {
    
    @StateObject private var vm = HomeViewModel()
    
    init() {
        // override the navigation title color
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
//                    .navigationBarHidden(true)
            }
            .environmentObject(vm)
        }
    }
}
