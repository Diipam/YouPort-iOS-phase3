//
//  ContentSelectionViewController.swift
//  LearningApp-Kid
//
//  Created by Anisha Lamichhane on 30/06/2023.
//  Copyright © 2023 SmartSolarNepal. All rights reserved.
//

import UIKit

class ContentSelectionViewController: UIViewController {
    static let identifier = String(describing: ContentSelectionViewController.self)
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    
    var contentsEn: [Contents] = [Contents(contentImage: "youtube", contentName: ContentType.youtube.rawValue),
                                  Contents(contentImage: "tiktok", contentName: ContentType.tiktok.rawValue)
    ]

    private lazy var contentCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ in
            //        Item
            let item = NSCollectionLayoutItem(layoutSize:  NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom:0, trailing: 5)
            //        Group
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(160)), subitem: item, count: 3)
            group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
            //        Section
            let section = NSCollectionLayoutSection(group: group)

            return section
        }))
        contentView.addSubview(collectionView)
        collectionView.register(UINib(nibName: ContentCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: ContentCollectionViewCell.identifier)

        collectionView.dataSource = self
        collectionView.delegate = self


        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar(isBackButtonHidden: false, isLogoHidden: false, isSettingIconHidden: false)
        titleLabel.text = "Contents".localized()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentCollectionView.frame = contentView.bounds

        contentCollectionView.backgroundColor = .systemBackground
    }

}


// MARK: - collection view cell delegate and data source methods -
extension ContentSelectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.contentsEn.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCollectionViewCell.identifier, for: indexPath) as? ContentCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.contentImageView.borderWidth = 1
        cell.contentImageView.borderColor = .label
        
        cell.setUpContent(with: contentsEn[indexPath.row])



        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? ContentCollectionViewCell else { return }

        let cellHeight : CGFloat = cell.frame.size.height
        let labelHeight : CGFloat = cell.contentLabel?.frame.size.height ?? 0.0
        cell.contentImageView?.layer.cornerRadius = (cellHeight - labelHeight) / 2.0
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UserSettings.contentType.set(value: contentsEn[indexPath.row].contentName)

        let vc = StoryboardScene.Main.mainViewController.instantiate()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

