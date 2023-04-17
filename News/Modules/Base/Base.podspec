Pod::Spec.new do |s|
  s.name             = 'Base'
  s.version          = '0.1.0'
  s.summary          = 'A short description of Base.'
  s.description      = 'Base module'
  s.homepage         = 'http://somehost/SuperApp/iOS'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = 'kulasiriswatdi@gmail.com'
  s.source           = { :git => 'git@somehost/Base.git',
 :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.swift_version    = '5.0'
  s.source_files     = 'Base/**/*'

  s.public_header_files = ["Base/Headers/**/*{.h,.hpp}"]

  s.dependency 'APILayer'
  s.dependency 'Utils'
  s.dependency 'CoreUI'
end


