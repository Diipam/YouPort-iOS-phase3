//
//  AvatarSelectionViewController.swift
//  LearningApp-Kid
//
//  Created by Anisha Lamichhane on 12/10/2022.
//  Copyright © 2022 SmartSolarNepal. All rights reserved.
//

import UIKit

protocol ReturnAvatarImageString: AnyObject {
	func setImageString(value: String)
}


class AvatarSelectionViewController: UIViewController {

	@IBOutlet weak var avatarScreenView: UIView!
	@IBOutlet weak var pageControl: UIPageControl!
	@IBOutlet weak var determineButton: UIButton!

	let boyAvatarImages = ["boy1","boy2","boy3","boy4","boy5","boy6","boy7","boy8"]
	let girlAvatarImages = ["girl1","girl2","girl3","girl4","girl5","girl6","girl7","girl8"]

	var avatarImages: [String] = []
	var selectedImage: String? = nil

	weak var delegate: ReturnAvatarImageString?

	var currentPage = 0 {
		didSet{
			pageControl.currentPage  = currentPage
			if currentPage == 0 {
				avatarImages = boyAvatarImages
				avatarCollectionView.reloadData()
			} else if currentPage == 1 {
				avatarImages = girlAvatarImages
				avatarCollectionView.reloadData()
			}
		}
	}

	private lazy var avatarCollectionView: UICollectionView = {
	let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ in
		//        Item
		let item = NSCollectionLayoutItem(layoutSize:  NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
		item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom:5, trailing: 5)
		//        Group
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(140)), subitem: item, count: 3)
		group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom:0, trailing: 10)

		//        Section
		let section = NSCollectionLayoutSection(group: group)
		return section
	}))
	avatarScreenView.addSubview(collectionView)
	collectionView.register(UINib(nibName: ChildCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: ChildCollectionViewCell.identifier)

	collectionView.dataSource = self
	collectionView.delegate = self

	return collectionView
}()


    override func viewDidLoad() {
        super.viewDidLoad()
		loadViewIfNeeded()
		determineButton.setTitle("Apply".localized(), for: .normal)
		determineButton.cornerRadius = determineButton.height / 4
		determineButton.isEnabled = false
		determineButton.backgroundColor = UIColor(named: "standardGray")

		avatarImages = boyAvatarImages

		pageControl.numberOfPages = 2

		let swipeleft = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
		swipeleft.direction = .left
		self.view.addGestureRecognizer(swipeleft)

		let swiperight = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
		swiperight.direction = .right
		self.view.addGestureRecognizer(swiperight)

    }

	@objc func swipeLeft() {
		if currentPage == 0 {
			currentPage = 1
			determineButton.isEnabled = false
			determineButton.backgroundColor = UIColor(named: "standardGray")
		}
	}

	@objc func swipeRight() {
		if currentPage == 1 {
			currentPage = 0
			determineButton.isEnabled = false
			determineButton.backgroundColor = UIColor(named: "standardGray")
		}
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		loadViewIfNeeded()
		avatarCollectionView.frame = avatarScreenView.bounds
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		determineButton.isEnabled = false
		determineButton.backgroundColor = UIColor(named: "standardGray")
	}


	@IBAction func backButtonPressed(_ sender: UIButton) {
		self.dismiss(animated: true)
	}

	@IBAction func determineButtonPressed(_ sender: UIButton) {
		guard let selectedImage = selectedImage else {
			return
		}
		delegate?.setImageString(value: selectedImage)
		self.dismiss(animated: true)
	}

	@IBAction func pageControlClicked(_ sender: UIPageControl) {
		currentPage = (currentPage + 1) % 2
	}

}
// MARK:  UICollectionViewDelegate and UICollectionViewDataSourceMethod
extension AvatarSelectionViewController:  UICollectionViewDelegate, UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return currentPage == 0 ? boyAvatarImages.count : girlAvatarImages.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChildCollectionViewCell.identifier, for: indexPath) as? ChildCollectionViewCell else {
			return UICollectionViewCell()
		}

		currentPage == 0 ? (avatarImages = boyAvatarImages) : (avatarImages = girlAvatarImages)
		cell.childImageView.borderWidth = 1
		cell.childImageView.borderColor = .label
		cell.childImageView.image =  UIImage(named: avatarImages[indexPath.row])
		cell.nicknameLabel.text = nil

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
		let numberOfCellsPerRow = 3
		let otherSpace = collectionView.contentInset.left + collectionView.contentInset.right
		let width = (collectionView.frame.size.width - otherSpace) / CGFloat(numberOfCellsPerRow)
		return CGSize(width: width, height: 160) // Height can be anything 80, 90 ,100
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let imageString = avatarImages[indexPath.row]
		selectedImage = imageString
		determineButton.isEnabled = true
		determineButton.backgroundColor = UIColor(named: "submitToggleRed")
	}
}


// MARK:  Lock orientation
extension AvatarSelectionViewController {
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		AppUtility.lockOrientation(.portrait)

	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		AppUtility.lockOrientation(.all)

	}
}

