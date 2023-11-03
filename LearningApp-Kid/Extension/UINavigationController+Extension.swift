//
//  UINavigationController+Extension.swift
//  LearningApp-Kid
//
//  Created by Prakash Bist on 5/11/22.
//  Copyright © 2022 SmartSolarNepal. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    static func create(rootViewController: UIViewController) -> UINavigationController {
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backButton.tintColor = .clear
        rootViewController.navigationItem.leftBarButtonItem = backButton

        let nav = UINavigationController(rootViewController: rootViewController)
        nav.modalPresentationStyle = .fullScreen
        return nav
    }
}




