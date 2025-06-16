//
//  ContentView.swift
//  CryptoTracker
//
//  Created by MAC on 16/06/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
                    .foregroundStyle(Color.theme.red)
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
