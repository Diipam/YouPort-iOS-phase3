//
//  IndicatorViewController.swift
//  LearningApp-Kid
//
//  Created by Prakash Bist on 5/11/22.
//  Copyright © 2022 SmartSolarNepal. All rights reserved.
//

import UIKit

class IndicatorViewController: UIViewController {

    @IBOutlet private weak var indicator: UIActivityIndicatorView! {
        didSet {
            if #available(iOS 13.0, *) {
                self.indicator.style = .large
            } else {
                self.indicator.style = .whiteLarge
            }
        }
    }
    @IBOutlet private weak var messageLabel: UILabel!

    func setMessage(message: String) {
        messageLabel.isHidden = false
        messageLabel.text = message
    }
}

