//
//  PatternB001ViewController.swift
//  LearningApp-Kid
//
//  Created by Anisha Lamichhane on 26/08/2022.
//  Copyright © 2022 SmartSolarNepal. All rights reserved.
//

import UIKit
import SnapKit

protocol ReturnIndexToQuizManager: AnyObject {
	func setCorrectAnswer(isCorrect: Bool)
}

class PatternB001ViewController: UIViewController {
	var problem: AllQuestions? = nil
	var questions: [Question] = []
	var selectedAnswer: [Answer] = []
	var targetQuestion: [String]? = nil
	var isCorrect: Bool = false
	var childId: AllChilds? = nil
	var objectId: String? = nil
	var initializeId: String? = nil
	var remainingProblemCount = ""
	var selectedCellIndexPath: IndexPath? = nil
	var indexpathArray: [IndexPath] = []
	weak var delegate: ReturnIndexToQuizManager?

	@IBOutlet weak var titleLabelShadowView: ShadowView!
	@IBOutlet weak var targetShadowView: ShadowView!

	@IBOutlet weak var problemRemainingLabel: UILabel!
	@IBOutlet weak var titleLabel: UIButton!

	@IBOutlet weak var targetBackgroundView: UIView!

	@IBOutlet weak var targetView: UIView!

	@IBOutlet weak var questionView: UIView!

	@IBOutlet weak var resetButton: UIButton!
	@IBOutlet weak var okButton: UIButton!
	@IBOutlet weak var problemSkipButton: UIButton!

	let customAlert = MyAlert()
	var timer: Timer?

	private lazy var targetCollectionView: UICollectionView = {
		var layout = UICollectionViewFlowLayout()
		layout.minimumInteritemSpacing = 3

		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.backgroundColor = UIColor(named: "gameHeadingBackground")

		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.isScrollEnabled = false
		collectionView.register(UINib(nibName: CollectionViewCellB.identifier, bundle: nil), forCellWithReuseIdentifier: CollectionViewCellB.identifier)
		targetView.addSubview(collectionView)

		collectionView.dropDelegate = self
		collectionView.dragInteractionEnabled = false

		return collectionView
	}()

	private lazy var questionCollectionView: UICollectionView = {
		var layout = UICollectionViewFlowLayout()
		layout.minimumInteritemSpacing = 3

		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.backgroundColor = .clear

		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.isScrollEnabled = false

		collectionView.register(UINib(nibName: CollectionViewCellB.identifier, bundle: nil), forCellWithReuseIdentifier: CollectionViewCellB.identifier)
		questionView.addSubview(collectionView)

		collectionView.dragDelegate = self
		collectionView.dragInteractionEnabled = true
		collectionView.isUserInteractionEnabled = true
		//		collectionView.dragDelegate
		if let longPressRecognizer = collectionView.gestureRecognizers?.compactMap({ $0 as? UILongPressGestureRecognizer}).first {
			longPressRecognizer.minimumPressDuration = 0.01 // your custom value
			collectionView.addGestureRecognizer(longPressRecognizer)
		}
		return collectionView
	}()


	override func viewDidLoad() {
		super.viewDidLoad()
		loadViewIfNeeded()

		okButton.setTitle("OK".localized(), for: .normal)
		problemSkipButton.setTitle("Skip".localized(), for: .normal)
		resetButton.setTitle("Reset".localized(), for: .normal)

		customAlert.delegate = self
	}


	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		loadViewIfNeeded()
		view.layoutIfNeeded()
		targetView.layoutIfNeeded()
		targetBackgroundView.layoutIfNeeded()
		targetShadowView.layoutIfNeeded()

		titleLabel.borderWidth = 3
		titleLabel.borderColor = .label
		okButton.borderWidth = 2
		okButton.borderColor = .lightGray
		resetButton.borderWidth = 2
		resetButton.borderColor = .label
		problemSkipButton.borderWidth = 2
		problemSkipButton.borderColor = .label
		targetBackgroundView.borderWidth = 3
		targetBackgroundView.borderColor = .label

		titleLabel.cornerRadius = titleLabel.height / 2
		titleLabelShadowView.cornerRadius = titleLabelShadowView.height / 2
		okButton.cornerRadius = okButton.height / 4
		resetButton.cornerRadius = resetButton.height / 2
		problemSkipButton.cornerRadius = problemSkipButton.height / 2
		targetBackgroundView.cornerRadius = targetBackgroundView.height / 4
		targetShadowView.cornerRadius = targetShadowView.height / 4
		titleLabelShadowView.cornerRadius = titleLabelShadowView.height / 2


