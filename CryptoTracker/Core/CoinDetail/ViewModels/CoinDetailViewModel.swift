
import Foundation
import Combine

class CoinDetailViewModel: ObservableObject{
    
    @Published var overviewStatistics: [Statistic] = []
    @Published var additionalStatistics: [Statistic] = []
    
    @Published var coin: Coin
    private let coinDetailService: CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: Coin) {
        self.coin = coin
        self.coinDetailService = CoinDetailDataService(coin: coin)
        self.addSubscribers()
    }
    
    private func addSubscribers(){
        
        coinDetailService.$coinDetail
            .combineLatest($coin)
            .map(mapStats)
            .sink { [weak self] (returnedArrays) in
                self?.overviewStatistics = returnedArrays.overview
                self?.additionalStatistics = returnedArrays.additional
            }
            .store(in: &cancellables)
    }
    
    private func mapStats(coinDetail: CoinDetail?,coin: Coin) -> (overview: [Statistic], additional: [Statistic]) {
        let price = coin.currentPrice.asCurrencyWith6Decimals()
        let priceChange = coin.priceChangePercentage24H
        let priceStat = Statistic(title: "Current Price", value: price, percentageChange: priceChange)
        
        let marketCap = "$" + (coin.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapChange = coin.marketCapChange24H
        let marketStat = Statistic(title: "Market Cap", value: marketCap, percentageChange: marketCapChange)
        
        let rank = "\(coin.rank)"
        let rankStat = Statistic(title: "Rank", value: rank)
        
        let volume = "$" + (coin.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = Statistic(title: "Volume", value: volume)
        
        let overviewArray = [priceStat,marketStat,rankStat,volumeStat]
        
        //additional
        let high = coin.high24H?.asCurrencyWith6Decimals() ?? "/na"
        let highStat = Statistic(title: "24H High", value: high)
        
        let low = coin.low24H?.asCurrencyWith6Decimals() ?? "/na"
        let lowStat = Statistic(title: "24H Low", value: low)
        
        let priceChange1 = coin.priceChangePercentage24H?.asCurrencyWith6Decimals() ?? "n/a"
        let priceChangePercentage2 = coin.priceChangePercentage24HInCurrency
        let priceChangeStat = Statistic(title: "24H Price Change", value: priceChange1, percentageChange: priceChangePercentage2)
        
        let marketCapChange1 = "$" + (coin.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange2 = coin.marketCapChangePercentage24H
        let marketCapStat = Statistic(title: "24H Market Cap Change", value: marketCapChange1, percentageChange: marketCapPercentChange2)
        
        let blocTime = coinDetail?.blockTimeInMinutes ?? 0
        let blocStat = Statistic(title: "Bloc Time", value: blocTime == 0 ? "n/a" :"\(blocTime)")
        
        let hashing = coinDetail?.hashingAlgorithm ?? "n/a"
        let hashStat = Statistic(title: "Hashing Algorithm", value: hashing)
        
        let additionalArray: [Statistic] = [highStat,lowStat,priceChangeStat,marketCapStat,blocStat,hashStat]
        
        return (overviewArray,additionalArray)
    }
    
}
