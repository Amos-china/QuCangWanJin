# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
source 'https://github.com/CocoaPods/Specs.git'

target 'QuCangWanJin' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

   pod 'MJExtension'
   pod 'STPopup'
   pod 'Masonry'
   pod 'MMKV'
   pod 'YYText'
   
   pod 'AFNetworking', '~> 4.0.1'
   pod 'WechatOpenSDK-XCFramework'
   pod 'SDWebImage'
   pod 'SVProgressHUD'
   
   pod 'HJDanmaku'
   
   pod 'FMDB'
   pod 'UICountingLabel'
   pod 'lottie-ios_Oc'
   
   pod 'IQKeyboardManager'

  pod 'Ads-CN-Beta', '7.2.0.6', :subspecs => ['CSJMediation']
  # 引入融合Adapters(推荐使用自动拉取adapter工具，此处无需引入)
  pod 'GMGdtAdapter-Beta', '4.15.60.0'
  pod 'GMBaiduAdapter-Beta', '10.02.0'
  pod 'GMKsAdapter-Beta', '4.9.20.1.0'
  pod 'GMSigmobAdapter-Beta', '4.20.3.0'
  # 引入使用到的ADN SDK，开发者请按需引入
  pod 'GDTMobSDK', '4.15.60'
  pod 'BaiduMobAdSDK', '10.02'
  pod 'KSAdSDK', '4.9.20.1'
  pod 'SigmobAd-iOS', '4.20.3'

   
   pod 'WechatOpenSDK-XCFramework'
   
   pod  'BDASignalSDK'
   pod  'Protobuf'
   
   pod 'UMCommon', '~> 7.5.5'
   
   
   post_install do |installer|
     installer.pods_project.targets.each do |target|
       target.build_configurations.each do |config|
         config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
       end
     end
   end

  # Pods for QuCangWanJin

end
