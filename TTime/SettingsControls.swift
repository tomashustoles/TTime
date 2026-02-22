//
//  SettingsControls.swift
//  TTime
//
//  Created by Tomas Hustoles on 24/1/26.
//

import SwiftUI

// MARK: - Map Thumbnail Background

private struct MapThumbnailBackground: View {
    let isDark: Bool

    var body: some View {
        ZStack {
            baseGradient
            MapLikeOutlinesShape(isDark: isDark)
        }
    }

    private var baseGradient: some View {
        LinearGradient(
            colors: isDark
                ? [
                    Color(red: 0.18, green: 0.20, blue: 0.28),
                    Color(red: 0.12, green: 0.14, blue: 0.20),
                ]
                : [
                    Color(red: 0.88, green: 0.90, blue: 0.93),
                    Color(red: 0.82, green: 0.85, blue: 0.88),
                ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

private struct MapLikeOutlinesShape: View {
    let isDark: Bool

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let strokeColor = isDark ? Color.white.opacity(0.12) : Color.black.opacity(0.08)

            ZStack {
                // Curved paths suggesting roads/rivers
                Path { p in
                    p.move(to: CGPoint(x: 0, y: h * 0.3))
                    p.addQuadCurve(to: CGPoint(x: w * 0.6, y: h * 0.2), control: CGPoint(x: w * 0.25, y: h * 0.1))
                    p.addQuadCurve(to: CGPoint(x: w, y: h * 0.5), control: CGPoint(x: w * 0.85, y: h * 0.15))
                    p.addQuadCurve(to: CGPoint(x: w * 0.4, y: h * 0.8), control: CGPoint(x: w * 0.9, y: h * 0.65))
                    p.addQuadCurve(to: CGPoint(x: 0, y: h * 0.3), control: CGPoint(x: w * 0.15, y: h * 0.9))
                }
                .stroke(strokeColor, lineWidth: 1.2)

                Path { p in
                    p.move(to: CGPoint(x: w * 0.2, y: 0))
                    p.addQuadCurve(to: CGPoint(x: w * 0.5, y: h * 0.6), control: CGPoint(x: w * 0.7, y: h * 0.2))
                    p.addQuadCurve(to: CGPoint(x: w * 0.1, y: h), control: CGPoint(x: w * 0.3, y: h * 0.85))
                }
                .stroke(strokeColor, lineWidth: 1)

                Path { p in
                    p.move(to: CGPoint(x: w * 0.7, y: h * 0.4))
                    p.addQuadCurve(to: CGPoint(x: w, y: h * 0.9), control: CGPoint(x: w * 0.55, y: h * 0.7))
                }
                .stroke(strokeColor, lineWidth: 0.8)

                // Small irregular polygon suggesting a boundary
                Path { p in
                    p.move(to: CGPoint(x: w * 0.25, y: h * 0.45))
                    p.addLine(to: CGPoint(x: w * 0.55, y: h * 0.4))
                    p.addLine(to: CGPoint(x: w * 0.6, y: h * 0.6))
                    p.addLine(to: CGPoint(x: w * 0.35, y: h * 0.65))
                    p.closeSubpath()
                }
                .stroke(strokeColor, lineWidth: 0.8)
            }
        }
    }
}

// MARK: - Theme Preview Thumbnail

private struct ThemePreviewThumbnail: View {
    @Environment(\.colorScheme) private var colorScheme
    let style: ThemeStyle
    let previewFont: Font

    private var isDark: Bool { colorScheme == .dark }

    var body: some View {
        ZStack {
            backgroundContent
            clockContent
        }
    }

    @ViewBuilder
    private var backgroundContent: some View {
        switch style {
        case .organic:
            MeshGradient(
                width: 3,
                height: 3,
                points: GradientPreset.meshPoints,
                colors: isDark ? OrganicGradientBackground.previewNightColors : OrganicGradientBackground.previewMiddayColors
            )
        case .basic:
            isDark ? Color.black : Color.white
        case .elegant:
            isDark
                ? Color(red: 0.07, green: 0.07, blue: 0.12)
                : Color(red: 0.97, green: 0.95, blue: 0.91)
        case .clock:
            if isDark {
                LinearGradient(
                    colors: [
                        Color(white: 0.25),
                        Color(white: 0.14),
                        Color(white: 0.09),
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            } else {
                LinearGradient(
                    colors: [
                        Color(white: 0.95),
                        Color(white: 0.90),
                        Color(white: 0.86),
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        case .map:
            MapThumbnailBackground(isDark: isDark)
        }
    }

    private var foregroundColor: Color {
        isDark ? .white : .black
    }

    @ViewBuilder
    private var clockContent: some View {
        switch style {
        case .organic:
            HStack(spacing: 0) {
                Text("12")
                    .font(previewFont)
                    .foregroundStyle(foregroundColor)
                    .monospacedDigit()
                Text(":")
                    .font(previewFont)
                    .foregroundStyle(foregroundColor)
                    .offset(y: -2)
                Text("34")
                    .font(previewFont)
                    .foregroundStyle(foregroundColor)
                    .monospacedDigit()
            }
        case .basic:
            HStack(spacing: 0) {
                Text("12")
                    .font(previewFont)
                    .foregroundStyle(foregroundColor)
                    .monospacedDigit()
                Text(":")
                    .font(previewFont)
                    .foregroundStyle(foregroundColor)
                    .offset(y: -2)
                Text("34")
                    .font(previewFont)
                    .foregroundStyle(foregroundColor)
                    .monospacedDigit()
            }
        case .elegant:
            let textColor = isDark ? Color.white : Color(red: 0.18, green: 0.14, blue: 0.10)
            let colonColor = isDark ? Color(white: 0.85) : Color(red: 0.72, green: 0.54, blue: 0.28)
            HStack(spacing: 0) {
                Text("12")
                    .font(previewFont)
                    .foregroundStyle(textColor)
                    .monospacedDigit()
                Text(":")
                    .font(previewFont)
                    .foregroundStyle(colonColor)
                    .offset(y: -2)
                Text("34")
                    .font(previewFont)
                    .foregroundStyle(textColor)
                    .monospacedDigit()
            }
        case .clock:
            let handColor = isDark ? Color.white : Color(white: 0.15)
            let ringOpacity: Double = isDark ? 0.20 : 0.65
            ZStack {
                Circle()
                    .stroke(
                        AngularGradient(
                            stops: [
                                .init(color: handColor.opacity(ringOpacity), location: 0.0),
                                .init(color: handColor.opacity(ringOpacity * 0.35), location: 0.5),
                                .init(color: handColor.opacity(ringOpacity), location: 1.0),
                            ],
                            center: .center
                        ),
                        lineWidth: 1.5
                    )
                    .frame(width: 32, height: 32)

                RoundedRectangle(cornerRadius: 0.5)
                    .fill(handColor.opacity(0.7))
                    .frame(width: 1.5, height: 6)
                    .offset(y: 3)
                    .rotationEffect(.degrees(-60))

                RoundedRectangle(cornerRadius: 0.5)
                    .fill(handColor.opacity(0.7))
                    .frame(width: 1.5, height: 8)
                    .offset(y: 4)
                    .rotationEffect(.degrees(-150))
            }
        case .map:
            HStack(spacing: 0) {
                Text("12")
                    .font(previewFont)
                    .foregroundStyle(foregroundColor)
                    .monospacedDigit()
                Text(":")
                    .font(previewFont)
                    .foregroundStyle(foregroundColor)
                    .offset(y: -2)
                Text("34")
                    .font(previewFont)
                    .foregroundStyle(foregroundColor)
                    .monospacedDigit()
            }
        }
    }
}

// MARK: - Theme Style Card

struct ThemeStyleCard: View {
    @Environment(\.theme) private var theme
    @Environment(\.colorScheme) private var colorScheme
    @State private var isHovered = false

    private var selectColor: Color { colorScheme == .dark ? .white : .black }

    let style: ThemeStyle
    let isSelected: Bool
    let action: () -> Void

    private var previewFont: Font {
        style.theme.clockFont(at: 24)
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {

                // Clock preview — matches actual theme appearance
                ThemePreviewThumbnail(style: style, previewFont: previewFont)
                .frame(width: 100, height: 56)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(
                            isSelected ? selectColor : Color.primary.opacity(0.12),
                            lineWidth: isSelected ? 2.5 : 1
                        )
                )

                Text(style.rawValue)
                    .font(.subheadline.weight(isSelected ? .semibold : .medium))
                    .foregroundStyle(isSelected ? selectColor : .primary)

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(selectColor)
                }
            }
            .padding(8)
            .background {
                if isSelected {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.14),
                                    Color.white.opacity(0.05),
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                } else if isHovered {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.white.opacity(0.06))
                }
            }
            .overlay {
                if isSelected {
                    RoundedRectangle(cornerRadius: 14)
                        .strokeBorder(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.3),
                                    Color.white.opacity(0.08),
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 0.75
                        )
                } else if isHovered {
                    RoundedRectangle(cornerRadius: 14)
                        .strokeBorder(Color.white.opacity(0.1), lineWidth: 0.5)
                }
            }
        }
        .buttonStyle(.plain)
        .focusEffectDisabled()
        #if !os(tvOS)
        .hoverEffectDisabled()
        .onHover { hovering in
            withAnimation(.easeOut(duration: 0.15)) {
                isHovered = hovering
            }
        }
        #endif
        .animation(.easeOut(duration: 0.2), value: isSelected)
    }
}

// MARK: - Background Swatch Button

struct BackgroundSwatchButton: View {
    @Environment(\.theme) private var theme
    @Environment(\.colorScheme) private var colorScheme

    let gradient: GradientPreset

    private var selectColor: Color { colorScheme == .dark ? .white : .black }
    let isSelected: Bool
    let isAnimated: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 5) {
                MeshGradient(
                    width: 3,
                    height: 3,
                    points: GradientPreset.meshPoints,
                    colors: gradient.meshColors
                )
                .frame(height: 56)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(
                            isSelected ? selectColor : Color.primary.opacity(0.15),
                            lineWidth: isSelected ? 3 : 1
                        )
                }
                .overlay(alignment: .topTrailing) {
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(selectColor == .white ? .black : .white)
                            .background(Circle().fill(selectColor).frame(width: 18, height: 18))
                            .offset(x: -3, y: 3)
                    }
                }

                Text(gradient.name)
                    .font(.caption2.weight(isSelected ? .bold : .medium))
                    .foregroundStyle(isSelected ? selectColor : .primary)
                    .lineLimit(1)
            }
        }
        .buttonStyle(.plain)
        .animation(.easeOut(duration: 0.2), value: isSelected)
    }
}

