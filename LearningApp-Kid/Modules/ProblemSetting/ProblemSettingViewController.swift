//
//  ProblemSettingViewController.swift
//  LearningApp-Kid
//
//  Created by Anisha Lamichhane on 28/07/2022.
//  Copyright © 2022 SmartSolarNepal. All rights reserved.
//

import UIKit
import DropDown
import ProgressHUD
import Cosmos

class ProblemSettingViewController: UIViewController {

	@IBOutlet weak var questionFrequencyLabelLeft: UILabel!
	@IBOutlet weak var answerTimeLabelLeft: UILabel!
	@IBOutlet weak var problemDifficultyLabelLeft: UILabel!

	@IBOutlet weak var correctAnswerQuotaLeft: UILabel!

	@IBOutlet weak var starView: CosmosView!

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var determineButton: UIButton!

	@IBOutlet weak var problemDifficultyLabel: UILabel!

	@IBOutlet weak var questionFrequencyView: UIView!
	@IBOutlet weak var questionFrequencyLabel: UILabel!

	@IBOutlet weak var answerTimeView: UIView!
	@IBOutlet weak var answerTimeLabel: UILabel!

	@IBOutlet weak var problemDifficultyView: UIView!

	@IBOutlet weak var correctAnswerQuotaView: UIView!
	@IBOutlet weak var correctAnswerQuotaLabel: UILabel!


	// MARK: - Properties
	let dropDown = DropDown()
	var questionFrequencyAnswer = "5"
	var answerTimeAnswer = "1"
	var problemDifficultyAnswer = "2"
	var correctAnswerQuotaAnswer = "1"

	var childDetail: AllChilds? = nil
	var problemSettings: ProblemSettings? = nil //this is problem setting id

	let questionFrequencyValues = ["5", "10", "15","20", "25", "30","35", "40", "45","50", "55", "60"]
	let answerTimeValues = ["1", "2", "3","4", "5"]
	let questionDifficultyValues = ["1", "2", "3"]
	let correctAnswerQuotaValues = ["1", "2", "3", "4", "5"]

	override func viewDidLoad() {
		super.viewDidLoad()
		self.loadViewIfNeeded()

        setUpNavigationBar(isBackButtonHidden: false, isLogoHidden: true, isSettingIconHidden: true)

		titleLabel.text = "Quiz Setting".localized()
		determineButton.setTitle("Apply".localized(), for: .normal)

		starView.didTouchCosmos = {[weak self] rating in
			let stars = String(format: "%.f", rating)
			self?.problemDifficultyAnswer = stars

			if stars == "1" {
				self?.problemDifficultyLabel.text = "E".localized()
			} else if stars == "2" {
				self?.problemDifficultyLabel.text = "M".localized()
			} else {
				self?.problemDifficultyLabel.text = "D".localized()
			}
		}
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		questionFrequencyLabelLeft.text = "Frequency".localized()
		answerTimeLabelLeft.text = "Answer Time".localized()
		problemDifficultyLabelLeft.text = "Difficulty".localized()
		correctAnswerQuotaLeft.text = "Quota".localized()
		determineButton.cornerRadius = determineButton.height / 4
	}

