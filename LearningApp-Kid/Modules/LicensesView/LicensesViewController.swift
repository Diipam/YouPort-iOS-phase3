//
//  LicenseInformationViewController.swift
//  LearningApp-Kid
//
//  Created by Anisha Lamichhane on 13/10/2022.
//  Copyright © 2022 SmartSolarNepal. All rights reserved.
//

import UIKit

struct License {
    var title: String
    var content: String
}

class LicensesViewController: UIViewController {
    @IBOutlet weak var licenseTableView: UITableView!

    @IBOutlet weak var titleLabel: UILabel!

    var licenseInfo = [License]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar(isBackButtonHidden: false, isLogoHidden: true, isSettingIconHidden: true)
        titleLabel.text = "License".localized()
        licenseTableView.register(UINib(nibName: LicensesTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: LicensesTableViewCell.identifier)
        licenseTableView.dataSource = self
        licenseTableView.delegate = self


        // MARK: - testing only -
        if let path = Bundle.main.path(forResource: "licensesDetail", ofType: "plist"),
           let plistData = FileManager.default.contents(atPath: path),
           let plistDictionary = try? PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as? [String: Any],
           let preferenceSpecifiers = plistDictionary["PreferenceSpecifiers"] as? [[String: Any]] {
            for specifier in preferenceSpecifiers {
                if let title = specifier["Title"] as? String {
                    //					print("Title: \(title)")
                    if let path = Bundle.main.path(forResource: title, ofType: "plist") {
                        if let xml = FileManager.default.contents(atPath: path),
                           let preferences = try? PropertyListSerialization.propertyList(from: xml, options: .mutableContainers, format: nil) as? [String: Any],
                           let preferenceSpecifiers = preferences["PreferenceSpecifiers"] as? [[String: Any]],
                           let footerText = preferenceSpecifiers.first?["FooterText"] as? String {
                            //							print(footerText)
                            licenseInfo.append(License(title: title, content: footerText))
                        }
                    }

                }

            }
        }
    }

@objc override func pressedBackButton() {
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is MainViewController {
                    self.navigationController?.popToViewController(viewController, animated: true)
                    break
                }
            }
        }
    }
}

extension LicensesViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let license = licenseInfo[indexPath.row]
        let vc = StoryboardScene.LicenseInformation.licenseDetailViewController.instantiate()
        vc.licenseTitle = license.title
        vc.contents = license.content
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension LicensesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return licenseInfo.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LicensesTableViewCell.identifier, for: indexPath) as? LicensesTableViewCell else { return UITableViewCell() }
        let license = licenseInfo[indexPath.row]
        cell.titleLabel.text = license.title

        return cell
    }
}


//lock the orientation to the portrait mode
extension LicensesViewController {
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


