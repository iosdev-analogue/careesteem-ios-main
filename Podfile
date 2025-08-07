# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'CareEsteem' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for careesteem
  pod "PinCodeInputView"
  pod 'SDWebImage'
  pod 'IQKeyboardManagerSwift'
  pod 'SKCountryPicker', '2.0.0'
  pod 'FirebaseCrashlytics'
  pod 'Firebase/Messaging'
  pod 'Firebase/InAppMessaging'
  pod 'Firebase/Analytics'
  pod 'GoogleMaps'
  pod 'GooglePlaces'
  pod 'DropDown'
end
post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    #  config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
  end
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
    end
  end
end
