#
# Be sure to run `pod lib lint Mine.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Mine'
  s.version          = '0.0.1'
  s.summary          = 'A short description of Mine.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/fyhNB/Mine'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'fyhNB' => '1374872604@qq.com' }
  s.source           = { :git => 'https://github.com/fyhNB/Mine.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'

  s.source_files = 'Mine/Classes/**/*'
  
  # s.resource_bundles = {
  #   'CYFoundation' => ['Mine/Assets/*.png']
  # }
  
  s.dependency 'PGFoundation'
  s.dependency 'Provider'
  s.dependency 'UIComponents'
  s.dependency 'Net'
  s.dependency 'Util'
  
  s.dependency 'SnapKit'
  s.dependency 'RxSwift'
  s.dependency 'RxCocoa'
  
end
