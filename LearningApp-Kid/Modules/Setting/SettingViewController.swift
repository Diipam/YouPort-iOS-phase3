//
//  SettingViewController.swift
//  LearningApp-Kid
//
//  Created by Anisha Lamichhane on 30/06/2023.
//  Copyright © 2023 SmartSolarNepal. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var switchUserButton: UIButton!
    @IBOutlet weak var changeUserInformationButton: UIButton!
    @IBOutlet weak var termsOfServiceButton: UIButton!
    @IBOutlet weak var licenseInformationButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar(isBackButtonHidden: false, isLogoHidden: false, isSettingIconHidden: true)
        switchUserButton.setTitle("Change User".localized(), for: .normal)
        changeUserInformationButton.setTitle("Change Child Info".localized(), for: .normal)
        termsOfServiceButton.setTitle("Terms of Use".localized(), for: .normal)
        licenseInformationButton.setTitle("License".localized(), for: .normal)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        switchUserButton.cornerRadius = switchUserButton.height / 4
        changeUserInformationButton.cornerRadius = changeUserInformationButton.height / 4
        termsOfServiceButton.cornerRadius = termsOfServiceButton.height / 4
        licenseInformationButton.cornerRadius = licenseInformationButton.height / 4
    }

    @IBAction func switchUserButtonPressed(_ sender: UIButton) {
        AppUtility.lockOrientation(.portrait)
        let vc = StoryboardScene.SwitchUser.switchUserViewController.instantiate()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func changeUserInformationButtonPressed(_ sender: UIButton) {
        AppUtility.lockOrientation(.portrait)

        let vc = StoryboardScene.FillParentPassword.parentPasswordInputViewController.instantiate()
        vc.child = UserSettings.childInfo.childInfo()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func termsOfServiceButtonPressed(_ sender: UIButton) {
        AppUtility.lockOrientation(.portrait)
        let vc = StoryboardScene.TermsOfService.termsOfServiceViewController.instantiate()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func licenseInformationButtonPressed(_ sender: UIButton) {
        AppUtility.lockOrientation(.portrait)
        let vc = StoryboardScene.LicenseInformation.licenseInformationViewController.instantiate()
        self.navigationController?.pushViewController(vc, animated: true)
    }


}
