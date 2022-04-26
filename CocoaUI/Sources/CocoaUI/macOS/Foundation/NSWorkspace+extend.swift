//
//  NSWorkspace+Extension.swift
//  CocoaUIKit
//
//  Created by nenhall on 2022/1/19.
//

import Foundation

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

public enum PaneAnchor: String {

    case camera = "Privacy_Camera"
    case microphone = "Privacy_Microphone"
    case location = "Privacy_LocationServices"
    case accessibility = "Privacy_Accessibility"
    case reminders = "Privacy_Reminders"
    case calendars = "Privacy_Calendars"
    case firewall = "Firewall"
    case assistive = "Privacy_Assistive"
    case contacts = "Privacy_Contacts"
    case general = "General"
    case advanced = "Advanced"
    case FDE = "FDE"
    case privacy = "Privacy"
    case allFiles = "Privacy_AllFiles"
    case systemServices = "Privacy_SystemServices"
    case screenRecoding = "Privacy_ScreenCapture"
    case photos = "Privacy_Photos"

}

public enum SysPreferences  {

    case securityPane(PaneAnchor)
    case addPrinter

}

public extension SysPreferences {

    static var mainPane = "x-apple.systempreferences:"
    var rawValue: String {
        switch self {
        case .securityPane:
            return "com.apple.preference.security"
        case .addPrinter:
            return "/System/Library/CoreServices/AddPrinter.app"
        }
    }

}

public extension NSWorkspace {
    
    func openSysPreferencesPanel(_ panel: SysPreferences) {
        var url: URL?
        var needOpenSystempreferences = true
        switch panel {
        case .securityPane(let anchor):
            url = URL(string: SysPreferences.mainPane + panel.rawValue + "?" + anchor.rawValue)
            switch anchor {
            case .photos, .screenRecoding:
                url = URL(string: SysPreferences.mainPane + panel.rawValue + "?" + PaneAnchor.camera.rawValue)
            default: break
            }
        case .addPrinter:
            needOpenSystempreferences = false
            url = URL(fileURLWithPath: "/System/Library/CoreServices/AddPrinter.app")
        }

        guard let url = url else { return }
        /// 先启动，让其成为活跃窗口，否则不会弹到最前面
        if needOpenSystempreferences,
           applicationRunning(bundleIdentifier: "com.apple.systempreferences") == false {
            launchApplication(withBundleIdentifier: "com.apple.systempreferences",
                              options: [.inhibitingBackgroundOnly],
                              additionalEventParamDescriptor: nil,
                              launchIdentifier: nil)

        }
        open(url)
    }
    
    func applicationRunning(bundleIdentifier: String) -> Bool {
      let count = NSRunningApplication.runningApplications(withBundleIdentifier: bundleIdentifier).count
        if count > 0 {
            return true
        }
        return false
    }
    
}

#endif
