#  Be sure to run `pod spec lint OBICardTokenization.podspec' to ensure this is a

Pod::Spec.new do |s|

  s.name         = "OBICardTokenization"
  s.version      = "0.0.4"
  s.summary      = "Card tokenization framework"

  s.homepage     = "https://github.com/aol"

  s.license     = "MIT"

  s.author    = "AOL"

  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/aol/obi_ios_creditcard_cocoa.git", :tag => s.version }

  s.source_files  = "Source/*.*"
  s.requires_arc = true

end
