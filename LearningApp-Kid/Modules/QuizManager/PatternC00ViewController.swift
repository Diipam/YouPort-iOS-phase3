//
//  PatternC00ViewController.swift
//  LearningApp-Kid
//
//  Created by Anisha Lamichhane on 27/09/2022.
//  Copyright © 2022 SmartSolarNepal. All rights reserved.
//

import UIKit

class PatternC00ViewController: UIViewController {

	// MARK: - IbOutlets-

	@IBOutlet weak var titleLabelShadowView: ShadowView!
	@IBOutlet weak var targetView: UIView!
	@IBOutlet weak var questionShadowView: ShadowView!
	@IBOutlet weak var questionBackgroundView: UIView!
	@IBOutlet weak var questionView: UIView!
	@IBOutlet weak var problemRemainingLabel: UILabel!
	@IBOutlet weak var titleLabel: UIButton!
	@IBOutlet weak var resetButton: UIButton!
	@IBOutlet weak var skipButton: UIButton!
	@IBOutlet weak var okButton: UIButton!


	// MARK: - Properties -
	var problem: AllQuestions? = nil
	var childId: AllChilds? = nil
	var isCorrect: Bool = false

	var objectId: String? = nil
	var initializeId: String? = nil

	var rowSize : Int? = nil
	var colSize: Int? = nil
	private var size = [[Int]]()

	var remainingProblemCount = ""

	var target = [[Target?]]()
	var question = [[Question?]]()

	var previousIndexpath: IndexPath? = nil
	var previousBackgroundColor : UIColor? = nil

	weak var delegate: ReturnIndexToQuizManager?
	var timer: Timer?
	let customAlert = MyAlert()

	private lazy var questionCollectionView: UICollectionView = {
		var layout = UICollectionViewFlowLayout()
		layout.minimumInteritemSpacing = 0
		layout.minimumLineSpacing = 0

		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.isScrollEnabled = false
		collectionView.backgroundColor = UIColor(named: "gameHeadingBackground")
		collectionView.register(UINib(nibName: CollectionViewCellC.identifier, bundle: nil), forCellWithReuseIdentifier: CollectionViewCellC.identifier)
		questionView.addSubview(collectionView)

		return collectionView
	}()

	private lazy var targetCollectionView: UICollectionView = {
		var layout = UICollectionViewFlowLayout()
		layout.minimumInteritemSpacing = 0
		layout.minimumLineSpacing = 0

		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.isScrollEnabled = false
		collectionView.register(UINib(nibName: CollectionViewCellC.identifier, bundle: nil), forCellWithReuseIdentifier: CollectionViewCellC.identifier)
		targetView.addSubview(collectionView)

		return collectionView
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		view.layoutIfNeeded()

		okButton.setTitle("OK".localized(), for: .normal)
		skipButton.setTitle("Skip".localized(), for: .normal)
		resetButton.setTitle("Reset".localized(), for: .normal)

		customAlert.delegate = self
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		loadViewIfNeeded()
		view.layoutIfNeeded()

		titleLabel.borderWidth = 3
		titleLabel.borderColor = .label
		okButton.borderWidth = 2
		okButton.borderColor = .lightGray
		questionBackgroundView.borderWidth = 3
		questionBackgroundView.borderColor = .label
		resetButton.borderWidth = 2
		resetButton.borderColor = .label
		skipButton.borderWidth = 2
		skipButton.borderColor = .label

		titleLabel.cornerRadius = titleLabel.height / 2
		titleLabelShadowView.cornerRadius = titleLabelShadowView.height / 2
		okButton.cornerRadius = okButton.height / 4
		resetButton.cornerRadius = resetButton.height / 2
		skipButton.cornerRadius = skipButton.height / 2
		questionBackgroundView.cornerRadius = questionBackgroundView.height / 10
		questionShadowView.cornerRadius = questionShadowView.height / 10

		targetCollectionView.frame = targetView.bounds
		questionCollectionView.frame = questionView.bounds

		questionCollectionView.collectionViewLayout.invalidateLayout()
		targetCollectionView.collectionViewLayout.invalidateLayout()

		customAlert.updateFrames(on: self)
	}

