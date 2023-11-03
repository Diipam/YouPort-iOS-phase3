//
//  HelpViewController.swift
//  LearningApp-Kid
//
//  Created by Anisha Lamichhane on 19/10/2022.
//  Copyright © 2022 SmartSolarNepal. All rights reserved.
//

import UIKit

enum ProblemSettingHelpTitle {
	case questionFrequency
	case answerTime
	case questionDifficulty
	case correctAnswerQuota
}

class HelpViewController: UIViewController {

	@IBOutlet weak var titleLabel: UILabel!

	@IBOutlet weak var descriptionLabel: UILabel!

	var helpTitle: ProblemSettingHelpTitle?

	override func viewDidLoad() {
		super.viewDidLoad()
		self.loadViewIfNeeded()

		guard let helpTitle = helpTitle else { return }
		print(helpTitle)
		switch helpTitle {
		case .questionFrequency:
			titleLabel.text = "Frequency".localized()
			descriptionLabel.text = "Questions will appear at specified time intervals during the viewing of the video. You can choose in 5-minute increments between 5 and 60 minutes.".localized()
		case .answerTime:
			titleLabel.text = "Answer Time".localized()
			descriptionLabel.text = "When the answer time has expired, the system will move on to the next question. The answer time can be selected in 1-minute increments from 1 to 5 minutes.".localized()

		case .questionDifficulty:
			titleLabel.text = "Difficulty".localized()
			descriptionLabel.text = "The difficulty level of the questions is automatically set according to the registered age.[★]0 - 3 years old, [★★] 4 - 6 years old, [★★★] 7 years old and older.You can also change the difficulty level according to your child's stage of growth.".localized()
		case .correctAnswerQuota:
			titleLabel.text = "Quota".localized()
			descriptionLabel.text = "When the designated number of questions are answered correctly, the user will be returned to watching the video.The quota of correct answers can be selected for each question from 1 to 5.".localized()
		}

	}

	@IBAction func backButtonPressed(_ sender: UIButton) {
		self.dismiss(animated: false)
	}

	
}
