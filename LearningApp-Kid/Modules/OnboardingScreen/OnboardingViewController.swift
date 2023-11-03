//
//  TutorialViewController.swift
//  LearningApp-Kid
//
//  Created by Anisha Lamichhane on 14/10/2022.
//  Copyright © 2022 SmartSolarNepal. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var screenLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var onboardingImage: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var setPasswordButton: UIButton!
    @IBOutlet weak var startedLabel: UILabel!


    // MARK: - Properties -
    var actualSlide = [OnboardingSlides]()

    var currentPage = 0 {
        didSet{
            pageControl.currentPage  = currentPage
            guard let preferredLanguage = Locale.preferredLanguages.first else {return}

            actualSlide = preferredLanguage.hasPrefix("ja") ? slidesForJapanese : slidesForEnglish
            //			print(preferredLanguage)
            pageControl.numberOfPages = actualSlide.count

            if currentPage == actualSlide.count - 1 {
                onboardingImage.isHidden = true
                startedLabel.isHidden = false
                setPasswordButton.isHidden = false
            } else {
                onboardingImage.isHidden = false
                startedLabel.isHidden = true
                setPasswordButton.isHidden = true
            }

            setUp(actualSlide[currentPage])
        }
    }

    var slidesForJapanese : [OnboardingSlides] = [
        OnboardingSlides(screenTypeLabel: "", titleLabel: "動画視聴中にクイズを出題して \n 考える力を鍛えます！", image: UIImage(named: "item1_ja")),
        OnboardingSlides(screenTypeLabel: "お子さま情報登録画面", titleLabel: "お子さま情報を \n 登録しましょう！", image: UIImage(named: "item2_ja")),
        OnboardingSlides(screenTypeLabel: "問題設定画面", titleLabel: "お子さまに合った \n クイズの設定ができます！", image: UIImage(named: "item3_ja")),
        OnboardingSlides(screenTypeLabel: "動画視聴画面", titleLabel: "YouTubeには成人向けコンテンツを除外するために \n 制限付きモードという機能があります。\n アプリ内のYouTube画面から必ず設定してください。", image: UIImage(named: "item4_ja")),
        OnboardingSlides(screenTypeLabel: "動画視聴画面", titleLabel: "YouTubeには成人向けコンテンツを除外するために \n 制限付きモードという機能があります。\n アプリ内のYouTube画面から必ず設定してください。", image: UIImage(named: "item5_ja")),
        OnboardingSlides(screenTypeLabel: "パスワード設定", titleLabel: "設定内容をお子様がご自身で変更できない \n ように親パスワードを設定します。", image: nil),
    ]

    var slidesForEnglish : [OnboardingSlides] = [
        OnboardingSlides(screenTypeLabel: "", titleLabel: "While watching the video, \n Quizzes will appear to develop your child’s thinking skills!", image: UIImage(named: "item1_en")),
        OnboardingSlides(screenTypeLabel: "Child Information", titleLabel: "Enter your child info", image: UIImage(named: "item2_en")),
        OnboardingSlides(screenTypeLabel: "Quiz Setting", titleLabel: "You can adjust the quiz setting to suit your child’s ability", image: UIImage(named: "item3_en")),
        OnboardingSlides(screenTypeLabel: "Video Screen", titleLabel: "YouTube has a feature called Restricted Mode to exclude adult content. Be sure to set this from the YouTube screen within the application.", image: UIImage(named: "item4_en")),
        OnboardingSlides(screenTypeLabel: "Video Screen", titleLabel: "YouTube has a feature called Restricted Mode to exclude adult content. Be sure to set this from the YouTube screen within the application.", image: UIImage(named: "item5_en")),
        OnboardingSlides(screenTypeLabel: "Password Setting", titleLabel: "Set a parent password to prevent children from changing the settings themselves.", image: nil),
    ]



    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpNavigationBar(isBackButtonHidden: true, isLogoHidden: true, isSettingIconHidden: true)
        currentPage = 0
        startedLabel.text = "Let’s Start!".localized()

        setPasswordButton.setTitle("Set a password".localized(), for: .normal)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeRight.direction = .right

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeLeft.direction = .left

        view.addGestureRecognizer(swipeRight)
        view.addGestureRecognizer(swipeLeft)

    }

    func setUp(_ slide: OnboardingSlides){
        if let image = slide.image {
            onboardingImage.image = image
        }
        screenLabel.text = slide.screenTypeLabel
        messageLabel.text = slide.titleLabel
    }

    @objc func handleSwipeGesture(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .right {
            if currentPage > 0 {
                currentPage -= 1
                UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: { [self] in
                    setUp((actualSlide[currentPage]))
                })
            }
        } else if sender.direction == .left {
            if currentPage < actualSlide.count - 1 {
                currentPage += 1
                UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: { [self] in
                    setUp((actualSlide[currentPage]))
                })
            }
        }
    }


    @IBAction func pageControlPressed(_ sender: UIPageControl) {
        currentPage = sender.currentPage
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: { [self] in
            setUp((actualSlide[currentPage]))
        })
    }


    @IBAction func passwordButtonPressed(_ sender: UIButton) {
        let vc = StoryboardScene.ParentRegistration.parentRegistrationViewController.instantiate()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: lock orientatione
extension OnboardingViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        AppUtility.lockOrientation(.portrait)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }

}


