//
//  BirthdayAlertViewController.swift
//  LearningApp-Kid
//
//  Created by Anisha Lamichhane on 22/03/2023.
//  Copyright © 2023 SmartSolarNepal. All rights reserved.
//

import UIKit
import Kingfisher
import ProgressHUD

protocol BirthdayPopup: AnyObject {
    func quizButtonPressed()
}

class BirthdayAlertViewController: UIViewController {
    static let identifier = String(String(describing: BirthdayAlertViewController.self))
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var childImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var settingButton: UIButton!
    
    var child: AllChilds?
    weak var delegate: BirthdayPopup?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setValues()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        childImageView.cornerRadius = (childImageView.image?.size.height ?? 120) / 2
        titleLabel.text = "Happy \n Birthday!".localized()
        
        preferredContentSize.height = descriptionLabel.height + settingButton.frame.origin.y + 50
    }
    
    private func setValues() {
        if let child = child  {
            let image = child.image_path ?? "boy1"
            let imageString = "\(Route.baseUrl)api/\(image)"
            childImageView.kf.setImage(with: imageString.asURL)
            nicknameLabel.text = child.nickname
        }
        descriptionLabel.text = "Due to the change of your child’s age, the difficulty level of the questions has been changed.".localized()
        settingButton.setTitle("Quiz Setting".localized(), for: .normal)
    }
    
    @IBAction func settingButtonPressed(_ sender: UIButton) {
//        ProgressHUD.show()
//            if let childDetails = self.child {
//                let nav = UINavigationController.create(rootViewController: ProblemSettingRouter.assembleModule(with: childDetails, problemSetting: childDetails.problem_settings?.first, previousView: "main"))
//                self.present(nav, animated: true)
//            }
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
    
    @IBAction func crossButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    func hide(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut) {
        } completion: { _ in
            self.dismiss(animated: false)
            self.removeFromParent()
            completion()
        }
    }
}
