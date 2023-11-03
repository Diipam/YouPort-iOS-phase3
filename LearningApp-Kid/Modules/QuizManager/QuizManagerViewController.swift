//
//  QuizManagerViewController.swift
//  LearningApp-Kid
//
//  Created by Anisha Lamichhane on 22/08/2022.
//  Copyright © 2022 SmartSolarNepal. All rights reserved.
//

import UIKit
import ProgressHUD

class QuizManagerViewController: UIViewController {
	var childDetails: AllChilds? = nil
	var AllProblems: AllQuestionResponse? = nil

	var outputProblems: [AllQuestions] = []

	var updatedAllProblems: [AllQuestions] = []
	var correctAnswerCount = 0

	var previousProblemId = "C00"
	var isTargetEmpty = false


	let patternA001VC = StoryboardScene.Quiz.patternA1ViewController.instantiate()
	let patternB001VC = StoryboardScene.Quiz.patternB001ViewController.instantiate()
	let patternB002VC = StoryboardScene.Quiz.patternB002ViewController.instantiate()
	let patternC00VC = StoryboardScene.Quiz.patternC00ViewController.instantiate()


	@IBOutlet weak var quizView: UIView!

	override func viewDidLoad() {
		super.viewDidLoad()
		guard let allProblems = AllProblems?.data else { return }

		patternA001VC.delegate = self
		patternB001VC.delegate = self
		patternB002VC.delegate = self
		patternC00VC.delegate = self
		createProblemArray(allProblems: allProblems)
		loadQuiz(correctAnswerCount: 0)
	}

	func createProblemArray(allProblems: [AllQuestions]) {
		let problems = allProblems
		var patternA = problems.filter {($0.problem_id?.hasPrefix("A00"))! && $0.answers != nil && $0.title != nil}
		var patternB1 = problems.filter {($0.problem_id?.hasPrefix("B00"))! && ($0.target!.isEmpty) && $0.answers != nil}
		var patternB2 = problems.filter {$0.problem_id!.hasPrefix("B00") && !$0.target!.isEmpty && $0.answers != nil}
		var patternC = problems.filter {($0.problem_id?.hasPrefix("C00"))! && $0.answers != nil}

		while (!patternA.isEmpty && !patternB1.isEmpty && !patternB2.isEmpty && !patternC.isEmpty) {
			guard let preferredLanguage = Locale.preferredLanguages.first else {return}
			if preferredLanguage.hasPrefix("ja") {
				outputProblems.append(patternA[0])
				outputProblems.append(patternB1[0])
				outputProblems.append(patternB2[0])
				outputProblems.append(patternC[0])
			} else {
				outputProblems.append(patternA[0])
				outputProblems.append(patternB2[0])
				outputProblems.append(patternC[0])
			}

			patternA.remove(at: 0)
			patternB1.remove(at: 0)
			patternB2.remove(at: 0)
			patternC.remove(at: 0)
		}

		getProblemQuestions()
	}

	func getProblemQuestions() {
		let problemDifficulty = childDetails?.problem_settings?.first?.problem_difficulty ?? 2
		let problemId = UserSettings.quizProblemId.string()
		let objectId = UserSettings.quizObjectId.string()

			ApiCaller.shared.getAllProblemQuestions(problemDifficulty: "\(problemDifficulty)", objectId: objectId , problemId: problemId) { [weak self] result in
				switch result {
				case .success(let success):
					self?.AllProblems = success
					if let problemId = success.info?.lastEvaluatedKey?.problem_id, let objectId = success.info?.lastEvaluatedKey?.object_id {
						UserSettings.quizProblemId.set(value: problemId)
						UserSettings.quizObjectId.set(value: objectId)
					} else {
						UserSettings.quizProblemId.set(value: nil)
						UserSettings.quizObjectId.set(value: nil)
					}
				case .failure(let error):
					print(error)
				}
			}
//		}
	}
	
