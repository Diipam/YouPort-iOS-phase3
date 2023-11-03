//
//  LicenseDetailViewController.swift
//  LearningApp-Kid
//
//  Created by Anisha Lamichhane on 07/04/2023.
//  Copyright © 2023 SmartSolarNepal. All rights reserved.
//

import UIKit

class LicenseDetailViewController: UIViewController {
    static let identifier = String(describing: LicenseDetailViewController.self)

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentTextArea: UITextView!

    var licenseTitle: String = ""
    var contents : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar(isBackButtonHidden: false, isLogoHidden: true, isSettingIconHidden: true)
        setLicenseInfo(name: licenseTitle, contents: contents)
    }

    func setLicenseInfo(name: String, contents: String) {
        self.titleLabel.text = name
        self.contentTextArea.text = contents
    }

}
