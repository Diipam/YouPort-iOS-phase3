//
//  Alert+Extension.swift
//  LearningApp-Kid
//
//  Created by Anisha Lamichhane on 31/10/2022.
//  Copyright © 2022 SmartSolarNepal. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

protocol notifyAlertDismiss: AnyObject {
	func isCompleted(value: Bool)
}

class MyAlert {

	struct Constant {
		static let backgroundAlphaTo: CGFloat = 0.6
	}

	public var backgroundView: UIView = {
		let backgroundView = UIView()
		backgroundView.backgroundColor = .black
		backgroundView.alpha = 0
		return backgroundView
	}()

	public var alertView: UIView = {
		let alert = UIView()
		alert.backgroundColor = .white
		alert.layer.masksToBounds = true
		alert.layer.cornerRadius = 12
		return alert
	}()

	public var alertImageView: UIImageView = {
		let image = UIImageView()
		image.image = nil
		image.contentMode = .scaleAspectFit
		image.clipsToBounds = true
		return image

	}()

	public var myTargetView: UIView?
	weak var delegate: notifyAlertDismiss?


	func showAlert(isCorrect: Bool, on viewController: UIViewController) {
		guard let preferredLanguage = Locale.preferredLanguages.first else {return}

		let correctImage = preferredLanguage.hasPrefix("ja") ? "correctAnswer_ja" : "correctAnswer_en"
		let wrongImage = preferredLanguage.hasPrefix("ja") ? "wrongAnswer_ja" : "wrongAnswer_en"


		guard let targetView = viewController.view else {
			return
		}
		targetView.addSubview(backgroundView)
		targetView.addSubview(alertView)
		alertView.backgroundColor = .clear

		alertImageView.contentMode = .scaleAspectFit
		let imageString = isCorrect ? correctImage : wrongImage
		alertImageView.image = UIImage(named: imageString)
		alertImageView.backgroundColor = .clear

		alertView.addSubview(alertImageView)

		let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gestureFired(_:)))
		gestureRecognizer.numberOfTapsRequired = 1
		gestureRecognizer.numberOfTouchesRequired = 1

		alertView.addGestureRecognizer(gestureRecognizer)
		alertImageView.addGestureRecognizer(gestureRecognizer)

		alertImageView.isUserInteractionEnabled = true
		alertView.isUserInteractionEnabled = true

		self.backgroundView.alpha = Constant.backgroundAlphaTo
		updateFrames(on: viewController)

	}

	@objc func gestureFired(_ gesture: UITapGestureRecognizer) {
		self.dismissAlert()
		self.delegate?.isCompleted(value: true)
	}

	func updateFrames(on viewcontroller: UIViewController) {
		guard let targetView = viewcontroller.view else {
			return
		}
		myTargetView = targetView
		backgroundView.frame = targetView.bounds
		alertView.frame = CGRect(x: 0 , y: 0, width: targetView.frame.size.width - 100 , height: targetView.frame.size.height - 40)
		alertImageView.frame = alertView.bounds
		alertImageView.contentMode = .scaleAspectFit

		alertImageView.center = alertView.center
		alertView.center = targetView.center

	}

	@objc func dismissAlert() {
		self.alertImageView.removeFromSuperview()
		self.alertView.removeFromSuperview()
		self.backgroundView.removeFromSuperview()
	}
}
