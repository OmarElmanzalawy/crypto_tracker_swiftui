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
        
        //uses combine to fetch data from api and make it as a publisher
        coinSubscription =  URLSession.shared.dataTaskPublisher(for: url)
        //converts the data into json format and do task in background
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { (output) -> Data in
                print("data: \(output.data)")
                guard let response = output.response
                as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode < 300 else {
                throw URLError(.badServerResponse)
                }
                return output.data
            }
            //Move back to main thread to update UI
            .receive(on: DispatchQueue.main)
            //decodes the json data into Coin model
            .decode(type: [Coin].self, decoder: JSONDecoder())
            //react to the results of decoding and updating the UI accordingly with completion handler
            .sink {(completion) in
                switch completion{
                case .finished:
                    break
                case .failure(let error):
                    print(String(describing: error))
                }
            } receiveValue: { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
                //cancel the subscription if we have received the coins as we don't need to keep listening for more updates.
                self?.coinSubscription?.cancel()
            }
    }
}
