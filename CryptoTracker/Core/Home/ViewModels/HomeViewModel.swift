//
//  HomeViewModel.swift
//  CryptoTracker
//
//  Created by MAC on 17/06/2025.
//

import Foundation

class HomeViewModel: ObservableObject{
    
    @Published var allCoins: [Coin] = []
    @Published var portfolioCoins: [Coin] = []
    
    init(){
        DispatchQueue.main.asyncAfterUnsafe(deadline: .now() + 2.0) {
            self.allCoins.append(Coin.testCoin)
            self.portfolioCoins.append(Coin.testCoin)
        }
    }
    
}
