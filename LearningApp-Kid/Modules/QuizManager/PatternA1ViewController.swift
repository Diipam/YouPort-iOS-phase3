//
//  PatternA1ViewController.swift
//  LearningApp-Kid
//
//  Created by Anisha Lamichhane on 24/08/2022.
//  Copyright © 2022 SmartSolarNepal. All rights reserved.
//

import UIKit
import Kingfisher

class PatternA1ViewController: UIViewController {

	@IBOutlet weak var shadowView: ShadowView!
	@IBOutlet weak var titleLabelShadowView: UIView!
	@IBOutlet weak var gameBackgroundView: UIView!
	@IBOutlet weak var problemRemainingLabel: UILabel!
	@IBOutlet weak var titleLabel: UIButton!
	@IBOutlet weak var targetImageView: UIImageView!
	@IBOutlet weak var questionsView: UIView!
	@IBOutlet weak var okButton: UIButton!
	@IBOutlet weak var resetButton: UIButton!
	@IBOutlet weak var skipButton: UIButton!


	// MARK: - properties -

	var problem: AllQuestions? = nil
	var childId: AllChilds? = nil
	var index: Int? = nil
	var isCorrect: Bool = false
	var selectedAnswer: [Answer] = []
	var objectId: String? = nil
	var initializeId: String? = nil

	var remainingProblemCount = ""

	weak var delegate: ReturnIndexToQuizManager?

	var customAlert = MyAlert()
	var timer: Timer?

	private lazy var questionCollectionView: UICollectionView = {
		var layout = UICollectionViewFlowLayout()
		layout.minimumInteritemSpacing = 3

		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.backgroundColor = .clear

		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.isScrollEnabled = false
		collectionView.allowsMultipleSelection = true


		collectionView.register(UINib(nibName: CollectionViewCellA.identifier, bundle: nil), forCellWithReuseIdentifier: CollectionViewCellA.identifier)
		questionsView.addSubview(collectionView)

		return collectionView
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		okButton.setTitle("OK".localized(), for: .normal)
		skipButton.setTitle("Skip".localized(), for: .normal)
		resetButton.setTitle("Reset".localized(), for: .normal)
		customAlert.delegate = self
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		loadViewIfNeeded()
		view.layoutIfNeeded()
		
		questionCollectionView.frame = questionsView.bounds
		questionCollectionView.collectionViewLayout.invalidateLayout()

		titleLabel.borderWidth = 3
		titleLabel.borderColor = .label
		okButton.borderWidth = 2
		okButton.borderColor = .lightGray
		resetButton.borderWidth = 2
		resetButton.borderColor = .label
		skipButton.borderWidth = 2
		skipButton.borderColor = .label
		gameBackgroundView.borderWidth = 3
		gameBackgroundView.borderColor = .label

		titleLabel.cornerRadius = titleLabel.height / 2
		titleLabelShadowView.cornerRadius = titleLabelShadowView.height / 2
		okButton.cornerRadius = okButton.height / 4
		resetButton.cornerRadius = resetButton.height / 2
		skipButton.cornerRadius = skipButton.height / 2
		gameBackgroundView.cornerRadius = gameBackgroundView.height / 10
		shadowView.cornerRadius = shadowView.height / 10

		customAlert.updateFrames(on: self)
	}

	func shouldEnableOkButton() {
		okButton.isEnabled = true
		okButton.backgroundColor = UIColor(named: "submitDefaultRed")
	}
	func shouldDisableOkButton() {
		okButton.isEnabled = false
		okButton.backgroundColor = UIColor(named: "standardGray")
	}

