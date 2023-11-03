//
//  PatternB002ViewController.swift
//  LearningApp-Kid
//
//  Created by Anisha Lamichhane on 29/08/2022.
//  Copyright © 2022 SmartSolarNepal. All rights reserved.
//

import UIKit
import SwiftUI
import Kingfisher

class PatternB002ViewController: UIViewController {

	// MARK: - Outlets -
	@IBOutlet weak var problemRemainingLabel: UILabel!
	@IBOutlet weak var titleShadowView: ShadowView!
	@IBOutlet weak var titleLabel: UIButton!
	@IBOutlet weak var targetShadowView: ShadowView!
	@IBOutlet weak var targetView: UIView!
	@IBOutlet weak var targetBackgroundView: UIView!
	@IBOutlet weak var questionView: UIView!
	@IBOutlet weak var okButton: UIButton!
	@IBOutlet weak var resetButton: UIButton!
	@IBOutlet weak var skipButton: UIButton!

	// MARK: - Properties
	var problem: AllQuestions? = nil
	var target: [Target]? = nil
	var selectedAnswer: [Answer] = []
	var isCorrect: Bool = false
	
	var rowSize : Int? = nil
	var colSize: Int? = nil
	var childId: AllChilds? = nil
	private var size = [[Int]]()
	var objectId: String? = nil
	var initializeId: String? = nil

	var remainingProblemCount = ""

	var timer: Timer?

	weak var delegate: ReturnIndexToQuizManager?

	let customAlert = MyAlert()


	private lazy var targetCollectionView: UICollectionView = {
		var layout = UICollectionViewFlowLayout()
		layout.minimumInteritemSpacing = 0
		layout.minimumLineSpacing = 0

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
		layout.minimumInteritemSpacing = 5

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

		if let longPressRecognizer = collectionView.gestureRecognizers?.compactMap({ $0 as? UILongPressGestureRecognizer}).first {
			longPressRecognizer.minimumPressDuration = 0 // your custom value
			collectionView.addGestureRecognizer(longPressRecognizer)
		}
		return collectionView
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		okButton.setTitle("OK".localized(), for: .normal)
		titleLabel.setTitle(problem?.title ?? "", for: .normal)
		skipButton.setTitle("Skip".localized(), for: .normal)
		resetButton.setTitle("Reset".localized(), for: .normal)
		customAlert.delegate = self
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		loadViewIfNeeded()
		view.layoutIfNeeded()
		questionView.layoutIfNeeded()

		titleLabel.borderWidth = 3
		titleLabel.borderColor = .label
		okButton.borderWidth = 2
		okButton.borderColor = .lightGray
		resetButton.borderWidth = 2
		resetButton.borderColor = .label
		skipButton.borderWidth = 2
		skipButton.borderColor = .label
		targetBackgroundView.borderWidth = 3
		targetBackgroundView.borderColor = .label

		titleLabel.cornerRadius = titleLabel.height / 2
		titleShadowView.cornerRadius = titleShadowView.height / 2
		okButton.cornerRadius = okButton.height / 4
		resetButton.cornerRadius = resetButton.height / 2
		skipButton.cornerRadius = skipButton.height / 2
		targetBackgroundView.cornerRadius = targetBackgroundView.height / 10
		targetShadowView.cornerRadius = targetShadowView.height / 10
		titleShadowView.cornerRadius = titleShadowView.height / 2


		targetCollectionView.frame = targetView.bounds
		questionCollectionView.frame = questionView.bounds
		questionCollectionView.collectionViewLayout.invalidateLayout()
		targetCollectionView.collectionViewLayout.invalidateLayout()

		customAlert.updateFrames(on: self)
	}

