//
//  FocusModifiers.swift
//  TTime
//
//  Created by Tomas Hustoles on 22/1/26.
//

import SwiftUI

// MARK: - Focusable Card Style

struct FocusableCardModifier: ViewModifier {
    @Environment(\.theme) private var theme
    @Environment(\.isFocused) private var isFocused
    
    func body(content: Content) -> some View {
        content
            .padding(theme.spacing.medium)
            .background {
                RoundedRectangle(cornerRadius: theme.radius.medium)
                    .fill(theme.colors.background.opacity(isFocused ? 0.3 : 0.0))
            }
            .scaleEffect(isFocused ? theme.motion.focusScale : 1.0)
            .animation(.easeOut(duration: theme.motion.focusDuration), value: isFocused)
    }
}

extension View {
    func focusableCard() -> some View {
        modifier(FocusableCardModifier())
    }
}

// MARK: - Focus Text Style

struct FocusTextModifier: ViewModifier {
    @Environment(\.theme) private var theme
    @Environment(\.isFocused) private var isFocused
    
    let baseColor: Color?
    
    init(baseColor: Color? = nil) {
        self.baseColor = baseColor
    }
    
    func body(content: Content) -> some View {
        content
            .foregroundStyle(isFocused ? theme.colors.accent : (baseColor ?? theme.colors.foreground))
            .animation(.easeOut(duration: theme.motion.focusDuration), value: isFocused)
    }
}

extension View {
    func focusText(baseColor: Color? = nil) -> some View {
        modifier(FocusTextModifier(baseColor: baseColor))
    }
}
