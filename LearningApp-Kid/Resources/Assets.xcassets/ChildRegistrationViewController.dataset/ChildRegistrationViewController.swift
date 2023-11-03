//
//  ChildRegistrationViewController.swift
//  LearningApp-Kid
//
//  Created by Anisha Lamichhane on 26/07/2022.
//  Copyright © 2022 SmartSolarNepal. All rights reserved.
//

import UIKit
import DropDown
import ProgressHUD
import SwiftUI

class ChildRegistrationViewController: UIViewController {
    var childDetail: AllChilds?
    var presenter: ChildRegistrationPresenterProtocol!
    
    let dropDown = DropDown()
	let genderValues = ["male".localized(),"female".localized(), "other".localized()]
    var finalDropDownLabel: String? = nil
    var date: String? = nil
    var age: String?  = nil
    var imagePathString: String? = nil
    
    //    IBOutlets

	@IBOutlet weak var sexLabel: UILabel!
	@IBOutlet weak var nicknameLabel: UILabel!
	@IBOutlet weak var dateOfBirthLabel: UILabel!
	@IBOutlet weak var ageLabel: UILabel!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var childImageView: UIImageView!
	@IBOutlet weak var selectIconButton: UIButton!
	@IBOutlet weak var nicknameTextField: UITextField!
	@IBOutlet weak var datePicker: UIDatePicker!
	@IBOutlet weak var dropDownView: UIView!
	@IBOutlet weak var dropDownLabel: UILabel!
	@IBOutlet weak var problemSettingButton: UIButton!
	@IBOutlet weak var determineButton: UIButton!
	@IBOutlet weak var ageValueLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

//        UserSettings.isChildRegistrationCompleted.set(value: true)

        setUpDropDown()
        setUpImage()
		determineButton.isEnabled = false
		determineButton.backgroundColor = UIColor(named: "standardGray")
		ageValueLabel.isHidden = true
		problemSettingButton.isEnabled = false

		dropDownView.cornerRadius = dropDownView.height / 4

        nicknameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 7, height: 0))
        nicknameTextField.leftViewMode = .always
		nicknameTextField.cornerRadius = nicknameTextField.height / 4
		self.nicknameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

		problemSettingButton.cornerRadius = problemSettingButton.height / 2
		determineButton.cornerRadius = determineButton.height / 4

		childImageView.image = UIImage(named: "addChild")

		titleLabel.text = "Child Information Registration".localized()
		selectIconButton.setTitle("Select Icon".localized(), for: .normal)
		sexLabel.text = "Sex".localized()
		nicknameLabel.text = "nickname".localized()
		dateOfBirthLabel.text = "Date of Birth".localized()
		ageLabel.text = "Age".localized()
		problemSettingButton.setTitle("Problem Setting".localized(), for: .normal)
		determineButton.setTitle("Determine".localized(), for: .normal)
		dropDownLabel.text = "Select gender".localized()
        
        datePicker.maximumDate = Date()
        datePicker.addTarget(self, action: #selector(dateSelected), for: .valueChanged)

        if let childDetail = childDetail {
            setUp(with: childDetail)
        }
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
		view.layoutIfNeeded()
        childImageView.layer.cornerRadius = childImageView.width / 2.0
    }

    @IBAction func didTapBackButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @IBAction func dropDownButtonClicked(_ sender: UIButton) {
        dropDown.show()
        
    }
    
    // MARK:  setup for update of child info
    func setUp(with child: AllChilds) {
        guard let image = child.image_path else { return }
        let imageString = "\(Route.baseUrl)api/\(image)"
        childImageView.kf.setImage(with: imageString.asURL)
//        titleLabel.setTitle("  子ども情報編集  ", for: .normal)
        nicknameTextField.text = child.nickname
        
        dropDownLabel.text = child.gender
        finalDropDownLabel = child.gender
        
        date = child.dateofbirth
        finalDropDownLabel = child.nickname
        guard let stringDate = date else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "Japanese")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        if let date = dateFormatter.date(from: stringDate){
            print("this is from the if let statement \(date)")
            datePicker.setDate(date, animated: true)
            let components = Calendar.current.dateComponents([.year,.month,.day], from: date, to: Date())
            guard let year = components.year, year > 0  else {
                return
            }
			ageValueLabel.text = "Age: \(year) years"
            age = "\(year)"
			shouldEnableDetermineButton()
        }
        
        date = dateFormatter.string(from: datePicker.date)
    }

	private func shouldEnableDetermineButton() {
		//		guard let image = childImageView.image else {
		//			print("no image")
		//			return }

		guard let nickname = nicknameTextField.text, !nickname.trimmingCharacters(in: .whitespaces).isEmpty, let gender = finalDropDownLabel, let dateOfBirth = date, let age = self.age else {
			HapticsManager.shared.vibrate(for: .warning)
			determineButton.isEnabled = false
			determineButton.backgroundColor = UIColor(named: "standardGray")
			problemSettingButton.isEnabled = false
			return
		}
		determineButton.backgroundColor = UIColor(named: "submitToggleRed")
		determineButton.isEnabled = true
		problemSettingButton.isEnabled = true

	}
    
    // MARK:  Api Calls
    //    function to handle when user clicks the problem setting
