Pod::Spec.new do |s|
  s.name             = 'Starter'
  s.version          = '0.0.1'
  s.summary          = 'A short description of Starter.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/fyhNB/Starter'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'fyhNB' => '1374872604@qq.com' }
  s.source           = { :git => 'https://github.com/fyhNB/Starter.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'

  s.source_files = 'Starter/Classes/**/*'
  
  # s.resource_bundles = {
  #   'Starter' => ['Starter/Assets/*.png']
  # }

  s.dependency 'PGFoundation'
  s.dependency 'Provider'
  s.dependency 'UIComponents'

  # s.dependency 'AFNetworking', '~> 2.3'
end
