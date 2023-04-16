Pod::Spec.new do |s|
  s.name             = 'AppCoordinator'
  s.version          = '0.1.0'
  s.summary          = 'A short description of AppCoordinator.'
  s.description      = 'AppCoordinator module'
  s.homepage         = 'http://somehost/iOS'
  s.license          = { :type => 'MIT' }
  s.author           = 'kulasiriswatdi@gmail.com'
  s.source           = { :git => 'git@somehost/AppCoordinator.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.swift_version    = '5.0'
  s.source_files     = 'AppCoordinator/**/*'

  s.dependency 'Core'
  s.dependency 'CoreUI'
  s.dependency 'APILayer'
  s.dependency 'NewsArticle'
end
