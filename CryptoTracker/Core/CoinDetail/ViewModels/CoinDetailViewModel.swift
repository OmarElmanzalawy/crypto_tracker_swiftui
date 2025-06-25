
import Foundation
import Combine

class CoinDetailViewModel: ObservableObject{
    
    private let coinDetailService: CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: Coin) {
        self.coinDetailService = CoinDetailDataService(coin: coin)
        self.addSubscribers()
    }
    
    private func addSubscribers(){
        
        coinDetailService.$coinDetail
            .sink { returnedCoinDetails in
                print("Received coin details from service")
                print(returnedCoinDetails?.name)
            }
            .store(in: &cancellables)
    }
    
}
