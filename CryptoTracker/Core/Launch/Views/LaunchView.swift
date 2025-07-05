//
//  LaunchView.swift
//  CryptoTracker
//
//  Created by MAC on 05/07/2025.
//

import SwiftUI

struct LaunchView: View {
    
    @State var loadingText: [String] = "Loading your portfolio...".map({ String($0) })
    @State var showLoadingText: Bool = false
    
    var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    @State var counter: Int = 0
    @Binding var showLaunchView: Bool
    @State var loops: Int = 1
    
    var body: some View {
        ZStack{
            Color.launchBackground
                .ignoresSafeArea()
            
            Image("logo-transparent")
                .resizable()
                .frame(width: 100, height: 100)
            
                ZStack{
                    if showLoadingText{
                        HStack(spacing: 0){
                            ForEach(loadingText.indices){index in
                                Text(loadingText[index])
                                    .font(.headline)
                                    .fontWeight(.heavy)
                                    .foregroundStyle(Color.launchAccent)
                                    .offset(y: counter == index ? -5 : 0)
                            }
                        }
                        .transition(AnyTransition.scale
                            .animation(.easeIn))
                    }
                }
                .offset(y: 70)
                    
           
        }
        .onAppear{
            showLoadingText.toggle()
        }
        .onReceive(timer) { _ in
            if counter == loadingText.count {
                counter = 0
                if loops >= 2 {
                    withAnimation{
                        showLaunchView = false
                    }
                    return
                }
                loops += 1
                return
            }
            counter += 1
        }
    }
}

#Preview {
    LaunchView(showLaunchView: .constant(true))
}