		targetCollectionView.frame = targetView.bounds
		questionCollectionView.frame = questionView.bounds
		questionCollectionView.collectionViewLayout.invalidateLayout()
		targetCollectionView.collectionViewLayout.invalidateLayout()

		customAlert.updateFrames(on: self)

	}


	@IBAction func okButtonClicked(_ sender: UIButton) {
//		shouldIncrement = false
		guard let problem = self.problem, let answers = problem.answers else { return }

		let apiAnswer = Set(answers)
		let selectedAnswer = Set(selectedAnswer)

		if apiAnswer == selectedAnswer {
			customAlert.showAlert(isCorrect: true, on: self)
			self.isCorrect = true

			guard let initializeId = initializeId else { return}
			print(initializeId)
			ApiCaller.shared.checkOrTerminateGame(initId: initializeId, isAnswerRight: true, terminateGame: false) { _ in
				//					print(result)
			}
		} else {
			customAlert.showAlert(isCorrect: false, on: self)

			guard let initializeId = self.initializeId else { return }
			print(initializeId)
			ApiCaller.shared.checkOrTerminateGame(initId: initializeId, isAnswerRight: false, terminateGame: false) { _ in
				//					print("wrong answer")
			}
		}
	}

	func dismissAlert() {
		customAlert.dismissAlert()
	}

	@IBAction func resetButtonClicked(_ sender: UIButton) {
		self.selectedAnswer = []
		self.targetQuestion = ["","","",""]
		shouldDisableOkButton()
		selectedCellIndexPath = nil
		indexpathArray = []
		self.targetCollectionView.reloadData()
		self.questionCollectionView.reloadData()
	}

	@IBAction func skipButtonPressed(_ sender: UIButton) {
		isCorrect = false
		incrementIndex()
	}

	func initializeProblem() {
		loadViewIfNeeded()
		view.layoutIfNeeded()
		shouldDisableOkButton()
		setRemainingProblemLabel()
		
		selectedCellIndexPath = nil
		indexpathArray = []
		self.selectedAnswer = []
		guard let problem = self.problem, let questions = problem.questions else { return }

		self.questions = questions

		titleLabel.setTitle(problem.title, for: .normal)

		targetCollectionView.reloadData()
		questionCollectionView.reloadData()

		guard let childId = childId?.id , let deviceid = UserSettings.deviceId.string(), let objectid = problem.object_id else {
			return
		}

		ApiCaller.shared.initializeProblemGame(objectId: objectid, deviceIdWithChildId:  "\(String(describing: deviceid))_\(childId)") {[weak self] result in
			DispatchQueue.main.async {
				switch result {
				case .success(let success):
					self?.initializeId = success.data?.init_id
					self?.objectId = success.data?.object_id

				case .failure(let error):
					print(error)
				}
			}
		}
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

	private func incrementIndex() {
		self.willMove(toParent: nil)
		self.view.removeFromSuperview()
		self.removeFromParent()
		timer?.invalidate()

		delegate?.setCorrectAnswer(isCorrect: isCorrect)
	}
}

// MARK:  CollectionViewDelegate and DataSourceMethods
extension PatternB001ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		guard let problem = self.problem, let questions = problem.questions else { return 0 }
		return questions.count
	}


	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		loadViewIfNeeded()
		let margin : CGFloat = 0

		let size: CGFloat = (collectionView.frame.size.width - margin ) / CGFloat(5)

		return CGSize(width: size, height: size)
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

		guard let problem = self.problem, let questions = problem.questions else { return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)}
		let margin : CGFloat = 5
		let size: CGFloat = (collectionView.frame.size.width - margin) / CGFloat(5)

		let totalCellWidth = size * CGFloat(questions.count)
		let totalSpacingWidth = 10 * CGFloat(questions.count - 1)
		let leftInset = (collectionView.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
		let rightInset = leftInset
		let cellHeight = size
		let topInset = (collectionView.height - CGFloat(cellHeight)) / 2
		let bottomInset = topInset
		switch collectionView {
		case targetCollectionView:

			return UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)

		case questionCollectionView:
			return UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)

		default:
			return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		}
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		switch collectionView {
			
		case targetCollectionView:
			if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellB.identifier, for: indexPath) as? CollectionViewCellB  {
				cell.clipsToBounds = true
				cell.cornerRadius = cell.height / 3
				cell.layer.borderColor = UIColor.black.cgColor
				cell.layer.borderWidth = 2

				if let targetQuestion = self.targetQuestion, !targetQuestion.isEmpty {
					cell.setUpOptionsImage(with: targetQuestion[indexPath.row])
				}
				return cell
			} else {
				return UICollectionViewCell()
			}

		case questionCollectionView:
			if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellB.identifier, for: indexPath) as? CollectionViewCellB {
				cell.clipsToBounds = true
				cell.cornerRadius = cell.height / 3
				cell.layer.borderColor = UIColor.label.cgColor
				cell.layer.borderWidth = 2
				//			print(self.questions)
				guard let questions = self.problem?.questions, let questionImageAtIndexpath = questions[indexPath.row].question else { return UICollectionViewCell() }
				cell.setUpOptionsImage(with: questionImageAtIndexpath)

				return cell
			} else {
				return UICollectionViewCell()
			}

		default:
			return UICollectionViewCell()
		}
	}

	func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellB.identifier, for: indexPath) as? CollectionViewCellB else { return }
		cell.problemImageView.kf.cancelDownloadTask()
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		collectionView.deselectItem(at: indexPath, animated: false)
	}
}

