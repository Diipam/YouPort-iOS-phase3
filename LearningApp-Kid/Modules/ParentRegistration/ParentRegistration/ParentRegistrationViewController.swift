//
//  ParentRegistrationViewController.swift
//  LearningApp-Kid
//
//  Created by Anisha Lamichhane on 26/07/2022.
//  Copyright © 2022 SmartSolarNepal. All rights reserved.
//

import UIKit
import ProgressHUD

class ParentRegistrationViewController: UIViewController {
    var iconClick1 = true
    var iconClick2 = true
    
	@IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var passwordView: UIStackView!
    @IBOutlet weak var confirmPasswordView: UIStackView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var eyeButton1: UIButton!
    @IBOutlet weak var eyeButton2: UIButton!
	@IBOutlet weak var determineButton: UIButton!
	@IBOutlet weak var enterPasswordLabel: UILabel!
	@IBOutlet weak var confirmPasswordLabel: UILabel!
	@IBOutlet weak var errorLabel1: UILabel!
	@IBOutlet weak var errorLabel2: UILabel!
	@IBOutlet weak var errorLabel: UILabel!

	override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpNavigationBar(isBackButtonHidden: true, isLogoHidden: true, isSettingIconHidden: true)
		errorLabel.isHidden = true
		determineButton.isEnabled = false
		determineButton.backgroundColor = UIColor(named: "standardGray")

		titleLabel.text = "Set Parent Password".localized()
		enterPasswordLabel.text = "Password".localized()
		confirmPasswordLabel.text = "Confirm Password".localized()
		errorLabel1.text = "*Please set a 4-digit password.".localized()
		errorLabel2.text = "*If you forget your password, you will need to reinstall the app and start from the initial settings.".localized()
		determineButton.setTitle("Apply".localized(), for: .normal)
		determineButton.cornerRadius = determineButton.height / 4

        passwordTextField.returnKeyType = .continue
        passwordTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        passwordTextField.leftViewMode = .always
		self.passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        confirmPasswordTextField.returnKeyType = .done
        confirmPasswordTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        confirmPasswordTextField.leftViewMode = .always
		self.confirmPasswordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)


        determineButton.addTarget(self, action: #selector(DetermineButtonPressed), for: .touchUpInside)
        
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
    }
    
    @IBAction func eye1Clicked(_ sender: UIButton) {
        if(iconClick1 == true) {
            passwordTextField.isSecureTextEntry = true
            eyeButton1.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        } else {
            passwordTextField.isSecureTextEntry = false
            eyeButton1.setImage(UIImage(systemName: "eye"), for: .normal)
        }
        
        iconClick1 = !iconClick1
    }
    
    @IBAction func eye2Clicked(_ sender: UIButton) {
        if(iconClick2 == true) {
            confirmPasswordTextField.isSecureTextEntry = true
            eyeButton2.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            
        } else {
            confirmPasswordTextField.isSecureTextEntry = false
            eyeButton2.setImage(UIImage(systemName: "eye"), for: .normal)
        }
        
        iconClick2 = !iconClick2
    }
}

// MARK:  TextField Delegate methods
extension ParentRegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == passwordTextField {
            guard let password = passwordTextField.text, !password.trimmingCharacters(in: .whitespaces).isEmpty , password.count == 4 else {
                return false
            }
            passwordTextField.resignFirstResponder()
            confirmPasswordTextField.becomeFirstResponder()
            
        } else if textField == confirmPasswordTextField {
            guard let confirmedPassword = confirmPasswordTextField.text, let password = passwordTextField.text, !confirmedPassword.trimmingCharacters(in: .whitespaces).isEmpty , confirmedPassword == password else {
                return false
            }
			determineButton.backgroundColor = UIColor(named: "submitToggleRed")
			determineButton.isEnabled = true
            DetermineButtonPressed()
        }
        
        return true
    }

	@objc private func textFieldDidChange(_ textField: UITextField) {
		switch textField {
		case passwordTextField:
			if passwordTextField.text?.count == 4 && passwordTextField.text == confirmPasswordTextField.text {
				determineButton.isEnabled = true
				determineButton.backgroundColor = UIColor(named: "submitToggleRed")
			} else {
				determineButton.isEnabled = false
				determineButton.backgroundColor = UIColor(named: "standardGray")
			}

		case confirmPasswordTextField:
			if confirmPasswordTextField.text?.count == 4 && confirmPasswordTextField.text == passwordTextField.text {
				determineButton.isEnabled = true
				determineButton.backgroundColor = UIColor(named: "submitToggleRed")
			} else {
				determineButton.isEnabled = false
				determineButton.backgroundColor = UIColor(named: "standardGray")
			}
		default:
			print("default textfield")
		}
   }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 4
        guard let characterCount = textField.text?.count else { return false }
        return characterCount < maxLength || string == ""
    }
}

//MARK: - RegisterView - & Functions
extension ParentRegistrationViewController {
    @objc private func DetermineButtonPressed() {
        passwordTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()
        
        guard let password = passwordTextField.text, let confirmedPassword = confirmPasswordTextField.text, !password.trimmingCharacters(in: .whitespaces).isEmpty ,!confirmedPassword.trimmingCharacters(in: .whitespaces).isEmpty, password.count == 4, confirmedPassword.count == 4, password == confirmedPassword else {
			print("the password you entered is not correct")
            return
        }
        
        let deviceId = UIDevice.current.identifierForVendor!.uuidString + UUID().uuidString
        UserSettings.deviceId.set(value: deviceId)
//        print(UserSettings.deviceId.string())
        ProgressHUD.show()
        AuthManager.shared.registerParent(deviceId: deviceId, password: password, appversion: "version1") {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    ProgressHUD.dismiss()
                    HapticsManager.shared.vibrate(for: .success)
                    let vc = StoryboardScene.FillParentPassword.parentPasswordInputViewController.instantiate()
                    vc.child = nil
                    self?.navigationController?.pushViewController(vc, animated: true)

                case .failure(let error):
                    HapticsManager.shared.vibrate(for: .error)
                    ProgressHUD.dismiss()
                    if let strongSelf = self {
                        HapticsManager.shared.vibrate(for: .error)
                        AlertHelper.showAlert(from: strongSelf, title: "", message: error.localizedDescription)
                    }
                }
            }
        }
    }
}

//lock the orientation to the portrait mode
extension ParentRegistrationViewController {
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
		passwordTextField.becomeFirstResponder()
       AppUtility.lockOrientation(.portrait)

    }
    override func viewWillDisappear(_ animated: Bool) {
       super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
       // Don't forget to reset when view is being removed
       AppUtility.lockOrientation(.all)
    }

}
