//
//  CoinDetailView.swift
//  CryptoTracker
//
//  Created by MAC on 25/06/2025.
//

import SwiftUI

struct CoinDetailView: View {
    let coin: Coin
    
    init(coin: Coin) {
        self.coin = coin
        print("init called with coin: \(coin.name)")
    }
    
    var body: some View {
        Text(coin.name)
    }
}

#Preview {
    CoinDetailView(coin: Coin.testCoin)
}
