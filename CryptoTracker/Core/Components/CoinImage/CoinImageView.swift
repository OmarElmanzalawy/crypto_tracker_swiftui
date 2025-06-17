//
//  CoinImageView.swift
//  CryptoTracker
//
//  Created by MAC on 17/06/2025.
//

import SwiftUI
import Kingfisher

struct CoinImageView: View {
    var coin: Coin
    var body: some View {
        ZStack{
            KFImage(URL(string: coin.image))
                .placeholder({
                    ProgressView()
                })
                .onSuccess{results in
                    print("Downloaded Image Successfully")
                }
                .onFailure{error in
                    print("Error Downloading Image \(error.localizedDescription)")
                }
                .resizable()
                .scaledToFit()
               
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    CoinImageView(coin: Coin.testCoin)
}
