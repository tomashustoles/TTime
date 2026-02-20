//
//  DesignSystem.swift
//  TTime
//
//  Created by Tomas Hustoles on 22/1/26.
//

import SwiftUI

// MARK: - Theme Protocol

protocol Theme {
    var colors: ColorTokens { get }
    var typography: TypographyTokens { get }
    var spacing: SpacingTokens { get }
    var radius: RadiusTokens { get }
    var motion: MotionTokens { get }
    var gradients: [GradientPreset] { get }
}

// MARK: - Color Tokens

struct ColorTokens {
    let background: Color
    let foreground: Color
    let accent: Color
    let secondaryForeground: Color
    let focusRing: Color
    
    // Settings-specific colors
    let cardBackground: Color
    let cardBorder: Color
    let sidebarOverlay: Color
    let sidebarBlur: Color
}

// MARK: - Typography Tokens

struct TypographyTokens {
    // Huge size for the clock
    let clockSize: CGFloat
    let clockWeight: Font.Weight  // Separate weight for clock
    
    // Standard size for everything else
    let standardSize: CGFloat
    
    // Semibold weight for everything except clock
    let weight: Font.Weight
}

// MARK: - Spacing Tokens

struct SpacingTokens {
    let tiny: CGFloat
    let small: CGFloat
    let medium: CGFloat
    let large: CGFloat
    let extraLarge: CGFloat
    
    let edgeInset: CGFloat
    let cornerPadding: CGFloat
}

// MARK: - Radius Tokens

struct RadiusTokens {
    let small: CGFloat
    let medium: CGFloat
    let large: CGFloat
    let appIcon: CGFloat
}

// MARK: - Motion Tokens

struct MotionTokens {
    let focusScale: CGFloat
    let focusDuration: Double
    
    let transitionDuration: Double
    let newsFlipDuration: Double
    
    let gradientAnimationDuration: Double
}

// MARK: - Gradient Preset

struct GradientPreset: Identifiable {
    let id: String
    let name: String
    let colors: [Color]
    let startPoint: UnitPoint
    let endPoint: UnitPoint
}

// MARK: - Default Theme

struct DefaultTheme: Theme {
    let colors = ColorTokens(
        background: Color(red: 0.92, green: 0.90, blue: 0.87), // Beige background
        foreground: .black,
        accent: Color(red: 1.0, green: 0.0, blue: 0.0), // Pure red
        secondaryForeground: Color(white: 0.5), // Medium gray for secondary text
        focusRing: Color(red: 1.0, green: 0.0, blue: 0.0), // Red for focus
        cardBackground: Color(white: 0.98, opacity: 0.95),
        cardBorder: Color(white: 0.85),
        sidebarOverlay: Color.black.opacity(0.4),
        sidebarBlur: Color(white: 0.95, opacity: 0.98)
    )
    
    let typography = TypographyTokens(
        clockSize: 220,        // Huge size for clock
        clockWeight: .black,   // Original bold weight for clock
        standardSize: 24,      // Standard size for everything else
        weight: .semibold      // Semibold for everything else
    )
    
    let spacing = SpacingTokens(
        tiny: 8,
        small: 16,
        medium: 24,
        large: 32,
        extraLarge: 48,
        edgeInset: 60,
        cornerPadding: 16
    )
    
    let radius = RadiusTokens(
        small: 8,
        medium: 16,
        large: 24,
        appIcon: 18
    )
    
    let motion = MotionTokens(
        focusScale: 1.08,
        focusDuration: 0.2,
        transitionDuration: 0.35,
        newsFlipDuration: 0.8,
        gradientAnimationDuration: 20.0
    )
    
    let gradients: [GradientPreset] = [
        GradientPreset(
            id: "classic",
            name: "Classic White",
            colors: [
                Color(hex: "FFFFFF"),
                Color(hex: "F8F8F8"),
                Color(hex: "FFFFFF")
            ],
            startPoint: .center,
            endPoint: .bottomTrailing
        ),
        GradientPreset(
            id: "calm",
            name: "Calm",
            colors: [
                Color(red: 0.98, green: 0.98, blue: 1.0),
                Color(red: 0.95, green: 0.96, blue: 0.98),
                Color(red: 0.97, green: 0.97, blue: 0.99)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        GradientPreset(
            id: "warm",
            name: "Warm",
            colors: [
                Color(red: 1.0, green: 0.98, blue: 0.96),
                Color(red: 0.98, green: 0.96, blue: 0.95),
                Color(red: 0.99, green: 0.97, blue: 0.96)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        GradientPreset(
            id: "aurora",
            name: "Aurora Night",
            colors: [
                Color(red: 0.4, green: 0.3, blue: 0.7),
                Color(red: 0.2, green: 0.4, blue: 0.8),
                Color(red: 0.5, green: 0.2, blue: 0.6)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        GradientPreset(
            id: "sunset",
            name: "Sunset Fade",
            colors: [
                Color(red: 1.0, green: 0.6, blue: 0.4),
                Color(red: 0.98, green: 0.5, blue: 0.6),
                Color(red: 0.95, green: 0.7, blue: 0.5)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        GradientPreset(
            id: "neon",
            name: "Neon Pulse",
            colors: [
                Color(red: 0.7, green: 0.3, blue: 0.9),
                Color(red: 0.3, green: 0.7, blue: 0.9),
                Color(red: 0.9, green: 0.4, blue: 0.7)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        GradientPreset(
            id: "charcoal",
            name: "Charcoal",
            colors: [
                Color(red: 0.15, green: 0.15, blue: 0.15),
                Color(red: 0.2, green: 0.2, blue: 0.22),
                Color(red: 0.18, green: 0.18, blue: 0.2)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        GradientPreset(
            id: "deepblue",
            name: "Deep Blue",
            colors: [
                Color(red: 0.1, green: 0.15, blue: 0.3),
                Color(red: 0.15, green: 0.2, blue: 0.35),
                Color(red: 0.12, green: 0.18, blue: 0.32)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        GradientPreset(
            id: "teal",
            name: "Muted Teal",
            colors: [
                Color(red: 0.7, green: 0.85, blue: 0.82),
                Color(red: 0.75, green: 0.88, blue: 0.85),
                Color(red: 0.72, green: 0.86, blue: 0.83)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    ]
}

// MARK: - Theme Environment

struct ThemeKey: EnvironmentKey {
    static let defaultValue: Theme = DefaultTheme()
}

extension EnvironmentValues {
    var theme: Theme {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}

extension View {
    func theme(_ theme: Theme) -> some View {
        environment(\.theme, theme)
    }
}
// MARK: - Color Hex Extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

