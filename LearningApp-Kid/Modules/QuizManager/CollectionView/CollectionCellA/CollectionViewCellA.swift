//
//  PatternA00CollectionViewCell.swift
//  LearningApp-Kid
//
//  Created by Anisha Lamichhane on 26/08/2022.
//  Copyright © 2022 SmartSolarNepal. All rights reserved.
//

import UIKit
import Kingfisher

class CollectionViewCellA: UICollectionViewCell {
	static let identifier = String(describing: CollectionViewCellA.self)

	@IBOutlet var otherView: UIView!
	@IBOutlet weak var problemImageView: UIImageView!

	override var isSelected: Bool {
		didSet {
			self.problemImageView.borderWidth = isSelected ? 3 : 0
			self.problemImageView.borderColor = isSelected ? .systemYellow : .systemBackground
		}
	}

	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
		problemImageView.image = nil
//        print(KingfisherManager.shared.downloader)
	}
	override func prepareForReuse() {
		super.prepareForReuse()
		problemImageView.alpha = 1
		problemImageView.image = nil
		problemImageView.clipsToBounds = true
	}

	func setUpOptionsImage(with question: String) {
		let questionString = question
		let imageString = "\(Route.baseUrl)api/\(questionString)"

		ApiCaller.shared.refreshAccessTokenIfNeeded {[weak self] result in
			guard let token = UserSettings.access_token.string() else { return }
			let modifier = AnyModifier { request in
				var r = request
				r.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
				return r
			}

			let url = URL(string: imageString)

			   // Cancel previous download task
//			self?.problemImageView.kf.cancelDownloadTask()

			DispatchQueue.main.sync {
				self?.problemImageView.image = UIImage(named: "placeholder")
				self?.problemImageView.kf.setImage(with: url, options: [.requestModifier(modifier)])
			}
		}

	}
}
