//
//  ChooseChildrenViewController.swift
//  LearningApp-Kid
//
//  Created by Anisha Lamichhane on 02/08/2022.
//  Copyright © 2022 SmartSolarNepal. All rights reserved.
//

import UIKit
import ProgressHUD
import Kingfisher

class ChooseChildrenViewController: UIViewController {
    
	@IBOutlet weak var ChildrensView: UIView!
	@IBOutlet weak var titleLabel: UILabel!

	var childrens: [AllChilds] = []
	var childrenCount: Int? = nil

	private lazy var childCollectionView: UICollectionView = {
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ in
			//        Item
			let item = NSCollectionLayoutItem(layoutSize:  NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
			item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom:0, trailing: 0)
			//        Group
			let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(170)), subitem: item, count: 2)
			group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20)
			//        Section
			let section = NSCollectionLayoutSection(group: group)
			section.contentInsets = NSDirectionalEdgeInsets(top: 50, leading: 5, bottom: 0, trailing: 5)

			return section
		}))
		ChildrensView.addSubview(collectionView)
		collectionView.register(UINib(nibName: ChildCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: ChildCollectionViewCell.identifier)

		collectionView.dataSource = self
		collectionView.delegate = self

		return collectionView
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
        setUpNavigationBar(isBackButtonHidden:false, isLogoHidden: true, isSettingIconHidden: true)
		titleLabel.text = "Select Your Child".localized()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		AppUtility.lockOrientation(.portrait)
		childCollectionView.frame = ChildrensView.bounds
	}

    override func pressedBackButton() {

        if let viewControllers = navigationController?.viewControllers, viewControllers.count >= 3 {
            if let _ = viewControllers[viewControllers.count - 2] as? ParentPasswordInputViewController  {
                navigationController?.popToViewController(viewControllers[viewControllers.count - 3], animated: true )
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    func getAllChild () {
        ProgressHUD.show()
        ApiCaller.shared.getAllChild {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    //                    print(response)
                    guard let data = response.data else { return }
                    self?.childrens = data
                    self?.childrenCount = data.count + 1
                    self?.childCollectionView.reloadData()
                    ProgressHUD.dismiss()

                case .failure(let error):
                    HapticsManager.shared.vibrate(for: .error)
                    ProgressHUD.dismiss()
                    if let strongSelf = self {
                        AlertHelper.showAlert(from: strongSelf, title: "", message: error.localizedDescription)
                    }
                }
            }
        }
    }
}

// MARK:  CollectionView Methods
extension ChooseChildrenViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.childrenCount ?? 0
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChildCollectionViewCell.identifier, for: indexPath) as? ChildCollectionViewCell else {
			return UICollectionViewCell()
		}
		cell.childImageView.borderWidth = 1
		cell.childImageView.borderColor = .label

		guard let childrenCount = childrenCount else { return UICollectionViewCell() }
		if indexPath.row < childrenCount - 1 {
			cell.setUp(with: childrens[indexPath.row])
		} else {
			cell.childImageView.image = UIImage(named: "addChild")
			cell.nicknameLabel.text = "Add Child User".localized()
		}

		return cell
	}

	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		guard let cell = cell as? ChildCollectionViewCell else { return }

		let cellHeight : CGFloat = cell.frame.size.height
		let labelHeight : CGFloat = cell.nicknameLabel?.frame.size.height ?? 0.0
		cell.childImageView?.layer.cornerRadius = (cellHeight - labelHeight) / 2.0
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
	{
		let numberOfCellsPerRow = 3
		let otherSpace = collectionView.contentInset.left + collectionView.contentInset.right
		let width = (collectionView.frame.size.width - otherSpace) / CGFloat(numberOfCellsPerRow)
		return CGSize(width: width, height: 165) // Height can be anything 80, 90 ,100
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		collectionView.deselectItem(at: indexPath, animated: false)

		guard let childrenCount = childrenCount else { return}

		if indexPath.row < childrenCount - 1 {
            UserSettings.childInfo.set(value: childrens[indexPath.row])
            let vc = StoryboardScene.ContentSelection.contentSelectionViewController.instantiate()
            self.navigationController?.pushViewController(vc, animated: true)

		} else {
            let vc = StoryboardScene.ChildrenRegistration.childRegistrationViewController.instantiate()
            vc.childDetail = nil
            self.navigationController?.pushViewController(vc, animated: true)
		}
	}
}

// MARK:  Lock orientation
extension ChooseChildrenViewController {
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
        self.childCollectionView.scrollsToTop = true
		AppUtility.lockOrientation(.portrait)
        self.getAllChild()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		AppUtility.lockOrientation(.all)
	}
}


