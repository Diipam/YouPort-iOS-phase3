//
//  ParentPasswordInputViewController.swift
//  LearningApp-Kid
//
//  Created by Anisha Lamichhane on 05/08/2022.
//  Copyright © 2022 SmartSolarNepal. All rights reserved.
//

import UIKit
import ProgressHUD

class ParentPasswordInputViewController: UIViewController {
    var child: AllChilds? = nil

    @IBOutlet weak var codeTextField: OneTimeCodeTextfield!
    @IBOutlet weak var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "Enter Your Password".localized()
        setUpNavigationBar(isBackButtonHidden: false, isLogoHidden: true, isSettingIconHidden: true)
    }

    func reloadView(with child: AllChilds?) {
        AppUtility.lockOrientation(.portrait)
        self.loadViewIfNeeded()
        codeTextField.defaultCharacter = "__"
        codeTextField.configure()
        codeTextField.didEnterLastDigit = { [weak self] code in
            self?.codeTextField.resignFirstResponder()
            ProgressHUD.show()
            guard let deviceId = UserSettings.deviceId.string() else { return }
            AuthManager.shared.parentLogin(deviceId: deviceId, password: code) { result in
                DispatchQueue.main.async {
                    switch result{
                    case .success(let response):
                        ProgressHUD.dismiss()
                        HapticsManager.shared.vibrate(for: .success)
                        UserSettings.refreshToken.set(value: response.data.refresh_token)
                        UserSettings.access_token.set(value: response.data.access_token)

                        if let child = child {
                            let vc = StoryboardScene.ChildrenRegistration.childRegistrationViewController.instantiate()
                            vc.childDetail = child
                            self?.navigationController?.pushViewController(vc, animated: true)
                        } else {
                            let vc = StoryboardScene.ChooseChildren.chooseChildrenViewController.instantiate()
                            self?.navigationController?.pushViewController(vc, animated: true)
                        }
                    case .failure(let error):
                        ProgressHUD.dismiss()
                        HapticsManager.shared.vibrate(for: .error)
                        if let strongSelf = self {
                            AlertHelper.showAlert(from: strongSelf, title: "", message: error.localizedDescription) {
                                strongSelf.codeTextField.text = nil
                                strongSelf.codeTextField.setErrorState(true)
                            }
                        }
                    }
                }
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        codeTextField.becomeFirstResponder()
    }

    override func pressedBackButton() {
        if let viewControllers = navigationController?.viewControllers, viewControllers.count >= 2 {
            let containsParentRegistrationVc = viewControllers.contains(where: {$0 is ParentRegistrationViewController})
            if containsParentRegistrationVc {
                if let topvc = viewControllers.first(where: { $0 is TopViewController }) {
                    navigationController?.popToViewController(topvc, animated: true)
                }
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

// MARK: lock orientation
extension ParentPasswordInputViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        AppUtility.lockOrientation(.portrait)
        print("passwordViewController")
        print(child ?? "nothing")
        reloadView(with: child)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }

}
