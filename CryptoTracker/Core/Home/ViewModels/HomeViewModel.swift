//
//  HomeViewModel.swift
//  CryptoTracker
//
//  Created by MAC on 17/06/2025.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject{
    
    @Published var statistics: [Statistic] = []
    @Published var allCoins: [Coin] = []
    @Published var portfolioCoins: [Coin] = []
    @Published var searchText: String = ""
    
    private let coinService = ApiService()
    private let marketService = MarketDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init(){
        addSubscribeers()
    }
    
    private func addSubscribeers(){
        $searchText
            .combineLatest(coinService.$allCoins)
        //waits for both observables to emit a value before executing the closure
        //this is done not run the logic for each letter if the user is typing fast
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map{(text,startingCoins) -> [Coin] in
            
                guard !text.isEmpty else{
                    return startingCoins
                }
                
                let lowerecasedText = text.lowercased()
                
                return startingCoins.filter { coin in
                    return coin.name.lowercased().contains(lowerecasedText) || coin.symbol.lowercased().contains(lowerecasedText)
                }
            }
            .sink { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        // updates marketdata 
        marketService.$marketData
            .map({ (marketData) -> [Statistic] in
                var stats: [Statistic] = []
                
                guard let data = marketData else{
                    return stats
                }
                
                let marketCap = Statistic(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
                let volume = Statistic(title: "24H Volume", value: data.volume)
                let btcDominance = Statistic(title: "BTC Dominance", value: data.btcDominance)
                let portfolio = Statistic(title: "Portfolio Value", value: "$0.00",percentageChange: 0)
                
                stats.append(contentsOf: [
                    marketCap,volume,btcDominance,portfolio
                ])
                return stats
            })
            .sink{ [weak self] (returnedStats) in
                self?.statistics = returnedStats
            }
            .store(in: &cancellables)
    }
    
    private func mapGlobalMarketData(){
        
        
        
    }
    
}
