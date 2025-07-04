//
//  CoinModel.swift
//  CryptoTracker
//
//  Created by MAC on 16/06/2025.
//

import Foundation

//Response notes
/*
 URL:
    "https://api.coingecko.com/api/v3/coins/markets"
 
 {
     "id": "bitcoin",
     "symbol": "btc",
     "name": "Bitcoin",
     "image": "https://coin-images.coingecko.com/coins/images/1/large/bitcoin.png?1696501400",
     "current_price": 108602,
     "market_cap": 2158311426915,
     "market_cap_rank": 1,
     "fully_diluted_valuation": 2158311426915,
     "total_volume": 29160486397,
     "high_24h": 108500,
     "low_24h": 104627,
     "price_change_24h": 3051.32,
     "price_change_percentage_24h": 2.89085,
     "market_cap_change_24h": 60174653123,
     "market_cap_change_percentage_24h": 2.868,
     "circulating_supply": 19878000,
     "total_supply": 19878000,
     "max_supply": 21000000,
     "ath": 111814,
     "ath_change_percentage": -3.2391,
     "ath_date": "2025-05-22T18:41:28.492Z",
     "atl": 67.81,
     "atl_change_percentage": 159454.611,
     "atl_date": "2013-07-06T00:00:00.000Z",
     "roi": null,
     "last_updated": "2025-06-16T19:16:26.670Z",
     "sparkline_in_7d": {
       "price": [
         108363.66508078856,
         108452.74865376222,
         108539.58035509764,
         108741.30459011254,
         109966.95873692061,
         110191.90634892028,
         110265.69002155038,
         109988.51756663903,
         109756.33536035352,
         109688.30727503309,
         109577.37237837986,
         109554.47934166284,
         109333.96422639265,
         109555.19743873407,
       ]
     }
   },
 */

struct Coin: Identifiable, Codable {
    let id, symbol, name: String
    let image: String
    let currentPrice: Double
    let marketCap, marketCapRank, fullyDilutedValuation: Double?
    let totalVolume, high24H, low24H: Double?
    let priceChange24H, priceChangePercentage24H: Double?
    let marketCapChange24H: Double?
    let marketCapChangePercentage24H: Double?
    let circulatingSupply, totalSupply, maxSupply, ath: Double?
    let athChangePercentage: Double?
    let athDate: String?
    let atl, atlChangePercentage: Double?
    let atlDate: String?
    let lastUpdated: String?
    let sparklineIn7D: SparklineIn7D?
    let priceChangePercentage24HInCurrency: Double?
    let currentHoldings: Double?
    
    
    enum CodingKeys: String, CodingKey{
        case id,symbol,name,image
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case fullyDilutedValuation = "fully_diluted_valuation"
        case totalVolume = "total_volume"
        case high24H = "high_24h"
        case low24H = "low_24h"
        case priceChange24H = "price_change_24h"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case marketCapChange24H = "market_cap_change_24h"
        case marketCapChangePercentage24H = "market_cap_change_percentage_24h"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case ath
        case athChangePercentage = "ath_change_percentage"
        case athDate = "ath_date"
        case atl
        case atlChangePercentage = "atl_change_percentage"
        case atlDate = "atl_date"
        case lastUpdated =  "last_updated"
        case sparklineIn7D = "sparkline_in_7d"
        case priceChangePercentage24HInCurrency = "price_change_percentage_24h_in_currency"
        case currentHoldings
    }
    
    func updateHoldings(amount: Double) -> Coin{
        return Coin(id: id, symbol: symbol, name: name, image: image, currentPrice: currentPrice, marketCap: marketCap, marketCapRank: marketCapRank, fullyDilutedValuation: fullyDilutedValuation, totalVolume: totalVolume, high24H: high24H, low24H: low24H, priceChange24H: priceChange24H, priceChangePercentage24H: priceChangePercentage24H, marketCapChange24H: marketCapChange24H, marketCapChangePercentage24H: marketCapChangePercentage24H, circulatingSupply: circulatingSupply, totalSupply: totalSupply, maxSupply: maxSupply, ath: ath, athChangePercentage: athChangePercentage, athDate: athDate, atl: atl, atlChangePercentage: atlChangePercentage, atlDate: atlDate, lastUpdated: lastUpdated, sparklineIn7D: sparklineIn7D, priceChangePercentage24HInCurrency: priceChangePercentage24HInCurrency, currentHoldings: amount)
    }
    
    var currentHoldingValue: Double{
        return (currentHoldings ?? 0) * currentPrice
    }
    
    var rank: Int {
        return Int(marketCapRank ?? 0)
    }
    
