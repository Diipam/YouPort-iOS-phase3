////
////  BirthdayAlert.swift
////  LearningApp-Kid
////
////  Created by Anisha Lamichhane on 22/03/2023.
////  Copyright © 2023 SmartSolarNepal. All rights reserved.
////
//import UIKit
//
//extension UIAlertController {
//
//	convenience init(style: UIAlertController.Style, title: String? = nil, message: String? = nil) {
//		self.init(title: title, message: message, preferredStyle: style)
//	}
//
//	func addAlertAction(title: String, style: UIAlertAction.Style = .default, handler: ((UIAlertAction) -> Void)? = nil) {
//		let action = UIAlertAction(title: title, style: style, handler: handler)
//		addAction(action)
//	}
//
//	func setViewController(child: AllChilds) {
//		let storyboard = UIStoryboard(name: "BirthdayAlert", bundle: nil)
//		guard let viewController = storyboard.instantiateViewController(withIdentifier: BirthdayAlertViewController.identifier) as? BirthdayAlertViewController else { return }
//		viewController.child = child
//		setValue(viewController, forKey: "contentViewController")
//	}
//
//}
