//
//  CoinDetailView.swift
//  CryptoTracker
//
//  Created by MAC on 25/06/2025.
//

import SwiftUI

struct CoinDetailView: View {
    @StateObject var vm: CoinDetailViewModel
    
    init(coin: Coin) {
        _vm = StateObject(wrappedValue: CoinDetailViewModel(coin: coin))
        print("init called with coin: \(coin.name)")
    }
    
    var body: some View {
        EmptyView()
    }
}

#Preview {
    CoinDetailView(coin: Coin.testCoin)
}
