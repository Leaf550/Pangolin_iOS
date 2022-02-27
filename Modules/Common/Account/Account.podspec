Pod::Spec.new do |s|
  s.name             = 'Account'
  s.version          = '0.0.1'
  s.summary          = 'A short description of Account.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/fyhNB/Account'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'fyhNB' => '1374872604@qq.com' }
  s.source           = { :git => 'https://github.com/fyhNB/Account.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'

  s.source_files = 'Account/Classes/**/*'
  
  # s.resource_bundles = {
  #   'Account' => ['Account/Assets/*.png']
  # }

  s.dependency 'PGFoundation'
  s.dependency 'Provider'
  s.dependency 'UIComponents'
  s.dependency 'Util'
  
  s.dependency 'SnapKit'
  s.dependency 'RxSwift'
  s.dependency 'RxCocoa'
  
end
