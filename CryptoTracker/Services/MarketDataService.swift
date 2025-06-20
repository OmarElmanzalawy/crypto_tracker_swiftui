import Foundation
import Combine

class MarketDataService{
    
    @Published var marketData: MarketData? = nil
    
    var marketDataSubscription: AnyCancellable?
    
    init() {
        getData()
    }
    
    func getData(){
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else {return}
        marketDataSubscription =  NetworkingManager.downloadData(from: url)
            //decodes the json data into Coin model
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            //react to the results of decoding and updating the UI accordingly with completion handler
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedData) in
                self?.marketData = returnedData.data
                //cancel the subscription if we have received the coins as we don't need to keep listening for more updates.
                self?.marketDataSubscription?.cancel()
            })
    }
}
