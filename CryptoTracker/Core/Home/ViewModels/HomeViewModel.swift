//
//  HomeViewModel.swift
//  CryptoTracker
//
//  Created by MAC on 17/06/2025.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject{
    
    @Published var allCoins: [Coin] = []
    @Published var portfolioCoins: [Coin] = []
    @Published var searchText: String = ""
    
    private let dataService = ApiService()
    private var cancellables = Set<AnyCancellable>()
    
    init(){
        addSubscribeers()
    }
    
    private func addSubscribeers(){
//        dataService.$allCoins.sink { [weak self] returnedCoins in
//            self?.allCoins = returnedCoins
//        }
//        .store(in: &cancellables)
//        
        $searchText
            .combineLatest(dataService.$allCoins)
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
    }
    
}
