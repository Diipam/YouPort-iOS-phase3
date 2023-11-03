//
//  ChildCollectionViewCell.swift
//  LearningApp-Kid
//
//  Created by Anisha Lamichhane on 04/08/2022.
//  Copyright © 2022 SmartSolarNepal. All rights reserved.
//

import UIKit
import Kingfisher

class ChildCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: ChildCollectionViewCell.self)
    @IBOutlet weak var childImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!

	override var isSelected: Bool {
		didSet {
			self.childImageView.borderColor = isSelected ? UIColor(named: "submitToggleRed") : UIColor.label
			self.childImageView.borderWidth = isSelected ? 2 : 1
		}
	}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        childImageView.layer.cornerRadius = childImageView.frame.width / 2.0
        backgroundColor = .systemBackground
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        childImageView.image = nil
        nicknameLabel.text = nil
       
    }
    
    func setUp(with children: AllChilds) {
        if let image = children.image_path {
            let imageString = "\(Route.baseUrl)api/\(image)"
//			print(imageString)
            childImageView.kf.setImage(with: imageString.asURL)
            nicknameLabel.text = children.nickname
        }
    }
}
