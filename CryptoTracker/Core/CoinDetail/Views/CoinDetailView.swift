//
//  CoinDetailView.swift
//  CryptoTracker
//
//  Created by MAC on 25/06/2025.
//

import SwiftUI

struct CoinDetailView: View {
    
    @StateObject private var vm: CoinDetailViewModel
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    private let spacing: CGFloat = 30
    
    init(coin: Coin) {
        _vm = StateObject(wrappedValue: CoinDetailViewModel(coin: coin))
        print("init called with coin: \(coin.name)")
    }
    
    var body: some View {
        ScrollView {
            ChartView(coin: vm.coin)
            VStack(spacing: spacing){
                overviewSection
                additionalSection
            }
            .padding()
            .navigationTitle(vm.coin.name)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack{
                        Text(vm.coin.symbol.uppercased())
                            .font(.headline)
                            .foregroundStyle(Color.theme.secondaryText)
                        CoinImageView(coin: vm.coin)
                            .frame(width: 25, height: 25)
                    }
                }
            }
        }
    }
        
}

#Preview {
    NavigationStack {
        CoinDetailView(coin: Coin.testCoin)
    }
}

extension CoinDetailView {
    private var overviewSection: some View{
        VStack{
            Text("Overview")
                .font(.title)
                .bold()
                .foregroundStyle(Color.theme.accent)
                .frame(maxWidth: .infinity, alignment: .leading)
            Divider()
            LazyVGrid(columns: columns,alignment: .leading,spacing: spacing) {
                ForEach(vm.overviewStatistics){ stat in
                    StatisticView(stat: stat)
                }
            }
        }
    }
    
    private var additionalSection: some View{
        VStack{
            Text("Additional Details")
                .font(.title)
                .bold()
                .foregroundStyle(Color.theme.accent)
                .frame(maxWidth: .infinity, alignment: .leading)
            Divider()
            LazyVGrid(columns: columns,alignment: .leading,spacing: spacing) {
                ForEach(vm.additionalStatistics){ stat in
                    StatisticView(stat: stat)
                }
            }
        }
    }
}
