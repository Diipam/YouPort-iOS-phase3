//
//  TopViewController.swift
//  LearningApp-Kid
//
//  Created by Anisha Lamichhane on 26/09/2022.
//  Copyright © 2022 SmartSolarNepal. All rights reserved.
//

import UIKit

class TopViewController: UIViewController {

    @IBOutlet weak var getStartedButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpNavigationBar(isBackButtonHidden: true, isLogoHidden: true, isSettingIconHidden: true)
        getStartedButton.setTitle("Start".localized(), for: .normal)
        getStartedButton.cornerRadius = getStartedButton.height / 4
    }

    @IBAction func getStartedButtonPressed(_ sender: UIButton) {
        if let _ = UserSettings.deviceId.string() {
            let vc = StoryboardScene.FillParentPassword.parentPasswordInputViewController.instantiate()
            vc.child = nil
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = StoryboardScene.OnboardingScreen.onboardingViewController.instantiate()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: lock orientation
extension TopViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.portrait)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }
}