extension PatternB001ViewController: notifyAlertDismiss {
	func isCompleted(value: Bool) {
		if isCorrect {
			incrementIndex()
		} else {
			self.selectedAnswer = []
			self.targetQuestion = ["","","",""]
			self.selectedCellIndexPath = nil
			self.indexpathArray = []
			self.targetCollectionView.reloadData()
			self.questionCollectionView.reloadData()
			self.shouldDisableOkButton()
		}
	}
}



// MARK: - collectionView Drag and Drop delegate -
extension PatternB001ViewController: UICollectionViewDragDelegate, UICollectionViewDropDelegate {
	func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
		if collectionView == questionCollectionView {
			self.selectedCellIndexPath = indexPath

			//			print(indexpathArray)
			let previousSelectedCells = self.indexpathArray.filter { $0 == indexPath }

			if previousSelectedCells.isEmpty {
//				guard let problem = self.problem else { return []}
				let item = questions[indexPath.row]
				let itemProvider = NSItemProvider(object: item)
				let dragItem = UIDragItem(itemProvider: itemProvider)
				dragItem.localObject = item
				return [dragItem]
			} else {
				return []
			}

		} else {
			return []
		}

	}
	
	func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
		return session.canLoadObjects(ofClass: Question.self)
	}

	func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
		switch collectionView {
		case targetCollectionView:
			if let indexpath = destinationIndexPath {
				let previousTargetData = self.selectedAnswer.filter { $0.position?.first == String(indexpath.section) && $0.position?.last == String(indexpath.row) }
				if previousTargetData.isEmpty {
					return UICollectionViewDropProposal(operation: .move)
				} else {
					return UICollectionViewDropProposal(operation: .cancel)
				}
			} else {
				return UICollectionViewDropProposal(operation: .cancel)
			}

		case questionCollectionView:
			return UICollectionViewDropProposal(operation: .forbidden)

		default:
			return UICollectionViewDropProposal(operation: .forbidden)
		}
	}

	func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
		switch coordinator.proposal.operation {
		case .move:
			for item in coordinator.items {
				item.dragItem.itemProvider.loadObject(ofClass: Question.self, completionHandler: { [weak self] (question, error) in
					guard let indexPath = coordinator.destinationIndexPath  else { return }
					//
					if let question = question as? Question, let questionImage = question.question, let questionId = question.question_id  {

						self?.selectedAnswer.append(Answer(position: ["\(indexPath.section)","\(indexPath.row)"], question_id: questionId, state: nil))
						//						print(self?.selectedAnswer)

						DispatchQueue.main.async {
							if let selectedCellIndexPath = self?.selectedCellIndexPath {
								if let cell = self?.questionCollectionView.cellForItem(at: (self?.selectedCellIndexPath)!) as? CollectionViewCellB {
									cell.problemImageView.backgroundColor = .systemBackground
									cell.backgroundColor = .systemBackground
									cell.problemImageView.alpha = 0.7

									self?.indexpathArray.append(selectedCellIndexPath)
								}
							}

							guard let selectedAnswer = self?.selectedAnswer else { return}
							if selectedAnswer.count == self?.problem?.answers?.count {
								self?.shouldEnableOkButton()
							} else {
								self?.shouldDisableOkButton()
							}
						}

						//						print(self.selectedAnswer)
						self?.targetQuestion?[indexPath.row] = questionImage

						DispatchQueue.main.async {
							self?.targetCollectionView.reloadItems(at: [indexPath])
						}

						guard let initId = self?.initializeId else { return }

						ApiCaller.shared.updateInitializeProblemGame(initId: initId, questionId: questionId, append: true) { result in
						}

					}
				})
			}

		default:
			return
		}
	}
}


// MARK:  Extension to handle timer for answerTime
extension PatternB001ViewController {
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
