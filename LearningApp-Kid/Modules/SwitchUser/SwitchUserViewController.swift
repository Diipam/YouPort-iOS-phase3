//
//  ChangeUserViewController.swift
//  LearningApp-Kid
//
//  Created by Anisha Lamichhane on 13/10/2022.
//  Copyright © 2022 SmartSolarNepal. All rights reserved.
//

import UIKit
import ProgressHUD

class SwitchUserViewController: UIViewController {

	@IBOutlet weak var childrensView: UIView!
	@IBOutlet weak var titleLabel: UILabel!


	var childrens: [AllChilds]? = nil

	private lazy var childCollectionView: UICollectionView = {
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ in
			//        Item
			let item = NSCollectionLayoutItem(layoutSize:  NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
			item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom:5, trailing: 5)
			//        Group
			let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(165)), subitem: item, count: 2)
			group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
			//        Section
			let section = NSCollectionLayoutSection(group: group)
			return section
		}))
		childrensView.addSubview(collectionView)
		collectionView.register(UINib(nibName: ChildCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: ChildCollectionViewCell.identifier)

		collectionView.dataSource = self
		collectionView.delegate = self

		return collectionView
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		AppUtility.lockOrientation(.portrait)
        setUpNavigationBar(isBackButtonHidden: false, isLogoHidden: true, isSettingIconHidden: true)
		ProgressHUD.show()
		titleLabel.text = "Switch User".localized()
		ApiCaller.shared.getAllChild {[weak self] result in
			DispatchQueue.main.async {
				switch result {
				case .success(let response):
					guard let data = response.data else { return }
					self?.childrens = data
					self?.childCollectionView.reloadData()
					ProgressHUD.dismiss()

				case .failure(let error):
					HapticsManager.shared.vibrate(for: .error)
                    ProgressHUD.dismiss()
                    if let strongself = self {
                        AlertHelper.showAlert(from: strongself, title: "", message: error.localizedDescription)
                    }
				}
			}
		}
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		AppUtility.lockOrientation(.portrait)
		childCollectionView.frame = childrensView.bounds
	}

}

// MARK:  CollectionView Methods
extension SwitchUserViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return childrens?.count ?? 0
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChildCollectionViewCell.identifier, for: indexPath) as? ChildCollectionViewCell else {
			return UICollectionViewCell()
		}
		cell.childImageView.borderWidth = 1
		cell.childImageView.borderColor = .label
		//
		guard let children = childrens else { return UICollectionViewCell() }
		cell.setUp(with: children[indexPath.row])

		return cell
	}

	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		guard let cell = cell as? ChildCollectionViewCell else
		{
			return
		}

		let cellHeight : CGFloat = cell.frame.size.height
		let labelHeight : CGFloat = cell.nicknameLabel?.frame.size.height ?? 0.0
		cell.childImageView?.layer.cornerRadius = (cellHeight - labelHeight) / 2.0
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
	{
		let numberOfCellsPerRow = 2
		let otherSpace = collectionView.contentInset.left + collectionView.contentInset.right
		let width = (collectionView.frame.size.width - otherSpace) / CGFloat(numberOfCellsPerRow)
		return CGSize(width: width, height: 160) // Height can be anything 80, 90 ,100
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		collectionView.deselectItem(at: indexPath, animated: false)
		guard let children = childrens else { return }
        UserSettings.childInfo.set(value: children[indexPath.row])
        print("switch user")
        print(UserSettings.childInfo.childInfo() ?? "nothing")

        if let viewControllers = navigationController?.viewControllers, viewControllers.count >= 2 {
            if let mainVC = viewControllers.first(where: { $0 is MainViewController }) {
                navigationController?.popToViewController(mainVC, animated: true)
            }
        }
	}
}

// MARK:  Lock orientation
extension SwitchUserViewController {
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		AppUtility.lockOrientation(.portrait)

	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		AppUtility.lockOrientation(.all)

	}
}
