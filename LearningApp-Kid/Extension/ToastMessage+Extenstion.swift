////
////  ToastMessage+Extenstion.swift
////  LearningApp-Kid
////
////  Created by Anisha Lamichhane on 18/01/2023.
////  Copyright © 2023 SmartSolarNepal. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//extension UIViewController {
//	func showToast(message: String, font: UIFont) {
//		let toastLabel = UILabel()
//		toastLabel.backgroundColor = UIColor.label.withAlphaComponent(0.6)
//		toastLabel.textColor = .secondarySystemBackground
//		toastLabel.font = .systemFont(ofSize: 12.0, weight: .bold)
//		toastLabel.textAlignment = .center
//		toastLabel.numberOfLines = 0
//		toastLabel.text = message
//
////		toastLabel.sizeToFit()
//		toastLabel.alpha = 1.0
//		toastLabel.cornerRadius = toastLabel.height / 2
//		toastLabel.clipsToBounds = true
//
//		self.view.addSubview(toastLabel)
//
//		toastLabel.translatesAutoresizingMaskIntoConstraints = false
//		NSLayoutConstraint.activate([
//			toastLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//			toastLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
//			toastLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 30)
//		])
//
//		UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseIn) {
//			toastLabel.alpha = 0.0
//		} completion: { (isCompleted) in
//			toastLabel.removeFromSuperview()
//		}
//	}
//}
