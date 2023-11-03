//
//  LicensesTableViewCell.swift
//  LearningApp-Kid
//
//  Created by Anisha Lamichhane on 07/04/2023.
//  Copyright © 2023 SmartSolarNepal. All rights reserved.
//

import UIKit

class LicensesTableViewCell: UITableViewCell {
	static let identifier = String(describing: LicensesTableViewCell.self)

	@IBOutlet weak var titleLabel: UILabel!

	@IBOutlet weak var subtitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
