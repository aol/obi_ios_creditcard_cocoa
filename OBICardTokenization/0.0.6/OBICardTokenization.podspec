#  Be sure to run `pod spec lint OBICardTokenization.podspec' to ensure this is a

Pod::Spec.new do |s|

  s.ios.deployment_target  = '8.0'

  s.name         = "OBICardTokenization"
  s.version      = "0.0.6"
  s.summary      = "Card tokenization framework"

  s.homepage     = "https://github.com/aol"

  s.license     = "MIT"

  s.author    = "AOL"

  s.platform     = :ios, "8.0"
  s.source       = { :git => "ssh://git@github.com:aol/obi_ios_creditcard_cocoa.git", :tag => s.version }

  s.source_files  = "Source/*.*"
  s.requires_arc = true

end
