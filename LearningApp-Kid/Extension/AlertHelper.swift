//
//  AlertHelper.swift
//  LearningApp-Kid
//
//  Created by Anisha Lamichhane on 04/07/2023.
//  Copyright © 2023 SmartSolarNepal. All rights reserved.
//

import UIKit

class AlertHelper {
    static func showAlert<T: UIViewController>(from viewController: T, title: String, message: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        }
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
}
