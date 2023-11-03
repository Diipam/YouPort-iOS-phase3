//
//  Common.swift
//  LearningApp-Kid
//
//  Created by Prakash Bist on 5/11/22.
//  Copyright © 2022 SmartSolarNepal. All rights reserved.
//

import Foundation
import UIKit

class Common: NSObject {

    static let shared = Common()

    lazy var indicator: IndicatorViewController = {
        return StoryboardScene.IndicatorView.indicatorViewController.instantiate()
    }()

    override private init() {}
    
    func cardEffect(forView: UIView, roundCorner: Bool){
        forView.layer.shadowColor = UIColor.gray.cgColor
        forView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        forView.layer.shadowOpacity = 0.5
        forView.layer.shadowRadius = 6.0
        forView.layer.masksToBounds = false
        
        if roundCorner {
            forView.layer.cornerRadius = 10
        }
    }
}

