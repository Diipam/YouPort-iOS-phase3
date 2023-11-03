//
//  MainViewController.swift
//  LearningApp-Kid
//
//  Created by Prakash Bist on 5/11/22.
//  Copyright © 2022 SmartSolarNepal. All rights reserved.
//

import UIKit
import WebKit
import SnapKit
import Kingfisher
import ProgressHUD
import SideMenu

class MainViewController: UIViewController, WKNavigationDelegate, WKUIDelegate, UIScrollViewDelegate  {
    static let identifier = String(describing: MainViewController.self)
    var childDetails: AllChilds? = nil
    var allQuestions: AllQuestionResponse? = nil
    
    var timer: Timer?
    var webView: WKWebView?
    
    @IBOutlet weak var playQuizButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadViewIfNeeded()
        setUpNavigationBar(isBackButtonHidden: false, isLogoHidden: false, isSettingIconHidden: false)
        setupWebView()
        loadYoutube()

        if let webView = webView {
            self.contentView.addSubview(webView)
            view.sendSubviewToBack(webView)
            webView.navigationDelegate = self
            webView.scrollView.delegate = self

            let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swippedLeft(_:)))
            leftSwipeGesture.direction = .left
            self.view.addGestureRecognizer(leftSwipeGesture)

            let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swippedRight(_:)))
            rightSwipeGesture.direction = .right
            self.view.addGestureRecognizer(rightSwipeGesture)
            webView.isUserInteractionEnabled = true
        }

        // for testing purpose only
        playQuizButton.isHidden = false

    }

    private func setupWebView() {
        // webview内のテキスト選択禁止
        let disableSelectionScriptString = "document.documentElement.style.webkitUserSelect='none';"
        // webview内の長押しによるメニュー表示禁止
        let disableCalloutScriptString = "document.documentElement.style.webkitTouchCallout='none';"
        let disableSelectionScript = WKUserScript(source: disableSelectionScriptString, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let disableCalloutScript = WKUserScript(source: disableCalloutScriptString, injectionTime: .atDocumentEnd, forMainFrameOnly: true)

        let controller = WKUserContentController()
        controller.addUserScript(disableSelectionScript)
        controller.addUserScript(disableCalloutScript)

        // コンフィグ作成
        let config = WKWebViewConfiguration()
        config.userContentController = controller // 上記の操作禁止を反映
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []
        // 上記のコンフィグを反映してWKWebView作成
        webView = WKWebView(frame: .zero, configuration: config)

        webView?.translatesAutoresizingMaskIntoConstraints = false
    }
    
    public func loadYoutube() {
        DispatchQueue.global(qos: .userInitiated).async {
            let tiktokUrl = URL(string: "https://www.tiktok.com/")
            let youtubeUrl = URL(string: "https://www.youtube.com/")
            var contentUrl: URL?

            let content = UserSettings.contentType.string()
            if content == ContentType.youtube.rawValue {
                contentUrl = youtubeUrl
            } else if content == ContentType.tiktok.rawValue {
                contentUrl = tiktokUrl
            }
            let request = URLRequest(url: contentUrl!,
                                     cachePolicy: .returnCacheDataElseLoad,
                                     timeoutInterval: 30.0)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if let webView = self.webView {
                    webView.load(request)
                }
            }
        }
    }
    
    @objc func swippedLeft(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if let webView = self.webView {
                    webView.goForward()
                }
            }
        }
    }

    @objc func swippedRight(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .right {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if let webView = self.webView {
                    webView.goBack()
                }
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addConstraints()
        playQuizButton.cornerRadius = playQuizButton.height / 2
    }
    
    func addConstraints() {
        var constraints = [NSLayoutConstraint]()
        guard let webView = webView else { return }
        // Add
        constraints.append(webView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor))
        constraints.append(webView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor))
        constraints.append(webView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor))
        constraints.append(webView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor))
        // Activate
        NSLayoutConstraint.activate(constraints)
    }

    // MARK: - Api Calls -
    func getId() {
        guard let childInfo = UserSettings.childInfo.childInfo() else {
            print("no child info saved in main")
            return
        }
        print("main view controller")
        print(childInfo)

        ApiCaller.shared.getAllChildById(childId: childInfo.id) {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.childDetails = response.data
                    self?.getAllProblems()
                    
                case .failure(let error):
                    ProgressHUD.showError(error.localizedDescription)
                }
            }
        }
    }
    
    func getAllProblems() {
        let problemDifficulty = self.childDetails?.problem_settings?.first?.problem_difficulty ?? 1
        let objectId = UserSettings.quizObjectId.string()
        let problemId = UserSettings.quizProblemId.string()
        setupObserver()
        
        ApiCaller.shared.getAllProblemQuestions(problemDifficulty: "\(problemDifficulty)", objectId: objectId, problemId: problemId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
//                print(response)
                    self?.allQuestions = response
                    if let problemId = response.info?.lastEvaluatedKey?.problem_id, let objectId = response.info?.lastEvaluatedKey?.object_id {
                        UserSettings.quizProblemId.set(value: problemId)
                        UserSettings.quizObjectId.set(value: objectId)
                    } else {
                        UserSettings.quizProblemId.set(value: nil)
                        UserSettings.quizObjectId.set(value: nil)
                    }
                    self?.fireTimer()
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }


    // MARK: - Quiz Button -
    @IBAction func playQuizButtonClicked(_ sender: Any) {
        ProgressHUD.show()
        let problemDifficulty = self.childDetails?.problem_settings?.first?.problem_difficulty ?? 1
        let objectId = UserSettings.quizObjectId.string()
        let problemId = UserSettings.quizProblemId.string()
        
//        print(problemDifficulty)
        ApiCaller.shared.getAllProblemQuestions(problemDifficulty: "\(problemDifficulty)",objectId: objectId, problemId: problemId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.allQuestions = response
                    if let problemId = response.info?.lastEvaluatedKey?.problem_id, let objectId = response.info?.lastEvaluatedKey?.object_id {
                        UserSettings.quizProblemId.set(value: problemId)
                        UserSettings.quizObjectId.set(value: objectId)
                    } else {
                        UserSettings.quizProblemId.set(value: nil)
                        UserSettings.quizObjectId.set(value: nil)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0) { [weak self] in
                        self?.webView?.pauseAllMediaPlayback {
                            guard let allQuestions = self?.allQuestions, let childDetails = self?.childDetails else { return }
                            ProgressHUD.dismiss()
                            let vc = StoryboardScene.Quiz.quizManagerViewController.instantiate()
                            vc.childDetails = childDetails
                            vc.AllProblems = allQuestions
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .fullScreen
                            self?.present(vc, animated: true)

                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url,
           let scheme = url.scheme {
            if scheme.elementsEqual("http") ||
                scheme.elementsEqual("https") ||
                scheme.elementsEqual("file") {
//                print(url.description)
                if (url.description.contains("login")) {
                    decisionHandler(.allow)
                    return
                } else if (url.description.contains("redirect")) {
                    decisionHandler(.cancel)
                    return
                }

                decisionHandler(.allow)
                return
            }
        }
        decisionHandler(.cancel)
    }
}

// MARK:  Extension to handle timer to show quiz
extension MainViewController {
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
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
                self.webView?.pauseAllMediaPlayback()
                timer?.invalidate()
            }
        }
    }
    
    func fireTimer() {
        guard let questionFrequency = self.childDetails?.problem_settings?.first?.question_frequency else { return }
        let frequency = Double(questionFrequency * 60)
        timer = Timer.scheduledTimer(withTimeInterval: frequency, repeats: false) {[weak self] timer in

            switch UIApplication.shared.applicationState {
            case .active:
                DispatchQueue.main.async {
                    self?.webView?.pauseAllMediaPlayback {
                        guard let allQuestions = self?.allQuestions, let childDetails = self?.childDetails else { return }
                        let vc = StoryboardScene.Quiz.quizManagerViewController.instantiate()
                        vc.childDetails = childDetails
                        vc.AllProblems = allQuestions
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .fullScreen
                        self?.present(vc, animated: true)

                    }
                }
                timer.invalidate()
                break
                
            case .inactive, .background:
                timer.invalidate()
                break
                
            @unknown default:
                timer.invalidate()
                break
            }
        }
    }
}

extension MainViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.all)
        getId()
    }
}

