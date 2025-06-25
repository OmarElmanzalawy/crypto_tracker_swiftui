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
    @Published var sortOption: SortOption = .holdings
    
    private let coinService = ApiService()
    private let marketService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    private var cancellables = Set<AnyCancellable>()
    
    enum SortOption {
        case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
    }
    
    init(){
        addSubscribeers()
    }
    
    private func addSubscribeers(){
        $searchText
            .combineLatest(coinService.$allCoins, $sortOption)
        //waits for both observables to emit a value before executing the closure
        //this is done not run the logic for each letter if the user is typing fast
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        //updates portfolioCoins
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] savedCoins in
                self?.portfolioCoins = self!.sortPortfolioCoinsIfNeeded(coins: savedCoins)
            }
            .store(in: &cancellables)
        
        // updates marketdata 
        marketService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
            .sink{ [weak self] (returnedStats) in
                self?.statistics = returnedStats
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    
    private func filterAndSortCoins(text: String, coins: [Coin], sortOption: SortOption) -> [Coin] {
        var updatedCoins = filterCoins(text: text, coins: coins)
        sortCoins(sort: sortOption, coins: &updatedCoins)
        return updatedCoins
    }
    
    //inout keyword makes that the function modifies the coins paramater in place without needing to return a brand new list of coins
    private func sortCoins(sort: SortOption, coins: inout [Coin]){
        switch sortOption {
        case .rank,.holdings:
            coins.sort(by: {$0.rank < $1.rank})
        case .rankReversed,.holdingsReversed:
            coins.sort(by: {$0.rank > $1.rank})
        case .price:
            coins.sort(by: {$0.currentPrice > $1.currentPrice})
        case .priceReversed:
            coins.sort(by: {$0.currentPrice < $1.currentPrice})
        }
    }
    
    private func sortPortfolioCoinsIfNeeded(coins: [Coin]) -> [Coin]{
        switch sortOption {
        case .holdings:
            return coins.sorted(by: {$0.currentHoldingValue > $1.currentHoldingValue})
        case .holdingsReversed:
            return coins.sorted(by: {$0.currentHoldingValue < $1.currentHoldingValue})
        default:
            return coins
        }
    }
    
    private func filterCoins(text: String, coins: [Coin]) -> [Coin] {
        guard !text.isEmpty else{
            return coins
        }
        
        let lowerecasedText = text.lowercased()
        
        return coins.filter { coin in
            return coin.name.lowercased().contains(lowerecasedText) || coin.symbol.lowercased().contains(lowerecasedText)
        }
    }
    
    private func mapAllCoinsToPortfolioCoins(allCoins: [Coin],portfolioCoins: [PortfolioEntity]) -> [Coin] {
        allCoins.compactMap { (coin) -> Coin? in
            guard let entity = portfolioCoins.first(where: {$0.coinId == coin.id}) else {
                return nil
            }
            return coin.updateHoldings(amount: entity.amount)
        }
    }
    
    private func mapGlobalMarketData(marketData: MarketData?,portfolioCoins: [Coin]) -> [Statistic] {
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
