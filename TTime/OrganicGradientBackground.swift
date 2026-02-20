//
//  OrganicGradientBackground.swift
//  TTime
//

import SwiftUI

struct OrganicGradientBackground: View {
    let temperature: Double?
    
    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0)) { timeline in
            let now = timeline.date
            let calendar = Calendar.current
            let hour = Double(calendar.component(.hour, from: now))
            let minute = Double(calendar.component(.minute, from: now))
            let month = calendar.component(.month, from: now)
            let fractionalHour = hour + minute / 60.0
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
    
    private static let dawnColors: [Color] = [
        Color(red: 0.45, green: 0.35, blue: 0.55), Color(red: 0.70, green: 0.50, blue: 0.55), Color(red: 0.90, green: 0.65, blue: 0.50),
        Color(red: 0.55, green: 0.40, blue: 0.58), Color(red: 0.85, green: 0.60, blue: 0.55), Color(red: 0.95, green: 0.75, blue: 0.55),
        Color(red: 0.65, green: 0.50, blue: 0.60), Color(red: 0.90, green: 0.70, blue: 0.58), Color(red: 0.98, green: 0.85, blue: 0.65)
    ]
    
    private static let morningColors: [Color] = [
        Color(red: 0.55, green: 0.75, blue: 0.92), Color(red: 0.65, green: 0.82, blue: 0.95), Color(red: 0.78, green: 0.88, blue: 0.96),
        Color(red: 0.60, green: 0.78, blue: 0.90), Color(red: 0.75, green: 0.88, blue: 0.95), Color(red: 0.88, green: 0.92, blue: 0.95),
        Color(red: 0.70, green: 0.85, blue: 0.92), Color(red: 0.85, green: 0.90, blue: 0.94), Color(red: 0.95, green: 0.95, blue: 0.88)
    ]
    
    private static let middayColors: [Color] = [
        Color(red: 0.52, green: 0.78, blue: 0.98), Color(red: 0.65, green: 0.85, blue: 0.98), Color(red: 0.75, green: 0.90, blue: 0.99),
        Color(red: 0.60, green: 0.82, blue: 0.97), Color(red: 0.80, green: 0.92, blue: 0.99), Color(red: 0.90, green: 0.95, blue: 0.98),
        Color(red: 0.72, green: 0.88, blue: 0.98), Color(red: 0.88, green: 0.94, blue: 0.98), Color(red: 0.96, green: 0.97, blue: 0.95)
    ]
    
    private static let afternoonColors: [Color] = [
        Color(red: 0.70, green: 0.82, blue: 0.92), Color(red: 0.85, green: 0.82, blue: 0.78), Color(red: 0.95, green: 0.85, blue: 0.68),
        Color(red: 0.75, green: 0.80, blue: 0.85), Color(red: 0.92, green: 0.85, blue: 0.72), Color(red: 0.98, green: 0.88, blue: 0.65),
        Color(red: 0.82, green: 0.82, blue: 0.78), Color(red: 0.95, green: 0.88, blue: 0.70), Color(red: 0.98, green: 0.82, blue: 0.58)
    ]
    
    private static let sunsetColors: [Color] = [
        Color(red: 0.45, green: 0.30, blue: 0.55), Color(red: 0.75, green: 0.35, blue: 0.45), Color(red: 0.95, green: 0.50, blue: 0.30),
        Color(red: 0.55, green: 0.28, blue: 0.50), Color(red: 0.88, green: 0.42, blue: 0.35), Color(red: 0.98, green: 0.60, blue: 0.25),
        Color(red: 0.65, green: 0.30, blue: 0.45), Color(red: 0.92, green: 0.55, blue: 0.30), Color(red: 0.98, green: 0.75, blue: 0.35)
    ]
    
    private static let twilightColors: [Color] = [
        Color(red: 0.10, green: 0.08, blue: 0.25), Color(red: 0.18, green: 0.12, blue: 0.35), Color(red: 0.30, green: 0.15, blue: 0.40),
        Color(red: 0.12, green: 0.10, blue: 0.28), Color(red: 0.22, green: 0.15, blue: 0.38), Color(red: 0.35, green: 0.18, blue: 0.42),
        Color(red: 0.15, green: 0.12, blue: 0.30), Color(red: 0.25, green: 0.18, blue: 0.40), Color(red: 0.38, green: 0.22, blue: 0.35)
    ]
    
    private static let nightColors: [Color] = [
        Color(red: 0.04, green: 0.04, blue: 0.12), Color(red: 0.06, green: 0.06, blue: 0.16), Color(red: 0.05, green: 0.05, blue: 0.14),
        Color(red: 0.05, green: 0.05, blue: 0.14), Color(red: 0.07, green: 0.07, blue: 0.18), Color(red: 0.06, green: 0.06, blue: 0.15),
        Color(red: 0.04, green: 0.04, blue: 0.12), Color(red: 0.06, green: 0.05, blue: 0.15), Color(red: 0.05, green: 0.05, blue: 0.13)
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
