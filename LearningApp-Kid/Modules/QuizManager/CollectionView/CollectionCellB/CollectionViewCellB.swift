//
//  CollectionViewCellB.swift
//  LearningApp-Kid
//
//  Created by Anisha Lamichhane on 15/09/2022.
//  Copyright © 2022 SmartSolarNepal. All rights reserved.
//

import UIKit
import Kingfisher

class CollectionViewCellB: UICollectionViewCell {
    static let identifier = String(describing: CollectionViewCellB.self)
    @IBOutlet weak var problemImageView: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//		problemImageView.image = nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//		problemImageView.image = nil
		problemImageView.alpha = 1
		problemImageView.borderWidth = 0
    }
    
    func setUpOptionsImage(with question: String?) {
		guard let questionString = question else {
			problemImageView.image = nil
			return
		}
		let imageString = "\(Route.baseUrl)api/\(questionString)"

		ApiCaller.shared.refreshAccessTokenIfNeeded {[weak self] result in
			guard let token = UserSettings.access_token.string() else { return }
			let modifier = AnyModifier { request in
				var r = request
				r.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
				return r
			}

			let url = URL(string: imageString)

			DispatchQueue.main.sync {
				self?.problemImageView.image = UIImage(named: "placeholder")
				self?.problemImageView.kf.setImage(with: url, options: [.requestModifier(modifier)])
			}
		}
    }

}

