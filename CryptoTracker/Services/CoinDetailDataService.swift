
import Foundation
import Combine

class CoinDetailDataService{
    
    @Published var coinDetail: CoinDetail? = nil
    var coinDetailSubscription: AnyCancellable?
    
    let coin: Coin
    
    init(coin: Coin) {
        self.coin = coin
        getCoinDetails()
    }
    
    func getCoinDetails(){
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else {return}
        coinDetailSubscription = NetworkingManager.downloadData(from: url)
            //decodes the json data into Coin model
            .decode(type: CoinDetail.self, decoder: JSONDecoder())
            //react to the results of decoding and updating the UI accordingly with completion handler
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedCoinDetail) in
                self?.coinDetail = returnedCoinDetail
                //cancel the subscription if we have received the coins as we don't need to keep listening for more updates.
                self?.coinDetailSubscription?.cancel()
            })
    }
}
