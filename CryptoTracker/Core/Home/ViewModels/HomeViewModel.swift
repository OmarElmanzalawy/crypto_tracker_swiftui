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
    
    private let dataService = ApiService()
    private var cancellables = Set<AnyCancellable>()
    
    init(){
        addSubscribeers()
    }
    
    private func addSubscribeers(){
        dataService.$allCoins.sink { [weak self] returnedCoins in
            self?.allCoins = returnedCoins
        }
        .store(in: &cancellables)
    }
    
}
