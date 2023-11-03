//
//  CollectionViewCellC.swift
//  LearningApp-Kid
//
//  Created by Anisha Lamichhane on 27/09/2022.
//  Copyright © 2022 SmartSolarNepal. All rights reserved.
//

import UIKit

class CollectionViewCellC: UICollectionViewCell {
	@IBOutlet weak var selectedView: UIView!
//	var previousBackgroundColor = 

	static let identifier = String(describing: CollectionViewCellC.self)

	

	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

	override func prepareForReuse() {
		super.prepareForReuse()

		backgroundColor = nil
		selectedView.backgroundColor = nil
		borderWidth = 0
		borderColor = nil


	}

}
