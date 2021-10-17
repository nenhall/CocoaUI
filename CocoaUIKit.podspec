#
#  Be sure to run `pod spec lint CocoaUI.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = "CocoaUIKit"
  spec.version      = "0.0.1"
  spec.summary      = "macOS UI控件定制，支持 macOS10.14"
  spec.homepage     = "https://github.com/nenhall/CocoaUIKit"
  spec.license      = "MIT"
  spec.author       = { "nenhall" => "nenhall@126.com" }
  spec.platform     = :osx, "10.14"
  spec.swift_versions = ['5.0', '5.1', '5.2', '5.3', '5.4', '5.5']
  spec.osx.deployment_target = "10.14"
  spec.source       = { :git => "https://github.com/nenhall/CocoaUIKit.git", :tag => "#{spec.version}" }
  spec.source_files  = "Sources/**/*.{swift}"
  
  # spec.exclude_files = "Classes/Exclude"
  # spec.public_header_files = "Classes/**/*.h"
  # spec.framework  = "SomeFramework"
  # spec.frameworks = "SomeFramework", "AnotherFramework"
  # spec.library   = "iconv"
  # spec.libraries = "iconv", "xml2"

end
