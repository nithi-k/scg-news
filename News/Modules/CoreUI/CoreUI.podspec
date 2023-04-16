Pod::Spec.new do |s|
  s.name             = 'CoreUI'
  s.version          = '0.1.0'
  s.summary          = 'A short description of CoreUI.'
  s.description      = 'CoreUI module'
  s.homepage         = 'http://somehost/iOS'
  s.license          = { :type => 'MIT' }
  s.author           = 'kulasiriswatdi@gmail.com'
  s.source           = { :git => 'git@somehost/CoreUI.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.swift_version    = '5.0'
  s.source_files     = 'CoreUI/**/*'
  s.resource_bundles = {
    'CoreUI' => ['Resources/**/*.{png,xcassets,json,txt,otf,storyboard,xib,xcdatamodeld,strings}']
  }
  
  s.dependency 'Core'
  s.dependency 'SnapKit'
  s.dependency 'Kingfisher'

end
