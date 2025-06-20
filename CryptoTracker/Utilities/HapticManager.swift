//
//  HapticManager.swift
//  CryptoTracker
//
//  Created by MAC on 21/06/2025.
//

import Foundation
import SwiftUI

class HapticManager{
    static private let generator = UINotificationFeedbackGenerator()
    
    //triggers haptic feedback vibration of given type
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType){
        generator.notificationOccurred(type)
    }
}
