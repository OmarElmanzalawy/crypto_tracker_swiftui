//
//  Statistic.swift
//  CryptoTracker
//
//  Created by MAC on 18/06/2025.
//

import Foundation

struct Statistic: Identifiable{
    
    let id = UUID().uuidString
    let title: String
    let value: String
    let percentageChange: Double?
    
    init(title: String, value: String, percentageChange: Double? = nil) {
        self.title = title
        self.value = value
        self.percentageChange = percentageChange
    }
    
    static let testStatisitc = Statistic(title: "Market Cap", value: "$12.5Bn", percentageChange: 25.34)
    
}

