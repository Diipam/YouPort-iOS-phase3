# Uncomment the next line to define a global platform for your project
# platform :ios, '15.0'

target 'LearningApp-Kid' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for LearningApp-Kid
	pod 'Cosmos'
	pod 'ProgressHUD'
  pod 'Kingfisher'
	pod 'IQKeyboardManagerSwift'
	pod 'SideMenu'
	pod 'SnapKit'
	pod 'SwiftGen'
  pod 'DropDown'

  target 'LearningApp-KidTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'LearningApp-KidUITests' do
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
    end
  end
end
