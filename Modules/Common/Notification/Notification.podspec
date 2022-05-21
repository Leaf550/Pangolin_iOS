#
# Be sure to run `pod lib lint Notification.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Notification'
  s.version          = '0.0.1'
  s.summary          = 'A short description of Notification.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/fyhNB/Notification'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'fyhNB' => '1374872604@qq.com' }
  s.source           = { :git => 'https://github.com/fyhNB/Notification.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'

  s.source_files = 'Notification/Classes/**/*'
  
  # s.resource_bundles = {
  #   'CYFoundation' => ['Notification/Assets/*.png']
  # }
  
  s.dependency 'PGFoundation'
  s.dependency 'Provider'
  
end
