//
//  ApiService.swift
//  CryptoTracker
//
//  Created by MAC on 17/06/2025.
//

//let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets")!
//https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&per_page=250&sparkline=true&price_change_percentage=24h

import Foundation
import Combine

class ApiService{
    
    @Published var allCoins: [Coin] = []
    var coinSubscription: AnyCancellable?
    
    init() {
        getCoins()
    }
    
    private func getCoins(){
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&per_page=250&sparkline=true&price_change_percentage=24h") else {return}
        coinSubscription =  NetworkingManager.downloadData(from: url)
            //decodes the json data into Coin model
            .decode(type: [Coin].self, decoder: JSONDecoder())
            //react to the results of decoding and updating the UI accordingly with completion handler
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
                //cancel the subscription if we have received the coins as we don't need to keep listening for more updates.
                self?.coinSubscription?.cancel()
            })
    }
}