    static let testCoin = Coin(
        id: "bitcoin",
        symbol: "btc",
        name: "Bitcoin",
        image: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579",
        currentPrice: 61408,
        marketCap: 1141731099010,
        marketCapRank: 1,
        fullyDilutedValuation: 1285385611303,
        totalVolume: 67190952980,
        high24H: 61712,
        low24H: 56220,
        priceChange24H: 3952.64,
        priceChangePercentage24H: 6.87944,
        marketCapChange24H: 72110681879,
        marketCapChangePercentage24H: 6.74171,
        circulatingSupply: 18653043,
        totalSupply: 21000000,
        maxSupply: 21000000,
        ath: 61712,
        athChangePercentage: -0.97589,
        athDate: "2021-03-13T20:49:26.606Z",
        atl: 67.81,
        atlChangePercentage: 90020.24075,
        atlDate: "2013-07-06T00:00:00.000Z",
        lastUpdated: "2021-03-13T23:18:10.268Z",
        sparklineIn7D: SparklineIn7D(price: [
            54019.26878317463,
            53718.060935791524,
            53677.12968669343,
            53848.3814432924,
            53561.593235320615,
            53456.0913723206,
            53888.97184353125,
            54796.37233913172,
            54593.507358383504,
            54582.558599307624,
            54635.7248282177,
            54772.612788430226,
            55192.54513921453,
            54878.11598538206,
            54513.95881205807,
            55013.68511841942,
            55145.89456844788,
            54718.37455337104,
            54954.0493828267,
            54910.13413954234,
            54778.58411728141,
            55027.87934987173,
            55473.0657777974,
            54997.291345118225,
            54991.81484262107,
            55395.61328972238,
            55530.513360661644,
            55344.4499292381,
            54889.00473869075,
            54844.521923521665,
            54710.03981625522,
            54135.005312343856,
            54278.51586384954,
            54255.871982023025,
            54346.240757736465,
            54405.90449526803,
            54909.51138548527,
            55169.3372715675,
            54810.85302834732,
            54696.044114623706,
            54332.39670114743,
            54815.81007775886,
            55013.53089568202,
            54856.867125138066,
            55090.76841223987,
            54524.41939124773,
            54864.068334250915,
            54462.38634298567,
            54810.6138506792,
            54763.5416402156,
            54621.36137575708,
            54513.628030530825,
            54356.00127005116,
            53755.786684715764,
            54024.540451750094,
            54385.912857981304,
            54399.67618552436,
            53991.52168768531,
            54683.32533920595,
            54449.31811384671,
            54409.102042970466,
            54370.86991701537,
            53731.669170540394,
            53645.37874343392,
            53841.45014070333,
            53078.52898275558,
            52881.63656182149,
            53010.25164880975,
            52936.11939761323,
            52937.55256563505,
            53413.673939003136,
            53395.17699522727,
            53596.70402266675,
            53456.22811013035,
            53483.547854166834,
            53574.40015717944,
            53681.336964452734,
            54101.59049997355,
            54318.29276391888,
            54511.25370785759,
            54332.08597577831,
            54577.323438764404,
            54477.276388342325,
            54289.676338302765,
            54218.42837403623,
            54802.18754896328,
            55985.49640087922,
            56756.316501699876,
            57210.138362768965,
            56805.27815017699,
            56682.3217648727,
            57043.194415417776,
            56912.77785094373,
            56786.15869001341,
            57003.56072100917,
            57166.66441986013,
            57828.511814425874,
            57727.41272216753,
            58721.7528896422,
            58167.84861375856,
            58180.50145658414,
            58115.72142404893,
            58058.65960870684,
            58105.84576135331,
            57815.47461888876,
            57555.387870015315,
            57506.06807298437,
            57474.98576430212,
            57943.629057843165,
            57864.43148371131,
            57518.884140001275,
            57500.77929481661,
            57368.69249425147,
            57544.96374659641,
            57642.48628971112,
            57610.310340523756,
            57801.707574342116,
            57764.18193058321,
            57403.375409342945,
            57669.860487076316,
            57812.96915967891,
            57504.33531773738,
            57444.43455289276,
            57671.75799990867,
            56629.776997674526,
            57009.09536225692,
            56974.39138798086,
            56874.43203673815,
            56652.77633376425,
            56530.179449555064,
            56387.95830875742,
            56992.622783818544,
            57181.09163589668,
            56908.09493826477,
            56902.91387334043,
            56924.327009138164,
            56636.44312948976,
            56649.998369848996,
            56825.95829302063,
            56860.281702323526,
            56917.55558938772,
            56927.31213741791,
            56754.810633329354,
            56433.44851800957,
            56600.74528738432,
            57453.29169375094,
            58130.78114831457,
            58070.47719600076,
            57930.49833482948,
            57787.23755822543,
            58021.66564986657,
            57899.998011485266,
            58833.861160841436,
            58789.11830069634,
            58491.11446437883,
            58493.58897378262,
            58757.30471138256,
            58554.84171574884,
            57839.05673758758,
            57992.34121354044,
            57699.960140573115,
            57771.20058181922,
            58080.643272295056,
            57831.48061892176,
            57430.1839517489,
            56969.140564644826,
            57154.57504790339,
            57336.828870254896

        ]),
        priceChangePercentage24HInCurrency: 3952.64,
        currentHoldings: 1.5)    
}

// MARK: - SparklineIn7D
struct SparklineIn7D: Codable {
    let price: [Double]?
}


extension Coin: Hashable {
    
    static func == (lhs: Coin, rhs: Coin) -> Bool {
           lhs.id == rhs.id
       }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
