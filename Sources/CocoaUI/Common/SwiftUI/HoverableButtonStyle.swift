//
//  File.swift
//  
//
//  Created by nenhall on 5/15/25.
//

import SwiftUI

public struct HoverableButtonStyle: ButtonStyle {
    let hoverColor: Color
    let borderColor: Color
    let borderWidth: CGFloat
    let cornerRadius: CGFloat
    
    @State private var isHovered = false
    
    public init(hoverColor: Color, borderColor: Color, borderWidth: CGFloat, cornerRadius: CGFloat) {
        self.hoverColor = hoverColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.cornerRadius = cornerRadius
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(hoverBackground(isPressed: configuration.isPressed))
            .overlay(borderOverlay)
            .contentShape(RoundedRectangle(cornerRadius: cornerRadius))
            ._onHover { hovering in
                withAnimation(.easeInOut(duration: 0.15)) {
                    isHovered = hovering
                }
            }
    }
    
    private func hoverBackground(isPressed: Bool) -> some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(fillColor(isPressed: isPressed))
    }
    
    private var borderOverlay: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .stroke(borderColor, lineWidth: borderWidth)
    }
    
    private func fillColor(isPressed: Bool) -> Color {
        if isPressed {
            return hoverColor.opacity(0.5)
        }
        return isHovered ? hoverColor : Color.clear
    }
}

public extension ButtonStyle where Self == HoverableButtonStyle {
    static func hoverable(
        hoverColor: Color = .blue.opacity(0.2),
        borderColor: Color = .blue,
        borderWidth: CGFloat = 1,
        cornerRadius: CGFloat = 8
    ) -> Self {
        HoverableButtonStyle(
            hoverColor: hoverColor,
            borderColor: borderColor,
            borderWidth: borderWidth,
            cornerRadius: cornerRadius
        )
    }
}

extension View {
    @ViewBuilder
    func _onHover(_ hovered: @escaping (_ hovering: Bool) -> ()) -> some View {
        if #available(iOS 14, macOS 11.0, *) {
            self.onHover { hovering in
                withAnimation(.interactiveSpring()) {
                    hovered(hovering)
                }
            }
        } else {
            self
        }
    }
}
