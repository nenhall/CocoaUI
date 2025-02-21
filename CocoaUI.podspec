Pod::Spec.new do |s|
    s.name             = 'CocoaUI'
    s.version          = '0.3.0'
    s.summary          = 'macOS、iOS UI控件'
    s.description      = <<-DESC
                         apple 多平台通用的UI控件，支持 AppKit、UIKit、swiftUI
                         DESC
    s.homepage         = 'https://github.com/nenhall/CocoaUI.git'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'nenhall' => 'nenhall@126.com' }
    s.source           = { :git => 'https://github.com/nenhall/CocoaUI.git', :tag => s.version.to_s }
    s.swift_version    = '5.0'
    s.ios.deployment_target = '12.0'
    s.osx.deployment_target = '10.15'
    s.platforms = {
            :ios => '12.0',
            :osx => '10.15'
    }

    s.subspec 'common' do |com|
        com.source_files = 'Sources/CocoaUI/Common/**/*.{h,m,swift}'
        com.frameworks   = 'SwiftUI'
    end

    s.subspec 'iOS' do |ios|
        ios.platform     = :ios, '12.0'
        ios.source_files = 'Sources/CocoaUI/iOS/**/*.{h,m,swift}'
        ios.frameworks   = 'UIKit'
        ios.dependency 'CocoaUI/common'
    end

    s.subspec 'macOS' do |macos|
        macos.platform     = :osx, '10.15'
        macos.source_files = 'Sources/CocoaUI/macOS/**/*.{h,m,swift}'
        macos.frameworks   = 'AppKit'
        macos.dependency 'CocoaUI/common'
    end

    s.default_subspec = 'common', 'iOS', 'macOS'
end