	func setRemainingProblemLabel() {
		let newString = remainingProblemCount
		guard let preferredLanguage = Locale.preferredLanguages.first else {return}
		if preferredLanguage.hasPrefix("ja") {
			let attributedString = NSMutableAttributedString(string: "のこり\(newString)もん")
			let range = (attributedString.string as NSString).range(of: "\(newString)")
			attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: range)
			attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 20), range: range)
			problemRemainingLabel.attributedText = attributedString
		} else {
			let attributedString = NSMutableAttributedString(string: "\(newString) to go")
			let range = (attributedString.string as NSString).range(of: "\(newString)")
			attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: range)
			attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 20), range: range)
			problemRemainingLabel.attributedText = attributedString
		}
	}


	func dismissAlert() {
		customAlert.dismissAlert()
	}

	@IBAction func okButtonClicked(_ sender: UIButton) {
		guard let problem = self.problem, let answers = problem.answers else { return }

		let apiAnswer = Set(answers)
		let selectedAnswer = Set(selectedAnswer)

		if apiAnswer == selectedAnswer {
			isCorrect = true
			customAlert.showAlert(isCorrect: true, on: self)

			guard let initializeId = initializeId else { return}
			print(initializeId)
			ApiCaller.shared.checkOrTerminateGame(initId: initializeId, isAnswerRight: true, terminateGame: false) { _ in
				//					print(result)
			}
		} else {
			isCorrect = false
			customAlert.showAlert(isCorrect: false, on: self)

			guard let initializeId = self.initializeId else { return }
			print(initializeId)
			ApiCaller.shared.checkOrTerminateGame(initId: initializeId, isAnswerRight: false, terminateGame: false) { _ in
				//					print("wrong answer")
			}
		}
	}

	@IBAction func resetButtonClicked(_ sender: UIButton) {
		selectedAnswer = []
		shouldDisableOkButton()
		self.questionCollectionView.reloadData()
	}

	@IBAction func skipButtonClicked(_ sender: UIButton) {
		isCorrect = false
		incrementIndex()
	}

	func initialize() {
		self.loadViewIfNeeded()
		view.layoutIfNeeded()
		shouldDisableOkButton()
		selectedAnswer = []
		setRemainingProblemLabel()
		guard let problem = problem else {
			return
		}
		
		titleLabel.setTitle(problem.title, for: .normal)

		self.problem = problem
		guard let targetImageString = problem.target?.first?.question else { return }
		setUpQuestionImage(with: targetImageString)
		questionCollectionView.reloadData()
		
		guard let childId = childId?.id, let objectid = problem.object_id, let deviceid = UserSettings.deviceId.string() else {
			print("no child id")
			return
		}

		ApiCaller.shared.initializeProblemGame(objectId: objectid, deviceIdWithChildId:  "\(deviceid)_\(childId)") { result in
			DispatchQueue.main.async {
				switch result {
				case .success(let success):
					self.initializeId = success.data?.init_id
					self.objectId = success.data?.object_id

				case .failure(let error):
					print(error)
				}
			}
		}
	}

	func setUpQuestionImage(with question: String) {
		let imageString = "\(Route.baseUrl)api/\(question)"
		ApiCaller.shared.refreshAccessToken { result in
			switch result {
			case .success(let response):
				UserSettings.access_token.set(value: response.data.access_token)

			case .failure(let error):
				print(error.localizedDescription)
			}
		}

		guard let token = UserSettings.access_token.string() else { return}
		let modifier = AnyModifier { request in
			var r = request
			r.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
			return r
		}
		let url = URL(string: imageString)
		targetImageView.kf.setImage(with: url, options: [.requestModifier(modifier)])
	}

	private func incrementIndex() {
		self.willMove(toParent: nil)
		self.view.removeFromSuperview()
		self.removeFromParent()
		timer?.invalidate()

		delegate?.setCorrectAnswer(isCorrect: isCorrect)
	}

}


// MARK: -  ShowCustomAlert
extension PatternA1ViewController: notifyAlertDismiss {
	func isCompleted(value: Bool) {
		if isCorrect {
			incrementIndex()
		} else {
			self.selectedAnswer = []
			questionCollectionView.reloadData()
			shouldDisableOkButton()
		}
	}
}

