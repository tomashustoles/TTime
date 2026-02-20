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
    /// 9 colors for a 3x3 MeshGradient, ordered row-major: top-left to bottom-right
    let meshColors: [Color]
    
    static let meshPoints: [SIMD2<Float>] = [
        .init(x: 0, y: 0),   .init(x: 0.5, y: 0),   .init(x: 1, y: 0),
        .init(x: 0, y: 0.5), .init(x: 0.5, y: 0.5), .init(x: 1, y: 0.5),
        .init(x: 0, y: 1),   .init(x: 0.5, y: 1),   .init(x: 1, y: 1)
    ]
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
            id: "ocean",
            name: "Ocean Breeze",
            meshColors: [
                Color(red: 0.05, green: 0.12, blue: 0.30), Color(red: 0.10, green: 0.35, blue: 0.65), Color(red: 0.15, green: 0.50, blue: 0.72),
                Color(red: 0.08, green: 0.28, blue: 0.55), Color(red: 0.20, green: 0.55, blue: 0.75), Color(red: 0.30, green: 0.70, blue: 0.78),
                Color(red: 0.12, green: 0.40, blue: 0.62), Color(red: 0.25, green: 0.62, blue: 0.72), Color(red: 0.45, green: 0.80, blue: 0.85)
            ]
        ),
        GradientPreset(
            id: "golden",
            name: "Golden Hour",
            meshColors: [
                Color(red: 0.98, green: 0.88, blue: 0.65), Color(red: 0.95, green: 0.78, blue: 0.45), Color(red: 0.98, green: 0.92, blue: 0.78),
                Color(red: 0.96, green: 0.72, blue: 0.40), Color(red: 0.98, green: 0.82, blue: 0.55), Color(red: 0.95, green: 0.65, blue: 0.42),
                Color(red: 0.99, green: 0.95, blue: 0.85), Color(red: 0.97, green: 0.75, blue: 0.50), Color(red: 0.94, green: 0.60, blue: 0.35)
            ]
        ),
        GradientPreset(
            id: "aurora",
            name: "Aurora Borealis",
            meshColors: [
                Color(red: 0.10, green: 0.05, blue: 0.25), Color(red: 0.15, green: 0.45, blue: 0.30), Color(red: 0.08, green: 0.12, blue: 0.35),
                Color(red: 0.30, green: 0.15, blue: 0.55), Color(red: 0.10, green: 0.65, blue: 0.50), Color(red: 0.20, green: 0.35, blue: 0.60),
                Color(red: 0.55, green: 0.15, blue: 0.50), Color(red: 0.15, green: 0.50, blue: 0.45), Color(red: 0.08, green: 0.10, blue: 0.30)
            ]
        ),
        GradientPreset(
            id: "rose",
            name: "Rose Quartz",
            meshColors: [
                Color(red: 0.98, green: 0.88, blue: 0.90), Color(red: 0.95, green: 0.78, blue: 0.82), Color(red: 0.99, green: 0.92, blue: 0.90),
                Color(red: 0.92, green: 0.72, blue: 0.78), Color(red: 0.96, green: 0.82, blue: 0.85), Color(red: 0.98, green: 0.90, blue: 0.88),
                Color(red: 0.99, green: 0.95, blue: 0.93), Color(red: 0.94, green: 0.80, blue: 0.82), Color(red: 0.90, green: 0.70, blue: 0.75)
            ]
        ),
        GradientPreset(
            id: "cosmos",
            name: "Midnight Cosmos",
            meshColors: [
                Color(red: 0.06, green: 0.04, blue: 0.18), Color(red: 0.12, green: 0.06, blue: 0.28), Color(red: 0.08, green: 0.08, blue: 0.22),
                Color(red: 0.15, green: 0.05, blue: 0.30), Color(red: 0.10, green: 0.10, blue: 0.25), Color(red: 0.05, green: 0.12, blue: 0.22),
                Color(red: 0.08, green: 0.06, blue: 0.20), Color(red: 0.18, green: 0.10, blue: 0.30), Color(red: 0.06, green: 0.10, blue: 0.20)
            ]
        ),
        GradientPreset(
            id: "tropical",
            name: "Tropical Sunset",
            meshColors: [
                Color(red: 0.98, green: 0.55, blue: 0.35), Color(red: 0.95, green: 0.40, blue: 0.50), Color(red: 0.98, green: 0.65, blue: 0.40),
                Color(red: 0.92, green: 0.30, blue: 0.45), Color(red: 0.96, green: 0.50, blue: 0.42), Color(red: 0.98, green: 0.75, blue: 0.30),
                Color(red: 0.88, green: 0.25, blue: 0.50), Color(red: 0.95, green: 0.45, blue: 0.38), Color(red: 0.98, green: 0.82, blue: 0.35)
            ]
        ),
        GradientPreset(
            id: "forest",
            name: "Forest Canopy",
            meshColors: [
                Color(red: 0.05, green: 0.22, blue: 0.12), Color(red: 0.12, green: 0.35, blue: 0.18), Color(red: 0.08, green: 0.28, blue: 0.15),
                Color(red: 0.15, green: 0.40, blue: 0.22), Color(red: 0.25, green: 0.50, blue: 0.30), Color(red: 0.18, green: 0.42, blue: 0.28),
                Color(red: 0.20, green: 0.38, blue: 0.20), Color(red: 0.30, green: 0.52, blue: 0.32), Color(red: 0.22, green: 0.45, blue: 0.25)
            ]
        ),
        GradientPreset(
            id: "lavender",
            name: "Lavender Dream",
            meshColors: [
                Color(red: 0.82, green: 0.78, blue: 0.95), Color(red: 0.72, green: 0.70, blue: 0.92), Color(red: 0.85, green: 0.82, blue: 0.96),
                Color(red: 0.75, green: 0.72, blue: 0.90), Color(red: 0.80, green: 0.76, blue: 0.94), Color(red: 0.70, green: 0.75, blue: 0.92),
                Color(red: 0.88, green: 0.85, blue: 0.97), Color(red: 0.78, green: 0.74, blue: 0.92), Color(red: 0.72, green: 0.72, blue: 0.88)
            ]
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

