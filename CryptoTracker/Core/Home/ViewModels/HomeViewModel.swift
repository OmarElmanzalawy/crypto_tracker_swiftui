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
    @Published var isLoading: Bool = false
    @Published var portfolioCoins: [Coin] = []
    @Published var searchText: String = ""
    
    private let coinService = ApiService()
    private let marketService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
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
        
        //updates portfolioCoins
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map { (allCoins,savedCoins) -> [Coin] in
                allCoins.compactMap { (coin) -> Coin? in
                    guard let entity = savedCoins.first(where: {$0.coinId == coin.id}) else {
                        return nil
                    }
                    return coin.updateHoldings(amount: entity.amount)
                }
            }
            .sink { [weak self] savedCoins in
                self?.portfolioCoins = savedCoins
            }
            .store(in: &cancellables)
        
        // updates marketdata 
        marketService.$marketData
            .combineLatest($portfolioCoins)
            .map({ (marketData,portfolioCoins) -> [Statistic] in
                var stats: [Statistic] = []
                
                guard let data = marketData else{
                    return stats
                }
                
                let marketCap = Statistic(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
                let volume = Statistic(title: "24H Volume", value: data.volume)
                let btcDominance = Statistic(title: "BTC Dominance", value: data.btcDominance)
                
                //Get holding value for each coin and then combine them
                let portfolioValue = portfolioCoins.map({$0.currentHoldingValue})
                    .reduce(0, +)
                
                let previousValue = portfolioCoins.map({(coin) -> Double in
                    let currentValue = coin.currentHoldingValue
                    let percentageChange = coin.priceChangePercentage24H! / 100
                    return currentValue / (1 + percentageChange)
                })
                    .reduce(0, +)
                
                let percentageChange = ((portfolioValue - previousValue) / previousValue) * 100
                
                let portfolio = Statistic(title: "Portfolio Value", value: portfolioValue.asCurrencyWith2Decimals(),percentageChange: percentageChange)
                
                stats.append(contentsOf: [
                    marketCap,volume,btcDominance,portfolio
                ])
                return stats
            })
            .sink{ [weak self] (returnedStats) in
                self?.statistics = returnedStats
                self?.isLoading = false
            }
            .store(in: &cancellables)
        
        
    }
    
    func updatePortfiolio(coin: Coin, amount: Double){
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    func reloadData(){
        isLoading = true
        coinService.getCoins()
        marketService.getData()
        HapticManager.notification(type: .success)
    }
    
}
