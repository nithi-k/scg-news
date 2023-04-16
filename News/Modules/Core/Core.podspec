Pod::Spec.new do |s|
  s.name             = 'Core'
  s.version          = '0.1.0'
  s.summary          = 'A short description of Core.'
  s.description      = 'Core module'
  s.homepage         = 'http://somehost/iOS'
  s.license          = { :type => 'MIT' }
  s.author           = 'kulasiriswatdi@gmail.com'
  s.source           = { :git => 'git@somehost/Core.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.swift_version    = '5.0'
  s.source_files     = 'Core/**/*'
  
  s.dependency 'RxSwift'
  s.dependency 'RxCocoa'
end