//    @objc private func problemSettingButtonClicked() {
       
//        guard let image = childImageView.image else { return }
//        if UserSettings.userHasReachedSetting.bool() && childDetail != nil {
////            print("user has reached to setting and problem Setting clicked")
//            guard let nickname = nicknameTextField.text, let dateofbirth = date, let gender = finalDropDownLabel, let age = age else { return }
//            guard let id = childDetail?.id else { return }
//            ProgressHUD.show()
//
//            AuthManager.shared.updateChildInfo(id: id, gender: gender, nickname: nickname, dateofbirth: dateofbirth, age: age, image: image) { [weak self] result in
//                DispatchQueue.main.async {
//                    switch result {
//                    case .success(_):
//                        ProgressHUD.dismiss()
//                        HapticsManager.shared.vibrate(for: .success)
//                        self?.presenter.showProblemSettingController(with: id)
//                    case .failure(let error):
//                        HapticsManager.shared.vibrate(for: .error)
//                        ProgressHUD.showError(error.localizedDescription)
//                    }
//                }
//            }
//
//        } else {
//			guard let nickname = nicknameTextField.text, !nickname.trimmingCharacters(in: .whitespaces).isEmpty, isAgeSet, let gender = finalDropDownLabel else {
//                HapticsManager.shared.vibrate(for: .warning)
//                alertUserLoginError()
//                return
//            }
//
////            print("user hasnot not reached to setting and problem Setting clicked")
//            guard let gender = finalDropDownLabel, let dateofbirth = date, let age = age else { return }
//            ProgressHUD.show()
//            AuthManager.shared.saveChildInfo(gender: gender , nickname: nickname, dateofbirth: dateofbirth, age: age, image: image) {[weak self] result in
//                DispatchQueue.main.async {
//                    switch result {
//                    case .success(let response):
//                        ProgressHUD.dismiss()
//                        HapticsManager.shared.vibrate(for: .success)
//                        self?.childDetail = response.data
//                        self?.presenter.showProblemSettingController(with: response.data.id)
//
//                    case .failure(let error):
//                        HapticsManager.shared.vibrate(for: .error)
//                        ProgressHUD.showError(error.localizedDescription)
//                    }
//                }
//            }
//        }
//    }


	@IBAction func problemSettingClicked(_ sender: UIButton) {
		ProgressHUD.show()
		guard let image = childImageView.image else {
			print("no image")
			return }

		guard let nickname = nicknameTextField.text, !nickname.trimmingCharacters(in: .whitespaces).isEmpty, let gender = finalDropDownLabel, let dateOfBirth = date, let age = self.age else {
			HapticsManager.shared.vibrate(for: .warning)
			determineButton.isEnabled = false
			determineButton.backgroundColor = UIColor(named: "standardGray")
			return
		}
//		guard let id = childDetail?.id else { return }
		AuthManager.shared.saveChildInfo(gender: gender, nickname: nickname, dateofbirth: dateOfBirth, age: age, image: image) { [weak self]  result in
			DispatchQueue.main.async {
				switch result {
				case .success(let response):
					ProgressHUD.dismiss()
					HapticsManager.shared.vibrate(for: .success)
					self?.presenter.showProblemSettingController(with: response.data.id, problemSettingId: response.data.problem_settings?.first?.id ?? nil)
				case .failure(let error):
					HapticsManager.shared.vibrate(for: .error)
					print(error)
				}
			}
		}


	}

	@IBAction func determineButtonClicked(_ sender: UIButton) {
		print("determine button pressed")
		ProgressHUD.show()
		guard let image = self.childImageView.image else {
			print("no image")
			return }

		guard let nickname = nicknameTextField.text, !nickname.trimmingCharacters(in: .whitespaces).isEmpty, let gender = finalDropDownLabel, let dateOfBirth = date, let age = self.age else {
			HapticsManager.shared.vibrate(for: .warning)
			determineButton.isEnabled = false
			determineButton.backgroundColor = UIColor(named: "standardGray")
			return
		}
//		guard let id = childDetail?.id else { return }
		AuthManager.shared.saveChildInfo(gender: gender, nickname: nickname, dateofbirth: dateOfBirth, age: age, image: image) { [weak self]  result in
			DispatchQueue.main.async {
				switch result {
				case .success(_):
					ProgressHUD.dismiss()
					HapticsManager.shared.vibrate(for: .success)
					self?.presenter.showChooseChildrenController()

					case .failure(let error):
					HapticsManager.shared.vibrate(for: .error)
					print(error)
				}
			}
		}

//		AuthManager.shared.updateChildInfo(id: id, gender: gender, nickname: nickname, dateofbirth: dateOfBirth, age: age, image: image) { [weak self] result in
//			DispatchQueue.main.async {
//				switch result {
//				case .success(let result):
//					ProgressHUD.dismiss()
//					HapticsManager.shared.vibrate(for: .success)
//					print(result)
//					self?.presenter.showChooseChildrenController()
//				case .failure(let error):
//					HapticsManager.shared.vibrate(for: .error)
//					ProgressHUD.showError(error.localizedDescription)
//				}
//			}
//		}


//		if UserSettings.userHasReachedSetting.bool() && childDetail != nil {
//			print("user has reached setting and Completed Button pressed")
//			guard let nickname = nicknameTextField.text, let dateofbirth = date, let gender = finalDropDownLabel, let age = age else {
//				alertUserLoginError()
//				return
//			}
//			guard let id = childDetail?.id else { return }
//			ProgressHUD.show()
//			AuthManager.shared.updateChildInfo(id: id, gender: gender, nickname: nickname, dateofbirth: dateofbirth, age: age, image: image) { [weak self] result in
//				DispatchQueue.main.async {
//					switch result {
//					case .success(_):
//						ProgressHUD.dismiss()
//						HapticsManager.shared.vibrate(for: .success)
//						self?.presenter.showChooseChildrenController()
//					case .failure(let error):
//						HapticsManager.shared.vibrate(for: .error)
//						ProgressHUD.showError(error.localizedDescription)
//					}
//				}
//			}
//		} else {
//			print("user hasnor not not not not not  reached setting and i am from completed")
//		guard let nickname = nicknameTextField.text, !nickname.trimmingCharacters(in: .whitespaces).isEmpty, let gender = finalDropDownLabel, let dateOfBirth = date, let age = self.age else {
//				HapticsManager.shared.vibrate(for: .warning)
//				alertUserLoginError()
//				return
//			}
//
//			ProgressHUD.show()
//			AuthManager.shared.saveChildInfo(gender: gender , nickname: nickname, dateofbirth: dateofbirth, age: age, image: image) {[weak self] result in
//				DispatchQueue.main.async {
//					switch result {
//					case .success(let response):
//						AuthManager.shared.saveProblemSetting(childId: response.data.id, questionFrequency: "5", answerTime: "1", problemDifficulty: "Easy", correctAnswerQuota: "1") { _ in
//							print("completed")
//						}
//						ProgressHUD.dismiss()
//						HapticsManager.shared.vibrate(for: .success)
//						self?.presenter.showChooseChildrenController()
//
//					case .failure(let error):
//						HapticsManager.shared.vibrate(for: .error)
//						ProgressHUD.showError(error.localizedDescription)
//					}
//				}
//			}
//
////		}
	}
    
}

