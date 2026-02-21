//
//  OrganicGradientBackground.swift
//  TTime
//

import SwiftUI

struct OrganicGradientBackground: View {
    let temperature: Double?
    /// Override the fractional hour used for the time-of-day palette.
    /// nil = follow the real clock; 12.0 = force midday (light); 2.0 = force night (dark).
    var forcedHour: Double? = nil

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0)) { timeline in
            let now = timeline.date
            let calendar = Calendar.current
            let hour = Double(calendar.component(.hour, from: now))
            let minute = Double(calendar.component(.minute, from: now))
            let month = calendar.component(.month, from: now)
            let fractionalHour = forcedHour ?? (hour + minute / 60.0)
            let time = now.timeIntervalSinceReferenceDate
            
            let baseColors = Self.timeOfDayColors(fractionalHour: fractionalHour)
            let tempShifted = Self.applyTemperatureShift(colors: baseColors, temperature: temperature)
            let seasonTinted = Self.applySeasonTint(colors: tempShifted, month: month)
            
            MeshGradient(
                width: 3,
                height: 3,
                points: Self.animatedPoints(time: time),
                colors: seasonTinted
            )
            .ignoresSafeArea()
        }
    }
    
    // MARK: - Animated Mesh Points
    
    static func animatedPoints(time: Double) -> [SIMD2<Float>] {
        [
            .init(x: 0, y: 0),
            .init(x: 0.5 + Float(sin(time / 25)) * 0.06, y: Float(sin(time / 30)) * 0.04),
            .init(x: 1, y: 0),
            
            .init(x: Float(cos(time / 28)) * 0.05, y: 0.5 + Float(cos(time / 22)) * 0.06),
            .init(x: 0.5 + Float(sin(time / 20)) * 0.04, y: 0.5 + Float(cos(time / 24)) * 0.04),
            .init(x: 1 + Float(sin(time / 26)) * 0.04, y: 0.5 + Float(sin(time / 18)) * 0.05),
            
            .init(x: 0, y: 1),
            .init(x: 0.5 + Float(cos(time / 23)) * 0.05, y: 1),
            .init(x: 1, y: 1)
        ]
    }
    
    // MARK: - Time of Day Palettes
    
    static func timeOfDayColors(fractionalHour: Double) -> [Color] {
        let palettes: [(hour: Double, colors: [Color])] = [
            (0, nightColors),
            (5, nightColors),
            (6, dawnColors),
            (7.5, morningColors),
            (11, middayColors),
            (14, afternoonColors),
            (17, sunsetColors),
            (20, twilightColors),
            (22, nightColors),
            (24, nightColors)
        ]
        
        var lower = palettes[0]
        var upper = palettes[1]
        for i in 0..<(palettes.count - 1) {
            if fractionalHour >= palettes[i].hour && fractionalHour < palettes[i + 1].hour {
                lower = palettes[i]
                upper = palettes[i + 1]
                break
            }
        }
        
        let range = upper.hour - lower.hour
        let t = range > 0 ? (fractionalHour - lower.hour) / range : 0
        let smoothT = smoothstep(t)
        
        return zip(lower.colors, upper.colors).map { lerpColor($0, $1, t: smoothT) }
    }
    
    // MARK: - Base Palettes (9 colors each for 3x3 mesh)
    // Calm, desaturated, beautiful — like fine watercolour washes

    private static let dawnColors: [Color] = [
        Color(red: 0.76, green: 0.66, blue: 0.74), Color(red: 0.88, green: 0.72, blue: 0.68), Color(red: 0.94, green: 0.80, blue: 0.66),
        Color(red: 0.78, green: 0.68, blue: 0.74), Color(red: 0.90, green: 0.74, blue: 0.68), Color(red: 0.95, green: 0.83, blue: 0.68),
        Color(red: 0.82, green: 0.72, blue: 0.74), Color(red: 0.92, green: 0.78, blue: 0.70), Color(red: 0.96, green: 0.88, blue: 0.74)
    ]

    private static let morningColors: [Color] = [
        Color(red: 0.76, green: 0.87, blue: 0.95), Color(red: 0.82, green: 0.90, blue: 0.96), Color(red: 0.89, green: 0.93, blue: 0.96),
        Color(red: 0.78, green: 0.88, blue: 0.94), Color(red: 0.84, green: 0.91, blue: 0.95), Color(red: 0.91, green: 0.94, blue: 0.95),
        Color(red: 0.83, green: 0.91, blue: 0.94), Color(red: 0.89, green: 0.93, blue: 0.94), Color(red: 0.95, green: 0.95, blue: 0.92)
    ]

    private static let middayColors: [Color] = [
        Color(red: 0.74, green: 0.87, blue: 0.96), Color(red: 0.80, green: 0.90, blue: 0.97), Color(red: 0.87, green: 0.93, blue: 0.97),
        Color(red: 0.77, green: 0.89, blue: 0.96), Color(red: 0.84, green: 0.92, blue: 0.97), Color(red: 0.91, green: 0.95, blue: 0.97),
        Color(red: 0.82, green: 0.91, blue: 0.96), Color(red: 0.89, green: 0.94, blue: 0.96), Color(red: 0.95, green: 0.96, blue: 0.94)
    ]

    private static let afternoonColors: [Color] = [
        Color(red: 0.84, green: 0.88, blue: 0.91), Color(red: 0.92, green: 0.89, blue: 0.82), Color(red: 0.96, green: 0.90, blue: 0.76),
        Color(red: 0.86, green: 0.87, blue: 0.87), Color(red: 0.93, green: 0.89, blue: 0.79), Color(red: 0.97, green: 0.91, blue: 0.72),
        Color(red: 0.89, green: 0.88, blue: 0.84), Color(red: 0.95, green: 0.90, blue: 0.76), Color(red: 0.97, green: 0.87, blue: 0.68)
    ]

    private static let sunsetColors: [Color] = [
        Color(red: 0.66, green: 0.50, blue: 0.58), Color(red: 0.84, green: 0.58, blue: 0.52), Color(red: 0.94, green: 0.68, blue: 0.52),
        Color(red: 0.70, green: 0.50, blue: 0.56), Color(red: 0.88, green: 0.60, blue: 0.52), Color(red: 0.95, green: 0.72, blue: 0.52),
        Color(red: 0.74, green: 0.54, blue: 0.56), Color(red: 0.90, green: 0.66, blue: 0.52), Color(red: 0.96, green: 0.80, blue: 0.56)
    ]

    private static let twilightColors: [Color] = [
        Color(red: 0.22, green: 0.20, blue: 0.38), Color(red: 0.28, green: 0.22, blue: 0.46), Color(red: 0.34, green: 0.24, blue: 0.48),
        Color(red: 0.24, green: 0.22, blue: 0.42), Color(red: 0.30, green: 0.24, blue: 0.48), Color(red: 0.36, green: 0.26, blue: 0.48),
        Color(red: 0.26, green: 0.24, blue: 0.44), Color(red: 0.32, green: 0.26, blue: 0.46), Color(red: 0.36, green: 0.28, blue: 0.42)
    ]

    private static let nightColors: [Color] = [
        Color(red: 0.08, green: 0.09, blue: 0.20), Color(red: 0.10, green: 0.10, blue: 0.24), Color(red: 0.09, green: 0.09, blue: 0.22),
        Color(red: 0.09, green: 0.09, blue: 0.22), Color(red: 0.11, green: 0.11, blue: 0.26), Color(red: 0.10, green: 0.10, blue: 0.24),
        Color(red: 0.08, green: 0.08, blue: 0.20), Color(red: 0.10, green: 0.09, blue: 0.24), Color(red: 0.09, green: 0.09, blue: 0.22)
    ]
    
    // MARK: - Temperature Shift
    
    static func applyTemperatureShift(colors: [Color], temperature: Double?) -> [Color] {
        guard let temp = temperature else { return colors }
        
        let shift: (r: Double, g: Double, b: Double)
        switch temp {
        case ..<5:
            let intensity = min(1.0, (5 - temp) / 15.0)
            shift = (r: -0.08 * intensity, g: 0.02 * intensity, b: 0.12 * intensity)
        case 5..<15:
            let intensity = (15 - temp) / 10.0
            shift = (r: -0.03 * intensity, g: 0.01 * intensity, b: 0.05 * intensity)
        case 15..<25:
            shift = (r: 0, g: 0, b: 0)
        case 25..<35:
            let intensity = (temp - 25) / 10.0
            shift = (r: 0.08 * intensity, g: 0.02 * intensity, b: -0.05 * intensity)
        default:
            let intensity = min(1.0, (temp - 35) / 10.0)
            shift = (r: 0.12 * intensity, g: -0.02 * intensity, b: -0.08 * intensity)
        }
        
        return colors.map { color in
            let comps = color.rgbComponents
            return Color(
                red: clamp01(comps.r + shift.r),
                green: clamp01(comps.g + shift.g),
                blue: clamp01(comps.b + shift.b)
            )
        }
    }
    
    // MARK: - Season Tint
    
    static func applySeasonTint(colors: [Color], month: Int) -> [Color] {
        let tint: (r: Double, g: Double, b: Double)
        switch month {
        case 12, 1, 2:
            tint = (r: -0.03, g: -0.01, b: 0.04)
        case 3, 4, 5:
            tint = (r: -0.02, g: 0.04, b: -0.01)
        case 6, 7, 8:
            tint = (r: 0.03, g: 0.02, b: -0.02)
        case 9, 10, 11:
            tint = (r: 0.04, g: 0.02, b: -0.03)
        default:
            tint = (r: 0, g: 0, b: 0)
        }
        
        return colors.map { color in
            let comps = color.rgbComponents
            return Color(
                red: clamp01(comps.r + tint.r),
                green: clamp01(comps.g + tint.g),
                blue: clamp01(comps.b + tint.b)
            )
        }
    }
    
    // MARK: - Helpers
    
    private static func smoothstep(_ t: Double) -> Double {
        let clamped = max(0, min(1, t))
        return clamped * clamped * (3 - 2 * clamped)
    }
    
    private static func lerpColor(_ a: Color, _ b: Color, t: Double) -> Color {
        let ca = a.rgbComponents
        let cb = b.rgbComponents
        return Color(
            red: ca.r + (cb.r - ca.r) * t,
            green: ca.g + (cb.g - ca.g) * t,
            blue: ca.b + (cb.b - ca.b) * t
        )
    }
    
    private static func clamp01(_ value: Double) -> Double {
        max(0, min(1, value))
    }
}

// MARK: - Color RGB Extraction

extension Color {
    var rgbComponents: (r: Double, g: Double, b: Double) {
        #if canImport(UIKit)
        let uiColor = UIColor(self)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        return (Double(r), Double(g), Double(b))
        #else
        let nsColor = NSColor(self)
        let converted = nsColor.usingColorSpace(.sRGB) ?? nsColor
        return (Double(converted.redComponent), Double(converted.greenComponent), Double(converted.blueComponent))
        #endif
    }
}
