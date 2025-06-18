//
//  UIApplication.swift
//  CryptoTracker
//
//  Created by MAC on 18/06/2025.
//

import Foundation
import SwiftUI

extension UIApplication{
    
    //function to dismiss keyboard
    func endEditing(){
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
