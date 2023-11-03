//
//  ContentCollectionViewCell.swift
//  LearningApp-Kid
//
//  Created by Anisha Lamichhane on 30/06/2023.
//  Copyright © 2023 SmartSolarNepal. All rights reserved.
//

import UIKit

class ContentCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: ContentCollectionViewCell.self)
    
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            self.contentImageView.borderColor = isSelected ? UIColor(named: "submitToggleRed") : UIColor.label

            self.contentImageView.borderWidth = isSelected ? 2 : 1
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .systemBackground
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentImageView.image = nil
        contentLabel.text = nil
    }
    
    func setUpContent(with content: Contents) {
        contentImageView.image = UIImage(named: content.contentImage)
        contentImageView.contentMode = .scaleToFill
        contentLabel.text = content.contentName
    }


}
