//
//  String.swift
//  CryptoTracker
//
//  Created by MAC on 04/07/2025.
//

import Foundation

extension String{
    var removeHTMLOccurences: String{
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
