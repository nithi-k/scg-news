Pod::Spec.new do |s|
  s.name             = 'APILayer'
  s.version          = '0.1.0'
  s.summary          = 'A short description of APILayer.'
  s.description      = 'APILayer module'
  s.homepage         = 'http://10.0.0.10/SuperApp/iOS'
  s.license          = { :type => 'MIT' }
  s.author           = { 'chavalit.v@siriustech.io' => 'someone@siriustech.io' }
  s.source           = { :git => 'git@10.0.0.10:8022/SuperApp/iOS//APILayer.git', :tag => s.version.to_s }
  s.ios.deployment_target = '11.0'
  s.swift_version    = '5.0'
  s.source_files     = 'APILayer/**/*'
  s.resource_bundles = {
    'APILayer' => ['MockResponse/**/*.{json}']
  }
  
  s.dependency 'RxSwift'
  s.dependency 'RxCocoa'
  s.dependency 'Networking'
  s.dependency 'Core'

end