	func initializeProblem() {
		loadViewIfNeeded()
		view.layoutIfNeeded()
		
		setRemainingProblemLabel()
		self.previousIndexpath = nil
		self.previousBackgroundColor = nil

		guard let problem = problem else { return }
		self.problem = problem

		titleLabel.setTitle(problem.title ?? "", for: .normal)
		guard let rowSize = problem.size?.first, let colSize = problem.size?.last, let rows = Int(String(rowSize)), let columns = Int(String(colSize))  else { return }
		self.rowSize = rows
		self.colSize = columns
		self.size =  Array(repeating: Array(repeating: 0, count: columns), count: rows)

		target = Array(repeating: Array(repeating: nil, count: columns), count: rows)
		question = Array(repeating: Array(repeating: nil, count: columns), count: rows)

		guard let apiTarget = problem.target else {print("no problemTarget")
			return
		}
		
		var i = 0
		for row in (0...rows-1) {
			for col in (0...columns-1){

				if i < apiTarget.count  {
					target[row][col] = apiTarget[i]
					i = i + 1
				} else {
					target[row][col] = Target(position: nil, state: nil)
				}
			}
		}

		guard let apiQuestions = problem.questions else {print("no api Questions")
			return
		}
		var j = 0
		for row in (0...rows-1) {
			for col in (0...columns-1){

				if j < apiQuestions.count {
					question[row][col] = apiQuestions[j]
					j = j + 1
				} else {
					question[row][col] = Question(question: "", question_id: "", state: "", position: nil)
				}
			}
		}

		shouldDisableOkButton()

		targetCollectionView.reloadData()
		questionCollectionView.reloadData()

		guard let childId = childId?.id, let objectid = problem.object_id , let deviceid = UserSettings.deviceId.string() else {
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
					print("failed to initialize")
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


	func dismissAlert() {
		customAlert.dismissAlert()
	}


	@IBAction func okButtonPressed(_ sender: UIButton) {
		if isCorrect {
			customAlert.showAlert(isCorrect: true, on: self)

			guard let initializeId = initializeId else { return}
//			print(initializeId)
			ApiCaller.shared.checkOrTerminateGame(initId: initializeId, isAnswerRight: true, terminateGame: false) { _ in
//									print("success")
			}
		} else {
			customAlert.showAlert(isCorrect: false, on: self)

			guard let initializeId = initializeId else { return}
			ApiCaller.shared.checkOrTerminateGame(initId: initializeId, isAnswerRight: false, terminateGame: false) { _ in
//									print("failed")
			}
		}
	}


	@IBAction func resetButtonPressed(_ sender: UIButton) {
		targetCollectionView.reloadData()
		isCorrect = false
		shouldDisableOkButton()
	}


	@IBAction func skipButtonPressed(_ sender: UIButton) {
		isCorrect = false
		incrementIndex()
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
		timer?.invalidate()

		delegate?.setCorrectAnswer(isCorrect: isCorrect)
	}
}

// MARK:  ShowCustomAlert
extension PatternC00ViewController: notifyAlertDismiss {
	func isCompleted(value: Bool) {
		if isCorrect {
			self.incrementIndex()
			self.targetCollectionView.reloadData()
		} else {
			self.targetCollectionView.reloadData()
			self.shouldDisableOkButton()
		}
	}
}

extension PatternC00ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		switch collectionView {
		case questionCollectionView:
			return question.count

		case targetCollectionView:
			return target.count

		default:
			return 0
		}
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return collectionView == questionCollectionView ? question[section].count : target[section].count
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let margin : CGFloat = 0

		let colsize = self.colSize ?? 9
		let rowsize = self.rowSize ?? 9

		let width: CGFloat = (collectionView.frame.size.width - margin) / CGFloat(colsize)
		let height: CGFloat = (collectionView.frame.size.height - margin ) / CGFloat(rowsize)

		return CGSize(width: width, height: height)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if collectionView == targetCollectionView {
			shouldEnableOkButton()

			guard let answer = problem?.answers, let answerPosition = answer.first?.position else {
				print("no answer available")
				return
			}

			guard let target = target[indexPath.section][indexPath.row], let targetPosition = target.position else {
				print("no target info provided")
				return
			}

			if let previousIndexpath = self.previousIndexpath, let previousBackgroundColor = previousBackgroundColor {
				guard let newCell = collectionView.cellForItem(at: previousIndexpath) as? CollectionViewCellC else { return }
				newCell.selectedView.backgroundColor = previousBackgroundColor
			}

			guard let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCellC else { return }
			self.previousIndexpath = indexPath
			self.previousBackgroundColor = cell.selectedView.backgroundColor

			cell.selectedView.backgroundColor = .systemBlue

			let i = indexPath.section
			let j = indexPath.row

			if let initializeId = initializeId , let colSize = colSize {
				let position = (colSize * i) + j
				ApiCaller.shared.updateInitializeProblemGame(initId: initializeId, questionId: "\(position)", append: true) { _ in
//					print(position)
//					print("success")
				}
			}

			if answerPosition == targetPosition {
//				print("correct")
				isCorrect = true

			} else {
//				print("wrong")
				isCorrect = false
			}
		}

	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard var cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellC.identifier, for: indexPath) as? CollectionViewCellC else { return UICollectionViewCell()}


		switch collectionView {
		case questionCollectionView:

			guard let question = question[indexPath.section][indexPath.row], let state = question.state else {
				print("no state")
				cell.borderColor = UIColor.black
				cell.selectedView.backgroundColor = UIColor.clear
				return cell
			}

			cell = checkState(with: state, cell: cell)

		case targetCollectionView:
			guard let target = target[indexPath.section][indexPath.row], let state = target.state else {
				print("no state")
				cell.borderColor = UIColor.black
				cell.selectedView.backgroundColor = UIColor.clear
				return cell
			}
			cell = checkState(with: state, cell: cell)

		default:
			break

		}
		return cell
	}

	func checkState(with state: String?, cell: CollectionViewCellC) -> CollectionViewCellC {
		guard let state = state else {
			print("no state")
			cell.borderWidth = 0
			cell.borderColor = UIColor.black
			cell.selectedView.backgroundColor = UIColor.clear
			return cell
		}

		if state == "fill" {
			cell.borderWidth = 1
			cell.borderColor = UIColor.black
			cell.selectedView.backgroundColor = UIColor(named: "puzzleColor")

		} else if state == "blank" {
			cell.borderWidth = 1
			cell.borderColor = UIColor.black
			cell.selectedView.backgroundColor = UIColor.white

		} else if state == "empty" {
			cell.borderWidth = 0
			cell.borderColor = UIColor.black
			cell.selectedView.backgroundColor = UIColor.clear

		} else {
			cell.borderWidth = 0
			cell.borderColor = UIColor.black
			cell.selectedView.backgroundColor = UIColor.clear
		}

		return cell
	}
}

// MARK:  Extension to handle timer for answerTime
extension PatternC00ViewController {
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

