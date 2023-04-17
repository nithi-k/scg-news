Pod::Spec.new do |s|
  s.name             = 'NewsArticle'
  s.version          = '0.1.0'
  s.summary          = 'A short description of NewsArticle.'
  s.description      = 'NewsArticle module'
  s.homepage         = 'http://somehost/SuperApp/iOS'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = 'kulasiriswatdi@gmail.com'
  s.source           = { :git => 'git@somehost/NewsArticle.git',
 :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.swift_version    = '5.0'
  s.source_files     = 'NewsArticle/**/*'
  s.resource_bundles = {
    'NewsArticle' => ['Assets/**/*.{png,xcassets,json,txt,storyboard,xib,xcdatamodeld,strings}']
  }
  s.public_header_files = ["NewsArticle/Headers/**/*{.h,.hpp}"]

#   s.test_spec 'Tests' do |test_spec|
#    test_spec.source_files = 'UnitTest/**/*'
#   end
   
  s.dependency 'Base'

end
