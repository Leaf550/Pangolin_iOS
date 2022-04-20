Pod::Spec.new do |s|
  s.name             = 'BBS'
  s.version          = '0.0.1'
  s.summary          = 'A short description of BBS.'

  s.description      = <<-DESC
BBS: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/fyhNB/BBS'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'fyhNB' => '1374872604@qq.com' }
  s.source           = { :git => 'https://github.com/fyhNB/BBS.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'

  s.source_files = 'BBS/Classes/**/*.swift'
  
  # s.resource_bundles = {
  #   'BBS' => ['BBS/Assets/*.png']
  # }
  
  s.dependency 'PGFoundation'
  s.dependency 'Provider'
  s.dependency 'UIComponents'
  s.dependency 'Net'
  s.dependency 'Router'
  
  s.dependency 'RxSwift'
  s.dependency 'RxCocoa'
  s.dependency 'Gallery'
  
end
