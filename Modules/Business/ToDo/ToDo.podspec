Pod::Spec.new do |s|
  s.name             = 'ToDo'
  s.version          = '0.0.1'
  s.summary          = 'A short description of ToDo.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/fyhNB/ToDo'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'fyhNB' => '1374872604@qq.com' }
  s.source           = { :git => 'https://github.com/fyhNB/ToDo.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'

  s.source_files = 'ToDo/Classes/**/*.swift'
  
  # s.resource_bundles = {
  #   'ToDo' => ['ToDo/Assets/*.png']
  # }
  
  s.dependency 'PGFoundation'
  s.dependency 'Provider'
  s.dependency 'UIComponents'
  
  s.dependency 'RxSwift'
  s.dependency 'RxCocoa'
  s.dependency 'RxDataSources'
  
end
