Pod::Spec.new do |s|
  s.name             = 'Utils'
  s.version          = '0.1.0'
  s.summary          = 'A short description of Utils.'
  s.description      = 'Utils module'
  s.homepage         = 'http://somehost/SuperApp/iOS'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = 'kulasiriswatdi@gmail.com'
  s.source           = { :git => 'git@somehost/Utils.git',
 :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.swift_version    = '5.0'
  s.source_files     = 'Utils/**/*'
  s.public_header_files = ["Utils/Headers/**/*{.h,.hpp}"]
  
  s.dependency 'RxSwift'
  s.dependency 'RxCocoa'

end