	func loadQuiz(correctAnswerCount: Int) {
		let correctAnswerQuota = self.childDetails?.problem_settings?.first?.correct_answer_quota ?? 5

		print(outputProblems.count)
		if correctAnswerCount < correctAnswerQuota {
			print("remaining \(correctAnswerCount)")
			let problems = outputProblems
			if let problem = problems.first, let problemId = problem.problem_id, let target = problem.target {
//				print(problem)
				if problemId.hasPrefix("A00") {
//					print(problem.problem_id)
					addPatternA001VC(with: problem)

					self.outputProblems.remove(at: 0)
				}
				else if problemId.hasPrefix("B00") {
					if target.isEmpty {
//						print(problem.problem_id)
//						print(problem.answers)
						addPatternB001VC(with: problem)
//						print(problem.problem_id)
						self.outputProblems.remove(at: 0)
					} else  {
//						print(problem.problem_id)
						addPatternB002VC(with: problem)
						self.outputProblems.remove(at: 0)
					}
				}
				else if problemId.hasPrefix("C00") {
					addPatternC00VC(with: problem)
					self.outputProblems.remove(at: 0)
				}
			} else {
				print("Call the api")
				guard let allProblems = AllProblems, let problem = allProblems.data else { return}
				createProblemArray(allProblems: problem)
				loadQuiz(correctAnswerCount: correctAnswerCount)
			}
		}
//		called after the user answers the specified question correctly
		else {
			self.dismiss(animated: true)
		}
	}


	// MARK:  initialize Quizes ViewControllers
	func addPatternA001VC(with problem: AllQuestions) {
		patternA001VC.problem = problem

		if let correctAnswerQuota = self.childDetails?.problem_settings?.first?.correct_answer_quota {
			let remainingProblems = correctAnswerQuota - correctAnswerCount
			patternA001VC.remainingProblemCount = "\(remainingProblems)"
		}
		patternA001VC.childId = childDetails
		patternA001VC.initialize()
		patternA001VC.view.frame = quizView.bounds

		addChild(patternA001VC)
		quizView.addSubview(patternA001VC.view)
		patternA001VC.didMove(toParent: self)

	}

	func addPatternB001VC(with problem: AllQuestions) {
		guard let childId = self.childDetails, let question = problem.questions else { return}
		patternB001VC.problem = problem
		patternB001VC.questions = question

		if let correctAnswerQuota = self.childDetails?.problem_settings?.first?.correct_answer_quota {
			let remainingProblems = correctAnswerQuota - correctAnswerCount
			patternB001VC.remainingProblemCount = "\(remainingProblems)"
		}

		patternB001VC.childId = childId
		patternB001VC.targetQuestion = ["", "", "", ""]
		patternB001VC.questions = []
		patternB001VC.initializeProblem()
		patternB001VC.selectedCellIndexPath = nil
		patternB001VC.indexpathArray = []
		patternB001VC.view.frame = quizView.bounds
		addChild(patternB001VC)
		quizView.addSubview(patternB001VC.view)
		patternB001VC.didMove(toParent: self)

	}

	func addPatternB002VC(with problem: AllQuestions) {
		patternB002VC.problem = problem
		if let correctAnswerQuota = self.childDetails?.problem_settings?.first?.correct_answer_quota {
			let remainingProblems = correctAnswerQuota - correctAnswerCount
			patternB002VC.remainingProblemCount = "\(remainingProblems)"
		}
		patternB002VC.target = nil
		patternB002VC.childId = childDetails
		patternB002VC.initialize()
		patternB002VC.view.frame = quizView.bounds
		addChild(patternB002VC)
		quizView.addSubview(patternB002VC.view)

		patternB002VC.didMove(toParent: self)

	}

	func addPatternC00VC(with problem: AllQuestions) {
		patternC00VC.problem = problem
		if let correctAnswerQuota = self.childDetails?.problem_settings?.first?.correct_answer_quota {
			let remainingProblems = correctAnswerQuota - correctAnswerCount
			patternC00VC.remainingProblemCount = "\(remainingProblems)"
		}
		patternC00VC.childId = childDetails
		patternC00VC.initializeProblem()
		patternC00VC.view.frame = quizView.bounds
		addChild(patternC00VC)
		quizView.addSubview(patternC00VC.view)
		patternC00VC.didMove(toParent: self)
	}
}

extension QuizManagerViewController: ReturnIndexToQuizManager {
	func setCorrectAnswer(isCorrect: Bool) {
		if isCorrect {
			self.correctAnswerCount += 1
			loadQuiz(correctAnswerCount: correctAnswerCount)
			print(correctAnswerCount)
		} else {
			print(isCorrect)
			loadQuiz(correctAnswerCount: self.correctAnswerCount)
			print(correctAnswerCount)
		}
	}
}



