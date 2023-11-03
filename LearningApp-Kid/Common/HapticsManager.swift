//
//  HapticsManager.swift
//  LearningApp-Kid
//
//  Created by Anisha Lamichhane on 18/08/2022.
//  Copyright © 2022 SmartSolarNepal. All rights reserved.
//

import UIKit

final class HapticsManager {
    static let shared = HapticsManager()
    
    private init() { }
    
    public func selectionVibrate() {
        DispatchQueue.main.async {
            let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
            selectionFeedbackGenerator.prepare()
            selectionFeedbackGenerator.selectionChanged()
        }
    }
    
    public func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
        DispatchQueue.main.async {
            let notificationGenerator = UINotificationFeedbackGenerator()
            notificationGenerator.prepare()
            notificationGenerator.notificationOccurred(type)
        }
    }
}
