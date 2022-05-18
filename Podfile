source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/fyhNB/PGPodRepo.git'

platform :ios, '13.0'

# 业务模块
def developmentPods
  # commom
  pod 'Provider', :path => 'Modules/Common/Provider'
  pod 'Util', :path => 'Modules/Common/Util'
  pod 'Router', :path => 'Modules/Common/Router'
  pod 'Hybrid', :path => 'Modules/Common/Hybrid'
  pod 'Net', :path => 'Modules/Common/Net'
  pod 'UIComponents', :path => 'Modules/Common/UIComponents'
  pod 'Account', :path => 'Modules/Common/Account'
  pod 'Persistence', :path => 'Modules/Common/Persistence'
  
  # business
  pod 'Starter', :path => 'Modules/Business/Starter'
  pod 'ToDo', :path => 'Modules/Business/ToDo'
  pod 'BBS', :path => 'Modules/Business/BBS'
  
end

# 私有组件
def privatePods
  # commom
  pod 'PGFoundation', '0.1.2'
end

# 公网第三方库
def thirdPartPods
  pod 'Alamofire', '5.4.4',   :inhibit_warnings => true
  pod 'SnapKit', '5.0.1',     :inhibit_warnings => true
  pod 'RxSwift', '6.2.0',     :inhibit_warnings => true
  pod 'RxCocoa', '6.2.0',     :inhibit_warnings => true
  pod 'RxDataSources', '5.0', :inhibit_warnings => true
  pod 'Toast-Swift', '5.0.1', :inhibit_warnings => true
  pod 'MMKV', '1.2.11', :inhibit_warnings => true
  pod 'Gallery', '2.4.0', :inhibit_warnings => true
  pod 'SDWebImage', '5.0', :inhibit_warnings => true
end

target 'Pangolin_iOS' do
  use_frameworks!
  
  privatePods
  developmentPods
  thirdPartPods
end