// MARK:  Functions
// MARK:  childRegisterViewProtocol
extension ChildRegistrationViewController: ChildRegistrationViewProtocol {
    
    private func setUpImage() {
        childImageView.image = UIImage(named: "mainIconBig")
        childImageView.contentMode = .scaleAspectFill
        childImageView.layer.masksToBounds = true
        childImageView.layer.borderWidth = 1
        childImageView.layer.borderColor = UIColor.lightGray.cgColor
        
        
        childImageView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfile))
        childImageView.addGestureRecognizer(gesture)
        
    }
    
    @objc private func didTapChangeProfile() {
        presentPhotoActionSheet()
    }
    
    @objc private func dateSelected() {
		let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        date = dateFormatter.string(from: datePicker.date)
        
        let components = Calendar.current.dateComponents([.year,.month,.day], from: datePicker.date, to: Date())
        guard let year = components.year , year > 0 else {
            return
        }
		ageValueLabel.isHidden = false
		ageValueLabel.text = "\(year) " + "years".localized()
        age = "\(year)"
		shouldEnableDetermineButton()
		print("no date")
    }
    
}
// MARK:  Functions
extension ChildRegistrationViewController {
    func addOrSubtractMonth(month:Int)->Date{
        return Calendar.current.date(byAdding: .month, value: month, to: Date())!
    }
    
