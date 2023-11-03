// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

// swiftlint:disable sorted_imports
import Foundation
import UIKit

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length implicit_return

// MARK: - Storyboard Scenes

// swiftlint:disable explicit_type_interface identifier_name line_length type_body_length type_name
internal enum StoryboardScene {
  internal enum BirthdayAlert: StoryboardType {
    internal static let storyboardName = "BirthdayAlert"

    internal static let birthdayAlertViewController = SceneType<BirthdayAlertViewController>(storyboard: Self.self, identifier: "BirthdayAlertViewController")
  }
  internal enum ChildrenRegistration: StoryboardType {
    internal static let storyboardName = "ChildrenRegistration"

    internal static let initialScene = InitialSceneType<ChildRegistrationViewController>(storyboard: Self.self)

    internal static let avatarSelectionViewController = SceneType<AvatarSelectionViewController>(storyboard: Self.self, identifier: "AvatarSelectionViewController")

    internal static let childRegistrationViewController = SceneType<ChildRegistrationViewController>(storyboard: Self.self, identifier: "ChildRegistrationViewController")
  }
  internal enum ChooseChildren: StoryboardType {
    internal static let storyboardName = "ChooseChildren"

    internal static let initialScene = InitialSceneType<UIKit.UINavigationController>(storyboard: Self.self)

    internal static let chooseChildrenViewController = SceneType<ChooseChildrenViewController>(storyboard: Self.self, identifier: "ChooseChildrenViewController")
  }
  internal enum ContentSelection: StoryboardType {
    internal static let storyboardName = "ContentSelection"

    internal static let contentSelectionViewController = SceneType<ContentSelectionViewController>(storyboard: Self.self, identifier: "ContentSelectionViewController")
  }
  internal enum FillParentPassword: StoryboardType {
    internal static let storyboardName = "FillParentPassword"

    internal static let initialScene = InitialSceneType<UIKit.UINavigationController>(storyboard: Self.self)

    internal static let parentPasswordInputViewController = SceneType<ParentPasswordInputViewController>(storyboard: Self.self, identifier: "ParentPasswordInputViewController")
  }
  internal enum IndicatorView: StoryboardType {
    internal static let storyboardName = "IndicatorView"

    internal static let initialScene = InitialSceneType<IndicatorViewController>(storyboard: Self.self)

    internal static let indicatorViewController = SceneType<IndicatorViewController>(storyboard: Self.self, identifier: "IndicatorViewController")
  }
  internal enum LaunchScreen: StoryboardType {
    internal static let storyboardName = "LaunchScreen"

    internal static let initialScene = InitialSceneType<RootViewController>(storyboard: Self.self)

    internal static let rootViewController = SceneType<RootViewController>(storyboard: Self.self, identifier: "RootViewController")
  }
  internal enum LicenseInformation: StoryboardType {
    internal static let storyboardName = "LicenseInformation"

    internal static let licenseDetailViewController = SceneType<LicenseDetailViewController>(storyboard: Self.self, identifier: "LicenseDetailViewController")

    internal static let licenseInformationViewController = SceneType<LicensesViewController>(storyboard: Self.self, identifier: "LicenseInformationViewController")
  }
  internal enum Main: StoryboardType {
    internal static let storyboardName = "Main"

    internal static let mainViewController = SceneType<MainViewController>(storyboard: Self.self, identifier: "MainViewController")

//    internal static let slidingViewController = SceneType<SlidingViewController>(storyboard: Self.self, identifier: "SlidingViewController")
  }
  internal enum OnboardingScreen: StoryboardType {
    internal static let storyboardName = "OnboardingScreen"

    internal static let initialScene = InitialSceneType<OnboardingViewController>(storyboard: Self.self)

    internal static let onboardingViewController = SceneType<OnboardingViewController>(storyboard: Self.self, identifier: "OnboardingViewController")
  }
  internal enum ParentRegistration: StoryboardType {
    internal static let storyboardName = "ParentRegistration"

    internal static let parentRegistrationViewController = SceneType<ParentRegistrationViewController>(storyboard: Self.self, identifier: "ParentRegistrationViewController")
  }
  internal enum ProblemSetting: StoryboardType {
    internal static let storyboardName = "ProblemSetting"

    internal static let initialScene = InitialSceneType<UIKit.UINavigationController>(storyboard: Self.self)

