//
//  CardView.swift
//  LearningApp-Kid
//
//  Created by Anisha Lamichhane on 08/08/2022.
//  Copyright © 2022 SmartSolarNepal. All rights reserved.
//

import Foundation
import UIKit
 
class CardView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        intialSetUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        intialSetUp()
    }
    
  func intialSetUp() {
        layer.shadowColor = UIColor.label.cgColor
        layer.shadowOffset = .zero
        layer.cornerRadius = 10
        layer.shadowOpacity = 0.3
        cornerRadius = 10
    }
    
}