	func initialize() {
		self.loadViewIfNeeded()
		shouldDisableOkButton()

		setRemainingProblemLabel()
		self.selectedAnswer = []

		guard let problem = self.problem else {
			return
		}
		titleLabel.setTitle(problem.title, for: .normal)

		self.target = problem.target
		guard let row = problem.size?.first, let col = problem.size?.last, let intRow = Int(String(row)) , let intCol = Int(String(col)) else { return }
		self.rowSize = intRow
		self.colSize = intCol

		size =  Array(repeating: Array(repeating: 0, count: colSize ?? 3), count: rowSize ?? 3)

		targetCollectionView.reloadData()
		questionCollectionView.reloadData()

		guard let childId = childId?.id , let deviceid = UserSettings.deviceId.string(), let objectid = problem.object_id else {
			return
		}

		ApiCaller.shared.initializeProblemGame(objectId: objectid, deviceIdWithChildId:  "\(deviceid)_\(childId)") { result in
			DispatchQueue.main.async {
				switch result {
				case .success(let success):
					//					print("iniialized")
					self.initializeId = success.data?.init_id
					self.objectId = success.data?.object_id

				case .failure(let error):
					print(error)
				}
			}
		}
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

	@IBAction func resetButtonClicked(_ sender: UIButton) {
		guard let problem = problem else { return }
		self.selectedAnswer = []
		self.target = problem.target
		shouldDisableOkButton()
		self.targetCollectionView.reloadData()
	}

	@IBAction func skipButtonPressed(_ sender: UIButton) {
		isCorrect = false
		incrementIndex()
	}
	
	func dismissAlert() {
		customAlert.dismissAlert()
	}

	@IBAction func okButtonPressed(_ sender: UIButton) {
		guard let problem = self.problem, let answers = problem.answers else { return }
//		shouldIncrement = false

		let apiAnswer = Set(answers)
		let selectedAnswer = Set(selectedAnswer)

		if apiAnswer == selectedAnswer {
			isCorrect = true
			customAlert.showAlert(isCorrect: true, on: self)

			if let initializeId = self.initializeId {
				ApiCaller.shared.checkOrTerminateGame(initId: initializeId, isAnswerRight: true, terminateGame: false) { _ in
					//				print("success")
				}
			}
		} else {
			isCorrect = false
			customAlert.showAlert(isCorrect: false, on: self)
			if let initializeId  = initializeId {
				ApiCaller.shared.checkOrTerminateGame(initId: initializeId, isAnswerRight: false, terminateGame: false) { _ in
					//				print("wrong")
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

	private func incrementIndex() {
		self.willMove(toParent: nil)
		self.view.removeFromSuperview()
		self.removeFromParent()
		self.timer?.invalidate()
		delegate?.setCorrectAnswer(isCorrect: isCorrect)
	}
}

// MARK:  UicollectionviewDelagate & uicollectionviewDataSource
extension PatternB002ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		switch collectionView {
		case targetCollectionView:
			return size.count
		case questionCollectionView:
			return 1
		default:
			return 1
		}
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		guard let questions = self.problem?.questions  else { return 0}
		return collectionView == targetCollectionView ? size[section].count : questions.count
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}


	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		loadViewIfNeeded()

		switch collectionView {
		case targetCollectionView :
			let margin : CGFloat = 0

			let colsize = self.colSize ?? 3
			let rowsize = self.rowSize ?? 3

			let width: CGFloat = (collectionView.frame.size.width - margin) / CGFloat(colsize)
			let height: CGFloat = (collectionView.frame.size.height - margin ) / CGFloat(rowsize)

			return CGSize(width: width, height: height)

		case questionCollectionView:
			let margin : CGFloat = 5
			let size: CGFloat = (questionCollectionView.frame.size.width - margin) / CGFloat((self.problem?.questions?.count ?? 5) + 1)

			let newSize = min(65, size)

			return CGSize(width: newSize, height: newSize)

		default :
			return CGSize(width: 0, height: 0)
		}
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

		switch collectionView {
		case targetCollectionView:
			return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

		case questionCollectionView:
			let margin : CGFloat = 5
			let size: CGFloat = (questionCollectionView.frame.size.width - margin) / CGFloat((self.problem?.questions?.count ?? 5) + 1)

			let newSize = min(65, size)

			let totalCellWidth = newSize * CGFloat((self.problem?.questions?.count ?? 5))
			let totalSpacingWidth = 10 * CGFloat((self.problem?.questions?.count ?? 5) - 1)
			let leftInset = (questionCollectionView.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
			let rightInset = leftInset
			return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)

		default:
			return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		}
	}

	func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellB.identifier, for: indexPath) as? CollectionViewCellB else { return }
		cell.problemImageView.kf.cancelDownloadTask()
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let targets = self.target else { return UICollectionViewCell() }
		guard let problem = self.problem else { return UICollectionViewCell() }

		switch collectionView {
		case targetCollectionView:
			guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellB.identifier, for: indexPath) as? CollectionViewCellB else {
				return UICollectionViewCell()
			}
			cell.borderWidth = 1
			cell.borderColor = .black
			cell.backgroundColor = .label
			cell.problemImageView.backgroundColor = UIColor(named: "gameHeadingBackground")

			let matchingTargets = targets.filter { $0.position?.first == String(indexPath.section) && $0.position?.last == String(indexPath.row) }

			if let target = matchingTargets.first, let question = target.question {
				cell.setUpOptionsImage(with: question)
				cell.problemImageView.backgroundColor = .systemBackground
			}
			return cell

		case questionCollectionView:
			guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellB.identifier, for: indexPath) as? CollectionViewCellB else {
				return UICollectionViewCell()
			}

