//
//  ChildRegistrationViewController.swift
//  LearningApp-Kid
//
//  Created by Anisha Lamichhane on 26/07/2022.
//  Copyright © 2022 SmartSolarNepal. All rights reserved.
//

import UIKit
import DropDown
import Kingfisher
import ProgressHUD

class ChildRegistrationViewController: UIViewController {
    var childDetail: AllChilds?
//    var presenter: ChildRegistrationPresenterProtocol!
    
    let dropDown = DropDown()
    let genderValues = ["male","female", "other"]
    let ageValues = ["0","1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51", "52", "53", "54", "55", "56", "57", "58", "59", "60", "61", "62", "63", "64", "65", "66", "67", "68", "69", "70", "71", "72", "73", "74", "75", "76", "77", "78", "79", "80", "81", "82", "83", "84", "85", "86", "87", "88", "89", "90", "91", "92", "93", "94", "95", "96", "97", "98", "99"]

    let japaneseGenderValues = ["male".localized(),"female".localized(), "other".localized()]
    var finalGenderValues: String? = nil
    var date: String = ""
    var imagePathString: String? = nil

    let AvatarScreenVc = StoryboardScene.ChildrenRegistration.avatarSelectionViewController.instantiate()
//    let AvatarScreenVc = StoryboardScene.ChildrenRegistration.avatarSelectionViewController.instantiate()

    //    IBOutlets

    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var childImageView: UIImageView!
    @IBOutlet weak var selectIconButton: UIButton!
    @IBOutlet weak var nicknameTextField: UITextField!
    
    @IBOutlet weak var genderDropDownView: UIView!
    @IBOutlet weak var genderDropDownLabel: UILabel!
    @IBOutlet weak var problemSettingButton: UIButton!
    @IBOutlet weak var determineButton: UIButton!

    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var ageValueLabel: UILabel!
    @IBOutlet weak var ageDropDownView: UIView!


