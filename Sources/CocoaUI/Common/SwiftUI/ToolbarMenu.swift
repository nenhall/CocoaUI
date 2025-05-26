//
//  SwiftUIView.swift
//  
//
//  Created by nenhall on 5/22/25.
//

import SwiftUI

@available(macOS 11.0, iOS 14.0, *)
public struct ToolbarMenu<MenuContent: View, LabelContent: View>: ToolbarContent {
    public enum Placement {
        case leading
        case trailing
        case principal
        case status
        case keyboard
        case automatic
    }
    
    private let placement: ToolbarItemPlacement
    private let menuContent: () -> MenuContent
    private let labelContent: () -> LabelContent
    private let isMenu: Bool
    
    public init(
        placement: ToolbarMenu.Placement = .trailing,
        @ViewBuilder menuContent: @escaping () -> MenuContent,
        @ViewBuilder labelContent: @escaping () -> LabelContent,
        isMenu: Bool = false
    ) {
        self.placement = placement.toPlatformPlacement()
        self.menuContent = menuContent
        self.labelContent = labelContent
        self.isMenu = isMenu
    }
    
    public var body: some ToolbarContent {
        ToolbarItem(placement: placement) {
            if isMenu {
                Menu {
                    menuContent()
                } label: {
                    labelContent()
                }
                .menuStyle(.automatic)
            } else {
                menuContent()
            }
        }
    }
}


extension ToolbarMenu.Placement {
    @available(iOS 14.0, macOS 11.0, *)
    func toPlatformPlacement() -> ToolbarItemPlacement {
#if os(iOS)
            switch self {
            case .leading: return .navigationBarLeading
            case .trailing: return .navigationBarTrailing
            case .principal: return .principal
            case .status: return .status
            case .keyboard:
                if #available(iOS 15.0, *) {
                    return .keyboard
                } else {
                    return .automatic
                }
            case .automatic: return .automatic
            }
#else
            switch self {
            case .leading: return .navigation
            case .trailing: return .navigation
            case .principal: return .principal
            case .status: return .status
            case .keyboard:
                if #available(macOS 12.0, *) {
                    return .keyboard
                } else {
                    return .automatic
                }
            case .automatic: return .automatic
            }
#endif
    }
}

//public extension ToolbarMenu where LabelContent == Image {
//    static func standardMenu(
//        placement: ToolbarMenu.Placement = .trailing,
//        iconName: String = "ellipsis",
//        @ViewBuilder content: @escaping () -> MenuContent
//    ) -> Self {
//        ToolbarMenu(
//            placement: placement,
//            menuContent: content,
//            labelContent: { Image(systemName: iconName) }
//        )
//    }
//}
