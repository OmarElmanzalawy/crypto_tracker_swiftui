//
//  Date.swift
//  CryptoTracker
//
//  Created by MAC on 03/07/2025.
//

import Foundation

extension Date{
    
    init(coinGeckgoString: String){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd 'T'HH: mm: ss.SSSZ"
        let date = formatter.date(from: coinGeckgoString) ?? Date()
        self.init(timeInterval: 0, since: date)
    }
    
    private var shortFormatter: DateFormatter{
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    func asShortDateString() -> String{
        return shortFormatter.string(from: self)
    }
}