    let deleteButton = {
        let button = UIButton()
        button.setTitle("Delete".localized(), for: .normal)
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.red.cgColor
        button.configuration = .plain()
        button.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
        button.configuration?.baseForegroundColor = .label
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadViewIfNeeded()
        view.layoutIfNeeded()

        setUpNavigationBar(isBackButtonHidden: false, isLogoHidden: true, isSettingIconHidden: true)

        setUpImage(with: "boy1")
//        determineButton.isEnabled = true

        determineButton.isEnabled = false
        determineButton.backgroundColor = UIColor(named: "standardGray")
        problemSettingButton.isEnabled = false

        genderDropDownView.borderColor = .label
        genderDropDownView.borderWidth = 2
        genderDropDownView.cornerRadius = genderDropDownView.height / 4
        
        ageDropDownView.borderColor = .label
        ageDropDownView.borderWidth = 2
        ageDropDownView.cornerRadius = genderDropDownView.height / 4

        nicknameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 7, height: 0))
        nicknameTextField.leftViewMode = .always
        self.nicknameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        titleLabel.text = "Child Information".localized()
        selectIconButton.setTitle("Select Icon".localized(), for: .normal)
        genderLabel.text = "Gender".localized()
        nickNameLabel.text = "Nickname".localized()
        
        ageLabel.text = "Age".localized()
        problemSettingButton.setTitle("Quiz Setting".localized(), for: .normal)
        determineButton.setTitle("Apply".localized(), for: .normal)
        genderDropDownLabel.text = "Select Gender".localized()

        deleteButton.isHidden = true
        deleteButton.addTarget(self, action: #selector(deleteUserButtonPressed), for: .touchUpInside)
        let rightBarButtonItem = UIBarButtonItem(customView: deleteButton)
        self.navigationItem.rightBarButtonItem = rightBarButtonItem

        AvatarScreenVc.delegate = self
        
        //updated one with removal of dateofbirth
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = Date()

        let stringDate = dateFormatter.string(from: currentDate)
        self.date = stringDate

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
        nicknameTextField.cornerRadius = nicknameTextField.height / 4

        childImageView.layer.cornerRadius = childImageView.width / 2.0
        problemSettingButton.cornerRadius = problemSettingButton.height / 2
        determineButton.cornerRadius = determineButton.height / 4

        deleteButton.cornerRadius = deleteButton.height / 4
    }
    
    @IBAction func genderDropDownButtonClicked(_ sender: UIButton) {
        setUpDropDown(with: genderDropDownView)
        dropDown.dataSource = japaneseGenderValues
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.genderDropDownLabel.text = japaneseGenderValues[index]
            finalGenderValues = genderValues[index]
            shouldEnableDetermineButton()
        }
    }
    
    @IBAction func ageDropDownButtonClicked(_ sender: UIButton) {
        setUpDropDown(with: ageDropDownView)
        dropDown.dataSource = ageValues
        dropDown.show()

        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            ageValueLabel.text = ageValues[index]
            shouldEnableDetermineButton()
            let age = Int(ageValueLabel.text!) ?? 0
            updateDifficulty(age: age)
        }
    }
    
    @IBAction func selectIconClicked(_ sender: UIButton) {
        showAvatarScreen()
    }

    private func showAvatarScreen() {
        AvatarScreenVc.modalPresentationStyle = .fullScreen
        self.present(AvatarScreenVc, animated: true)
    }
    
    // MARK:  setup for update of child info
    func setUp(with child: AllChilds) {

        self.loadViewIfNeeded()
        view.layoutIfNeeded()

        deleteButton.isHidden = false
        shouldEnableDetermineButton()

        guard let image = child.image_path else { return }
        let imageString = "\(Route.baseUrl)api/\(image)"
        childImageView.kf.setImage(with: imageString.asURL)

        titleLabel.text = "Change Child Info".localized()
        nicknameTextField.text = child.nickname
        
        genderDropDownLabel.text = child.gender.localized()
        finalGenderValues = child.gender
        ageValueLabel.text = "\(child.age)"
        shouldEnableDetermineButton()
    }

    private func shouldEnableDetermineButton() {
        loadViewIfNeeded()
        view.layoutIfNeeded()
        guard let nickname = nicknameTextField.text, !nickname.trimmingCharacters(in: .whitespaces).isEmpty, let gender = finalGenderValues, !gender.isEmpty,let age = ageValueLabel.text, !age.isEmpty else {
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

    @objc func deleteUserButtonPressed() {
        let actionSheet = UIAlertController(title: nil, message: nil , preferredStyle: .actionSheet)

        actionSheet.addAction(UIAlertAction(title: "Delete Child".localized(), style: .destructive, handler: {[weak self] _ in
            self?.deleteUser()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil))

        self.present(actionSheet, animated: true)

    }

    @objc func deleteUser() {
        guard let childId = self.childDetail?.id else { return }

        ApiCaller.shared.deleteChild(childId: childId) { [weak self] result in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                switch result {
                case .success(_):
                    AlertHelper.showAlert(from: strongSelf, title: "", message: "Child Deletion Successful".localized()) {
                        if let chooseChildVc = strongSelf.navigationController?.viewControllers.first(where: { $0 is ChooseChildrenViewController }) {
                            strongSelf.navigationController?.popToViewController(chooseChildVc, animated: true)
                        }
                    }
                case .failure(let error):
                    AlertHelper.showAlert(from: strongSelf, title: "", message: error.localizedDescription)
                }
            }
        }
    }

    @IBAction func problemSettingClicked(_ sender: UIButton) {
        ProgressHUD.show()
        guard let image = childImageView.image else {
            print("no image")
            return }

        guard let nickname = nicknameTextField.text, !nickname.trimmingCharacters(in: .whitespaces).isEmpty, let gender = finalGenderValues,let age = self.ageValueLabel.text else {
            HapticsManager.shared.vibrate(for: .warning)
            determineButton.isEnabled = false
            determineButton.backgroundColor = UIColor(named: "standardGray")
            return
        }

        if let childDetail = childDetail {
            ApiCaller.shared.updateChildInfo(id: childDetail.id, gender: gender, nickname: nickname, dateofbirth: date, age: age, image: image) { [weak self] result in
                //                                print(result)
                switch result {
                case .success( _):
                    ApiCaller.shared.getAllChildById(childId: childDetail.id) { result1 in
                        switch result1 {
                        case .success(let response1):
                            DispatchQueue.main.async {
                                ProgressHUD.dismiss()
                                HapticsManager.shared.vibrate(for: .success)
                                let vc = StoryboardScene.ProblemSetting.problemSettingViewController.instantiate()
                                vc.childDetail = response1.data
                                vc.problemSettings = response1.data.problem_settings?.first
                                self?.navigationController?.pushViewController(vc, animated: true)
                            }
                        case .failure(let error):
                            ProgressHUD.dismiss()
                            if let strongSelf = self {
                                HapticsManager.shared.vibrate(for: .error)
                                AlertHelper.showAlert(from: strongSelf, title: "", message: error.localizedDescription)
                            }
                        }
                    }

                case .failure(let error):
                    ProgressHUD.dismiss()
                    if let strongSelf = self {
                        HapticsManager.shared.vibrate(for: .error)
                        AlertHelper.showAlert(from: strongSelf, title: "", message: error.localizedDescription)
                    }
                }
            }
        } else {
            ApiCaller.shared.saveChildInfo(gender: gender, nickname: nickname, dateofbirth: date, age: age, image: image) { [weak self]  result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        ProgressHUD.dismiss()
                        HapticsManager.shared.vibrate(for: .success)
                        UserSettings.isChildRegistered.set(value: true)

                        let vc = StoryboardScene.ProblemSetting.problemSettingViewController.instantiate()
                        vc.childDetail = response.data
                        vc.problemSettings = response.data.problem_settings?.first ?? nil
                        self?.navigationController?.pushViewController(vc, animated: true)
                    case .failure(let error):
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

    @IBAction func determineButtonClicked(_ sender: UIButton) {
        ProgressHUD.show()
        guard let image = self.childImageView.image else {
            print("no image")
            return }

        guard let nickname = nicknameTextField.text, !nickname.trimmingCharacters(in: .whitespaces).isEmpty, let gender = finalGenderValues, let age = self.ageValueLabel.text else {
            HapticsManager.shared.vibrate(for: .warning)
            determineButton.isEnabled = false
            determineButton.backgroundColor = UIColor(named: "standardGray")
            return
        }

        if let childDetail = childDetail {
            ApiCaller.shared.updateChildInfo(id: childDetail.id, gender: gender, nickname: nickname, dateofbirth: date, age: age, image: image) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        ProgressHUD.dismiss()
                        HapticsManager.shared.vibrate(for: .success)
                        if let strongSelf = self {
                            AlertHelper.showAlert(from: strongSelf, title: "", message: "Child Updated successfully".localized()) {
                                if let viewControllers = strongSelf.navigationController?.viewControllers, viewControllers.count >= 2 {
                                    if let _ = viewControllers[viewControllers.count - 2] as? ParentPasswordInputViewController  {
                                        strongSelf.navigationController?.popToViewController(viewControllers[viewControllers.count - 3], animated: true )
                                    } else {
                                        strongSelf.navigationController?.popViewController(animated: true)
                                    }
                                }
                            }
                        }
                    case .failure(let error):
                        ProgressHUD.dismiss()
                        if let strongSelf = self {
                            HapticsManager.shared.vibrate(for: .error)
                            AlertHelper.showAlert(from: strongSelf, title: "", message: error.localizedDescription)
                        }
                    }
                }
            }

        } else {
            ApiCaller.shared.saveChildInfo(gender: gender, nickname: nickname, dateofbirth: date, age: age, image: image) { [weak self]  result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        let age = response.data.age
                        guard let problemDifficulty = self?.giveProblemDifficulty(age: age) else { return }
//                        print(problemDifficulty)
                        ApiCaller.shared.saveProblemSetting(childId: response.data.id, questionFrequency: "5", answerTime: "1", problemDifficulty: "\(problemDifficulty)", correctAnswerQuota: "1") { [weak self]  result in
                            DispatchQueue.main.async {
                                switch result {
                                case .success(_):
                                    ProgressHUD.dismiss()
                                    HapticsManager.shared.vibrate(for: .success)
                                    UserSettings.isChildRegistered.set(value: true)

                                    if let strongSelf = self {
                                        AlertHelper.showAlert(from: strongSelf, title: "", message: "Child Created Successfully".localized()) {
                                            if let viewControllers = strongSelf.navigationController?.viewControllers, viewControllers.count >= 2 {
                                                if let chooseChildVc = viewControllers[viewControllers.count - 2] as? ChooseChildrenViewController  {
                                                    strongSelf.navigationController?.popToViewController(chooseChildVc, animated: true )
                                                } else {
                                                    let vc = StoryboardScene.ChooseChildren.chooseChildrenViewController.instantiate()
                                                    self?.navigationController?.pushViewController(vc, animated: true)
                                                }
                                            }
                                        }
                                    }

                                case .failure(let error):
                                    ProgressHUD.dismiss()
                                    if let strongSelf = self {
                                        HapticsManager.shared.vibrate(for: .error)
                                        AlertHelper.showAlert(from: strongSelf, title: "", message: error.localizedDescription)
                                    }
                                }
                            }
                        }

                    case .failure(let error):
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

    override func pressedBackButton() {
        if let viewControllers = navigationController?.viewControllers, viewControllers.count >= 2 {
            if let _ = viewControllers[viewControllers.count - 2] as? ParentPasswordInputViewController  {
                navigationController?.popToViewController(viewControllers[viewControllers.count - 3], animated: true )
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

// MARK:  Functions
// MARK:  childRegisterViewProtocol
extension ChildRegistrationViewController {
    
    private func setUpImage(with image: String) {
        childImageView.image = UIImage(named: image)
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
}
// MARK:  Functions
extension ChildRegistrationViewController {
    func updateDifficulty(age: Int) {
        if let childDetail = childDetail {
            print(childDetail.problem_settings!)
            if let problemSetting = childDetail.problem_settings?.first {
                let problemDifficulty = giveProblemDifficulty(age: age)

                ApiCaller.shared.updateProblemSetting(childId: childDetail.id, id: problemSetting.id, questionFrequency: "\(problemSetting.question_frequency)", answerTime: "\(problemSetting.answer_time)", problemDifficulty: "\(problemDifficulty)", correctAnswerQuota: "\(problemSetting.correct_answer_quota)") { result in
                    DispatchQueue.main.async {
                        switch result{

                        case .success(_):
                            print("")

                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }
    }

    func giveProblemDifficulty(age: Int) -> Int {
        if (0...3).contains(age) {
            return 1
        } else if (4...6).contains(age) {
            return 2
        } else {
            return 3
        }
    }
    
    private func setUpDropDown(with anchorView: UIView) {
        dropDown.anchorView = anchorView
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.direction = .bottom
        dropDown.dismissMode = .automatic
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

// MARK:  ReturnAvatar Images to set the childview
extension ChildRegistrationViewController: ReturnAvatarImageString {
    func setImageString(value: String) {
        setUpImage(with: value)
    }
}

// MARK:  Choosing a image for profile picture or taking photo for profile picture
extension ChildRegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func presentPhotoActionSheet() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            let actionSheet = UIAlertController(title: "", message: "" , preferredStyle: .actionSheet)

            actionSheet.addAction(UIAlertAction(title: "Choose from library".localized(), style: .default, handler: { [weak self] _ in
                self?.presentPhotoPicker()
            }))
            actionSheet.addAction(UIAlertAction(title: "Use avatar".localized(), style: .default, handler:{ [weak self] _ in
                self?.showAvatarScreen()
            }))

            actionSheet.addAction(UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil))

            if let popoverController = actionSheet.popoverPresentationController {

                popoverController.sourceView = self.view
                let size = view.width / 2
                let padding = CGFloat(100)
                popoverController.sourceRect = CGRect(x: size / 2 , y: view.bottom , width: size , height: actionSheet.preferredContentSize.height + padding)
            }

            self.present(actionSheet, animated: true, completion: nil)

        } else {
            let actionSheet = UIAlertController(title: nil, message: nil , preferredStyle: .actionSheet)
            //                                                   Take a Photo
            actionSheet.addAction(UIAlertAction(title:"Take a photo".localized(), style: .default, handler: {[weak self] _ in
                self?.presentCamera()
            }))

            actionSheet.addAction(UIAlertAction(title: "Choose from library".localized(), style: .default, handler: { [weak self] _ in
                self?.presentPhotoPicker()
            }))
            actionSheet.addAction(UIAlertAction(title: "Use avatar".localized(), style: .default, handler:{ [weak self] _ in
                self?.showAvatarScreen()
            }))
            actionSheet.addAction(UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil))

            self.present(actionSheet, animated: true)
        }
        
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

        if let child = childDetail {
            self.setUp(with: child)
            self.deleteButton.isHidden = false
        }else {
            self.deleteButton.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation(.all)
        
    }
}
