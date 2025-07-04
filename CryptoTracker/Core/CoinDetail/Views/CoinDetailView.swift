//
//  CoinDetailView.swift
//  CryptoTracker
//
//  Created by MAC on 25/06/2025.
//

import SwiftUI

struct CoinDetailView: View {
    
    @StateObject private var vm: CoinDetailViewModel
    @State private var showFullDescription: Bool = false
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    private let spacing: CGFloat = 30
    
    init(coin: Coin) {
        _vm = StateObject(wrappedValue: CoinDetailViewModel(coin: coin))
    }
    
    var body: some View {
        ScrollView {
            ChartView(coin: vm.coin)
            VStack(spacing: spacing){
                overviewSection
                additionalSection
                VStack(alignment: .leading){
                    if let websiteUrl = vm.websiteUrl,
                       let url = URL(string: websiteUrl){
                        Link("Website", destination: url)
                    }
                    if let redditUrl = vm.redditUrl,
                       let url = URL(string: redditUrl){
                        Link("Reddit", destination: url)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(.blue)
                .font(.headline)
                
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
        .onAppear {
            print("description fetched: \(vm.coinDescription)")
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
            if let coinDescription = vm.coinDescription, !coinDescription.isEmpty {
                VStack(alignment: .leading){
                    Text(coinDescription)
                        .font(.callout)
                        .foregroundStyle(Color.theme.secondaryText)
                        .lineLimit(showFullDescription ? nil : 3)
                    Button(showFullDescription ? "Collapse" :"Show more...") {
                        withAnimation(.easeInOut) {
                            showFullDescription.toggle()
                        }
                    }
                    .padding(.vertical,4)
                    .foregroundStyle(Color.blue)
                    .font(.caption)
                }
            }
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
