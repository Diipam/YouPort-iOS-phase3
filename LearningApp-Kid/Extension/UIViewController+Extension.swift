//
//  UIViewController+Extension.swift
//  LearningApp-Kid
//
//  Created by Anisha Lamichhane on 29/06/2023.
//  Copyright © 2023 SmartSolarNepal. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func setUpNavigationBar(isBackButtonHidden: Bool, isLogoHidden: Bool, isSettingIconHidden: Bool) {
        if !isBackButtonHidden {
            let backButton = UIBarButtonItem(image: UIImage(named: "backArrow")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(pressedBackButton))
            backButton.tintColor = .label
            self.navigationItem.leftBarButtonItem = backButton
        } else {
            self.navigationItem.leftBarButtonItem = nil
        }
        
        if !isLogoHidden {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.image = UIImage(named: "logo")
            imageView.contentMode = .scaleAspectFit
            
            let contentView = UIView()
            self.navigationItem.titleView = contentView
            contentView.addSubview(imageView)
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        } else {
            self.navigationItem.titleView = nil
        }
        
        if !isSettingIconHidden {
            let right = UIBarButtonItem(image: UIImage(named: "settings")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(pressedSideMenuButton))
            self.navigationItem.rightBarButtonItem = right
        } else {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    @objc func pressedBackButton() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func pressedSideMenuButton() {
        let vc = StoryboardScene.Settings.settingViewController.instantiate()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