    internal static let helpViewController = SceneType<HelpViewController>(storyboard: Self.self, identifier: "HelpViewController")

    internal static let problemSettingViewController = SceneType<ProblemSettingViewController>(storyboard: Self.self, identifier: "ProblemSettingViewController")
  }
  internal enum Quiz: StoryboardType {
    internal static let storyboardName = "Quiz"

    internal static let initialScene = InitialSceneType<QuizManagerViewController>(storyboard: Self.self)

    internal static let patternA1ViewController = SceneType<PatternA1ViewController>(storyboard: Self.self, identifier: "PatternA1ViewController")

    internal static let patternB001ViewController = SceneType<PatternB001ViewController>(storyboard: Self.self, identifier: "PatternB001ViewController")

    internal static let patternB002ViewController = SceneType<PatternB002ViewController>(storyboard: Self.self, identifier: "PatternB002ViewController")

    internal static let patternC00ViewController = SceneType<PatternC00ViewController>(storyboard: Self.self, identifier: "PatternC00ViewController")

    internal static let quizManagerViewController = SceneType<QuizManagerViewController>(storyboard: Self.self, identifier: "QuizManagerViewController")
  }
  internal enum Settings: StoryboardType {
    internal static let storyboardName = "Settings"

    internal static let settingViewController = SceneType<SettingViewController>(storyboard: Self.self, identifier: "SettingViewController")
  }
  internal enum SwitchUser: StoryboardType {
    internal static let storyboardName = "SwitchUser"

    internal static let initialScene = InitialSceneType<UIKit.UINavigationController>(storyboard: Self.self)

    internal static let switchUserViewController = SceneType<SwitchUserViewController>(storyboard: Self.self, identifier: "SwitchUserViewController")
  }
  internal enum TermsOfService: StoryboardType {
    internal static let storyboardName = "TermsOfService"

    internal static let initialScene = InitialSceneType<TermsOfServiceViewController>(storyboard: Self.self)

    internal static let termsOfServiceViewController = SceneType<TermsOfServiceViewController>(storyboard: Self.self, identifier: "TermsOfServiceViewController")
  }
  internal enum TopView: StoryboardType {
    internal static let storyboardName = "TopView"

    internal static let initialScene = InitialSceneType<TopViewController>(storyboard: Self.self)

    internal static let topViewController = SceneType<TopViewController>(storyboard: Self.self, identifier: "TopViewController")
  }
//  internal enum Tutorial: StoryboardType {
//    internal static let storyboardName = "Tutorial"
//
//    internal static let initialScene = InitialSceneType<TutorialViewController>(storyboard: Self.self)
//
//    internal static let tutorialViewController = SceneType<TutorialViewController>(storyboard: Self.self, identifier: "TutorialViewController")
//  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length type_body_length type_name

// MARK: - Implementation Details

internal protocol StoryboardType {
  static var storyboardName: String { get }
}

internal extension StoryboardType {
  static var storyboard: UIStoryboard {
    let name = self.storyboardName
    return UIStoryboard(name: name, bundle: BundleToken.bundle)
  }
}

internal struct SceneType<T: UIViewController> {
  internal let storyboard: StoryboardType.Type
  internal let identifier: String

  internal func instantiate() -> T {
    let identifier = self.identifier
    guard let controller = storyboard.storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
      fatalError("ViewController '\(identifier)' is not of the expected class \(T.self).")
    }
    return controller
  }

  @available(iOS 13.0, tvOS 13.0, *)
  internal func instantiate(creator block: @escaping (NSCoder) -> T?) -> T {
    return storyboard.storyboard.instantiateViewController(identifier: identifier, creator: block)
  }
}

internal struct InitialSceneType<T: UIViewController> {
  internal let storyboard: StoryboardType.Type

  internal func instantiate() -> T {
    guard let controller = storyboard.storyboard.instantiateInitialViewController() as? T else {
      fatalError("ViewController is not of the expected class \(T.self).")
    }
    return controller
  }

  @available(iOS 13.0, tvOS 13.0, *)
  internal func instantiate(creator block: @escaping (NSCoder) -> T?) -> T {
    guard let controller = storyboard.storyboard.instantiateInitialViewController(creator: block) else {
      fatalError("Storyboard \(storyboard.storyboardName) does not have an initial scene.")
    }
    return controller
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
