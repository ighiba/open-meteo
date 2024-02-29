source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '13.0'
use_frameworks!

target 'OpenMeteo' do
    pod 'SnapKit', '~> 5.0.0'
    pod 'RealmSwift', '~> 10.47'
end

post_install do |installer|
 installer.pods_project.targets.each do |target|
  target.build_configurations.each do |config|
   config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
  end
 end
end