	//        setting up dropDown general properties
	private func setUpDropDown(with anchorView: UIView) {
		dropDown.anchorView = anchorView
		dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
		dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)!)
		dropDown.direction = .any
		dropDown.dismissMode = .automatic
	}

	@IBAction func questionFrequencyButtonTapped(_ sender: UIButton) {
		setUpDropDown(with: questionFrequencyView)
		dropDown.dataSource = questionFrequencyValues
		dropDown.show()
		dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
			questionFrequencyAnswer = questionFrequencyValues[index]
			questionFrequencyLabel.text = questionFrequencyValues[index] + "mins".localized()
		}
	}

	@IBAction func answerTimeButtonTapped(_ sender: UIButton) {
		setUpDropDown(with: answerTimeView)
		dropDown.dataSource = answerTimeValues
		dropDown.show()
		dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
			answerTimeAnswer = answerTimeValues[index]
			answerTimeLabel.text = answerTimeValues[index] + "mins".localized()
		}
	}

	@IBAction func correctAnswerQuotaButtonTapped(_ sender: UIButton) {
		setUpDropDown(with: correctAnswerQuotaView)
		dropDown.dataSource = correctAnswerQuotaValues
		dropDown.show()
		dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
			correctAnswerQuotaAnswer = correctAnswerQuotaValues[index]
			correctAnswerQuotaLabel.text = correctAnswerQuotaValues[index]
		}
	}

	@IBAction func determineButtonPressed(_ sender: UIButton) {
		ProgressHUD.show()

		guard let childId = self.childDetail?.id else {
			return
		}

        if let problemSettings = problemSettings {
            ApiCaller.shared.updateProblemSetting(childId: childId, id: problemSettings.id, questionFrequency: questionFrequencyAnswer, answerTime: answerTimeAnswer, problemDifficulty: problemDifficultyAnswer, correctAnswerQuota: correctAnswerQuotaAnswer) { [weak self] result in
                DispatchQueue.main.async {
                    switch result{
                    case .success(_):
                        ProgressHUD.dismiss()
                        if let strongSelf = self {
                            AlertHelper.showAlert(from: strongSelf, title: "", message: "Settings saved Successfully.".localized()) {
                                if let settingVC = strongSelf.navigationController?.viewControllers.first(where: { $0 is SettingViewController }) {
                                    strongSelf.navigationController?.popToViewController(settingVC, animated: true)
                                }
                            }
                        }

                    case .failure(let error):
                        if let strongSelf = self {
                            AlertHelper.showAlert(from: strongSelf, title: "", message: error.localizedDescription)
                        }
                    }
                }
            }
		} else {
			ApiCaller.shared.saveProblemSetting(childId: childId, questionFrequency: questionFrequencyAnswer, answerTime: answerTimeAnswer, problemDifficulty: problemDifficultyAnswer, correctAnswerQuota: correctAnswerQuotaAnswer) { [weak self] result in
				DispatchQueue.main.async {
					switch result {
					case .success(_):
						HapticsManager.shared.vibrate(for: .success)
						ProgressHUD.dismiss()

                        if let strongSelf = self {
                            AlertHelper.showAlert(from: strongSelf, title: "", message: "Settings saved Successfully.".localized()) {
                                if let viewControllers = strongSelf.navigationController?.viewControllers, viewControllers.count >= 2 {
                                    if let chooseChildVc = viewControllers[viewControllers.count - 3] as? ChooseChildrenViewController  {
                                        strongSelf.navigationController?.popToViewController(chooseChildVc, animated: true )
                                    } else {
                                        let vc = StoryboardScene.ChooseChildren.chooseChildrenViewController.instantiate()
                                        self?.navigationController?.pushViewController(vc, animated: true)
                                    }
                                }
                            }
                        }

					case .failure(let error):
                        ProgressHUD.dismiss()
                        if let strongSelf = self {
                            AlertHelper.showAlert(from: strongSelf, title: "", message: error.localizedDescription)
                        }
					}
				}
			}
		}
	}

    override func pressedBackButton() {
        if let viewControllers = navigationController?.viewControllers, viewControllers.count >= 2 {
            if let previousVC = viewControllers[viewControllers.count - 2] as? ChildRegistrationViewController  {
                previousVC.childDetail = childDetail
                navigationController?.popViewController(animated: true)
            }
        }
    }
}

// MARK:  get problem setting of child
extension ProblemSettingViewController {
	func setUp() {
		self.loadViewIfNeeded()
		if let problemSetting = self.problemSettings {
			questionFrequencyLabel.text = "\(problemSetting.question_frequency)" + "mins".localized()
			answerTimeLabel.text = "\(problemSetting.answer_time)" + "mins".localized()
			correctAnswerQuotaLabel.text = "\(problemSetting.correct_answer_quota)"

			if problemSetting.problem_difficulty == 1 {
				self.problemDifficultyLabel.text = "E".localized()
			} else if problemSetting.problem_difficulty == 2 {
				self.problemDifficultyLabel.text = "M".localized()
			} else {
				self.problemDifficultyLabel.text = "D".localized()
			}

			starView.rating = Double(problemSetting.problem_difficulty)

			questionFrequencyAnswer = "\(problemSetting.question_frequency)"
			answerTimeAnswer = "\(problemSetting.answer_time)"
			problemDifficultyAnswer = "\(problemSetting.problem_difficulty)"
			correctAnswerQuotaAnswer = "\(problemSetting.correct_answer_quota)"

		} else {

			if let age = self.childDetail?.age {
				if (0...3).contains(age) {
					starView.rating = 1
					self.problemDifficultyLabel.text = "E".localized()

				} else if (4...6).contains(age){
					starView.rating = 2
					self.problemDifficultyLabel.text = "M".localized()
				} else {
					starView.rating = 3
					self.problemDifficultyLabel.text = "D".localized()
				}
			}

			questionFrequencyLabel.text = "5" + "mins".localized()
			answerTimeLabel.text = "1" + "mins".localized()
			problemDifficultyAnswer = "\(String(format: "%.0f", starView.rating))"
			correctAnswerQuotaLabel.text = "1"
		}
	}
}

extension ProblemSettingViewController {
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let destinationVC = segue.destination as? HelpViewController {
			if segue.identifier == "questionFrequencySegue" {
				print(ProblemSettingHelpTitle.questionFrequency)
				destinationVC.helpTitle = ProblemSettingHelpTitle.questionFrequency
			} else if segue.identifier == "answerTimeSegue" {
				print(ProblemSettingHelpTitle.answerTime)
				destinationVC.helpTitle = ProblemSettingHelpTitle.answerTime
			} else if segue.identifier == "questionDifficultySegue" {
				print(ProblemSettingHelpTitle.questionDifficulty)
				destinationVC.helpTitle = ProblemSettingHelpTitle.questionDifficulty
			} else {
				print(ProblemSettingHelpTitle.correctAnswerQuota)
				destinationVC.helpTitle = ProblemSettingHelpTitle.correctAnswerQuota
			}
		}
	}
}

// MARK:  Lock orientation
extension ProblemSettingViewController {
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		AppUtility.lockOrientation(.portrait)
        self.setUp()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		AppUtility.lockOrientation(.all)
	}
}