    func addOrSubtractYear(year:Int)->Date{
        return Calendar.current.date(byAdding: .year, value: year, to: Date())!
    }

    private func setUpDropDown() {
		dropDownView.borderWidth = 1
		dropDownView.borderColor = .lightGray
		dropDownView.cornerRadius = dropDownView.height / 4
        dropDown.anchorView = dropDownView
        dropDown.dataSource = genderValues
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.direction = .any
        dropDown.dismissMode = .automatic
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.dropDownLabel.text = genderValues[index]
            finalDropDownLabel = dropDownLabel.text!
        }
		shouldEnableDetermineButton()
		print("no gender")
    }

	@objc private func textFieldDidChange(_ textField: UITextField) {
		guard let nickname = nicknameTextField.text else { return }
		if nickname.count >= 2 {
			shouldEnableDetermineButton()
		} else {
			determineButton.backgroundColor = UIColor(named: "standardGray")
			determineButton.isEnabled = false
			problemSettingButton.isEnabled = false
		}
   }
}
// MARK:  Choosing a image for profile picture or taking photo for profile picture
extension ChildRegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil , preferredStyle: .actionSheet)
		actionSheet.addAction(UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil))
//                                                   Take a Photo
		actionSheet.addAction(UIAlertAction(title: "Take Photo".localized(), style: .default, handler: {[weak self] _ in
            self?.presentCamera()
        }))
        
		actionSheet.addAction(UIAlertAction(title: "Choose existing photo".localized(), style: .default, handler: { [weak self] _ in
            self?.presentPhotoPicker()
        }))
		actionSheet.addAction(UIAlertAction(title: "Use avatar".localized(), style: .default, handler: nil))

        
        self.present(actionSheet, animated: true)
        
    }
    
    private func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    private func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else {
           
            return
        }
        self.childImageView.image = selectedImage
//		print(selectedImage)
        dismiss(animated: true)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK:  Lock orientation
extension ChildRegistrationViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.portrait)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation(.all)
        
    }
}
