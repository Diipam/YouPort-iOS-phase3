//
//  AppDelegate.swift
//  LearningApp-Kid
//
//  Created by Prakash Bist on 5/11/22.
//

import UIKit
import IQKeyboardManagerSwift
import DropDown
import SideMenu
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	var orientationLock = UIInterfaceOrientationMask.all

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		initialize()

		IQKeyboardManager.shared.enable = true
		IQKeyboardManager.shared.enableAutoToolbar = false
		IQKeyboardManager.shared.shouldResignOnTouchOutside = true

		DropDown.startListeningToKeyboard()

		window? = UIWindow(frame: UIScreen.main.bounds)

        let rootVC = StoryboardScene.LaunchScreen.rootViewController.instantiate()
        self.window?.rootViewController = rootVC

		self.window?.makeKeyAndVisible()

		return true
	}

	private func initialize(){
		UserSettings.initialize()

	}

	func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
		return self.orientationLock
	}

	func applicationWillResignActive(_ application: UIApplication) {
		NotificationCenter.default.post(name: .inactiveState, object: nil)
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		NotificationCenter.default.post(name: .activeState, object: nil)
	}

}
extension NSNotification.Name {
	static let activeState = NSNotification.Name("Active")
	static let inactiveState = NSNotification.Name("Inactive")
}