			guard let questions = problem.questions else { return UICollectionViewCell() }
			guard let questionImageAtIndexpath = questions[indexPath.row].question else { return UICollectionViewCell() }

			cell.setUpOptionsImage(with: questionImageAtIndexpath)
//			cell.problemImageView.borderWidth = 1
//			cell.problemImageView.borderColor = .label
			cell.layer.masksToBounds = false
			cell.layer.shadowColor = UIColor.label.cgColor
			cell.layer.shadowOffset = CGSize(width: 3, height: 3)
			cell.layer.shadowRadius = 2
			cell.layer.shadowOpacity = 0.3
			cell.layer.shouldRasterize = true
			cell.layer.rasterizationScale = true ? UIScreen.main.scale : 1

			return cell

		default:
			return UICollectionViewCell()
		}
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		collectionView.deselectItem(at: indexPath, animated: false)
	}
}

// MARK:  ShowCustomAlert
extension PatternB002ViewController: notifyAlertDismiss {
	func isCompleted(value: Bool) {
		guard let problem = self.problem else { return }
		if isCorrect {
			self.selectedAnswer = []
			self.incrementIndex()
			
		} else {
			self.selectedAnswer = []
			self.target = problem.target
			self.targetCollectionView.reloadData()
			self.shouldDisableOkButton()
		}
	}
}

// MARK:  Drag and Drop Delegates

extension PatternB002ViewController: UICollectionViewDragDelegate, UICollectionViewDropDelegate {
	func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
		if collectionView == questionCollectionView {
			guard let questions = self.problem?.questions else { return []}
			let item = questions[indexPath.row]

			let itemProvider = NSItemProvider(object: item)
			let dragItem = UIDragItem(itemProvider: itemProvider)
			dragItem.localObject = item
			return [dragItem]
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
			if let indexpath = destinationIndexPath, let target = self.target {
				let previousTargetData = target.filter { $0.position?.first == String(indexpath.section) && $0.position?.last == String(indexpath.row) }
				if previousTargetData.isEmpty {
					return UICollectionViewDropProposal(operation: .move)
				} else {
					return UICollectionViewDropProposal(operation: .cancel)
				}
			} else {
				return UICollectionViewDropProposal(operation: .cancel)
			}

		case questionCollectionView:
			return UICollectionViewDropProposal(operation: .cancel)

		default:
			return UICollectionViewDropProposal(operation: .cancel)
		}
	}


	func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
		switch coordinator.proposal.operation {
		case .move:

			for item in coordinator.items {
				item.dragItem.itemProvider.loadObject(ofClass: Question.self, completionHandler: { (question, error) in
					guard let indexPath = coordinator.destinationIndexPath else { return }

					if let question = question as? Question, let questionImage = question.question , let questionId = question.question_id {
						self.target?.append(Target(position: ["\(indexPath.section)","\(indexPath.row)"], question: questionImage, question_id: questionId, state: nil))

						self.selectedAnswer.append(Answer(position: ["\(indexPath.section)","\(indexPath.row)"], question_id: questionId, state: nil))

						DispatchQueue.main.async {
							print(self.selectedAnswer.count)

							if self.selectedAnswer.count == self.problem?.answers?.count {
								self.shouldEnableOkButton()
							} else {
								self.shouldDisableOkButton()
							}
						}

						DispatchQueue.main.async {
							self.targetCollectionView.reloadItems(at: [indexPath])
						}

						guard let initId = self.initializeId else { return }


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
extension PatternB002ViewController {
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
