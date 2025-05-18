//
//  File.swift
//  
//
//  Created by nenhall on 5/15/25.
//

import Foundation
import SwiftUI

public struct EnhancedButtonStyle: ButtonStyle {
    // 基础样式参数
    let hoverColor: Color
    let borderColor: Color
    let borderWidth: CGFloat
    let cornerRadius: CGFloat
    
    // 新增选中状态参数
    let selectedColor: Color
    let isSelected: Bool
    
    // 交互状态跟踪
    @State private var isHovered = false
    
    public init(hoverColor: Color, borderColor: Color, borderWidth: CGFloat, cornerRadius: CGFloat, selectedColor: Color, isSelected: Bool) {
        self.hoverColor = hoverColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.cornerRadius = cornerRadius
        self.selectedColor = selectedColor
        self.isSelected = isSelected
    }
    
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(backgroundShape(isPressed: configuration.isPressed))
            .overlay(borderOverlay)
            .contentShape(RoundedRectangle(cornerRadius: cornerRadius))
            ._onHover { hovering in
                isHovered = hovering
            }
    }
    
    private func backgroundShape(isPressed: Bool) -> some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(calculateFillColor(isPressed: isPressed))
    }
    
    private var borderOverlay: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .stroke(calculateBorderColor(), lineWidth: borderWidth)
    }
    
    // 颜色计算逻辑
    private func calculateFillColor(isPressed: Bool) -> Color {
        guard !isSelected else { return selectedColor }
        
        return isPressed ? hoverColor.opacity(0.8) :
               isHovered ? hoverColor : Color.clear
    }
    
    private func calculateBorderColor() -> Color {
        isSelected ? selectedColor : borderColor
    }
}

public extension ButtonStyle where Self == EnhancedButtonStyle {
    static func enhanced(
        hoverColor: Color = .blue.opacity(0.2),
        borderColor: Color = .blue,
        borderWidth: CGFloat = 1,
        cornerRadius: CGFloat = 8,
        selectedColor: Color = .blue,
        isSelected: Bool = false
    ) -> Self {
        EnhancedButtonStyle(
            hoverColor: hoverColor,
            borderColor: borderColor,
            borderWidth: borderWidth,
            cornerRadius: cornerRadius,
            selectedColor: selectedColor,
            isSelected: isSelected
        )
    }
}