// MARK: - Collection View Datasource and Delegate methods
extension PatternA1ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.problem?.questions?.count ?? 5
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		loadViewIfNeeded()
		let margin : CGFloat = 5
		let size: CGFloat = (questionCollectionView.frame.size.width - margin) / CGFloat((self.problem?.questions?.count ?? 5) + 1)

		let newSize = min(70, size)

		return CGSize(width: newSize, height: newSize)
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

		let margin : CGFloat = 5
		let size: CGFloat = (questionCollectionView.frame.size.width - margin) / CGFloat((self.problem?.questions?.count ?? 5) + 1)

		let newSize = min(70, size)

		let totalCellWidth = newSize * CGFloat((self.problem?.questions?.count ?? 5))
		let totalSpacingWidth = 10 * CGFloat((self.problem?.questions?.count ?? 5) - 1)
		let leftInset = (questionCollectionView.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
		let rightInset = leftInset

		let totalHeight = newSize * 1
		let topInset = (collectionView.height - (totalHeight)) / 4



		return UIEdgeInsets(top: topInset, left: leftInset, bottom: 0, right: rightInset)
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellA.identifier, for: indexPath) as? CollectionViewCellA	 else {
			return UICollectionViewCell()
		}

		guard let questions = self.problem?.questions, let questionAtIndexPath = questions[indexPath.row].question else { return UICollectionViewCell() }
		cell.setUpOptionsImage(with: questionAtIndexPath)
		cell.problemImageView.cornerRadius = cell.height / 9
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let questions = self.problem?.questions, let questionIdAtIndexPath = questions[indexPath.row].question_id, let answers = self.problem?.answers else { return }

		if !selectedAnswer.contains(where: { $0.question_id == questionIdAtIndexPath }) {
			//			print(questionIdAtIndexPath)
			selectedAnswer.append(Answer(question_id: questionIdAtIndexPath, state: nil))
		}

		if selectedAnswer.count == answers.count {
			shouldEnableOkButton()
		} else {
			shouldDisableOkButton()
		}

		guard let initializeId = self.initializeId else { return }
		ApiCaller.shared.updateInitializeProblemGame(initId: initializeId, questionId: questionIdAtIndexPath, append: true) { _ in
			//			print("updated true")
		}


	}

	func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
		guard let questions = self.problem?.questions, let questionIdAtIndexPath = questions[indexPath.row].question_id, let answers = self.problem?.answers else { return }

		if let index = self.selectedAnswer.firstIndex(where: {$0.question_id == questionIdAtIndexPath}) {
			self.selectedAnswer.remove(at: index)
		}

		if selectedAnswer.count == answers.count {
			shouldEnableOkButton()
		} else {
			shouldDisableOkButton()
		}

		guard let initializeId = self.initializeId else { return }

		ApiCaller.shared.updateInitializeProblemGame(initId: initializeId, questionId: questionIdAtIndexPath, append: false) { _ in
			//			print("append false")
		}
	}

	func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellA.identifier, for: indexPath) as? CollectionViewCellA else {return}

		cell.problemImageView.kf.cancelDownloadTask()
	}
}

// MARK: - Extension to handle timer for answerTime
extension PatternA1ViewController {
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(true)
		//		print("view appeared")
		fireTimer()
		setupObserver()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(true)
		//		print("view in going to be disappeared")
		timer?.invalidate()
		clearObserver()
	}

	func setupObserver() {
		//		when app is active
		NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: .activeState, object: nil)
		//		when app is deactive
		NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: .inactiveState, object: nil)

	}

	func clearObserver() {
		NotificationCenter.default.removeObserver(self)
	}

	@objc func handleNotification(_ sender: Notification) {
		if self.viewIfLoaded?.window != nil {

			if sender.name == .activeState {
				fireTimer()
			} else {
				timer?.invalidate()
			}
		}

	}

	func fireTimer() {
		guard let answerTime = self.childId?.problem_settings?.first?.answer_time else { return }
		let frequency = Double(answerTime * 60)
		timer = Timer.scheduledTimer(withTimeInterval: frequency, repeats: false) {[weak self] timer in
			//			print("Timer fired!")
			switch UIApplication.shared.applicationState {
			case .active:
				DispatchQueue.main.async {
					self?.customAlert.dismissAlert()
					self?.incrementIndex()
				}
				timer.invalidate()
				break

			case .inactive, .background:
				//				print("timer unfired")
				timer.invalidate()
				break

			@unknown default:
				timer.invalidate()
				break
			}
		}
	}
}

