//
//  SettingsControls.swift
//  TTime
//
//  Created by Tomas Hustoles on 24/1/26.
//

import SwiftUI

// MARK: - Theme Style Card

struct ThemeStyleCard: View {
    @Environment(\.theme) private var theme
    @State private var isHovered = false

    let style: ThemeStyle
    let isSelected: Bool
    let action: () -> Void

    private var previewFont: Font {
        style.theme.clockFont(at: 24)
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {

                // Clock preview
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(style.previewBackground)

                    if style == .clock {
                        ZStack {
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        colors: [
                                            Color.white.opacity(0.65),
                                            Color(white: 0.4).opacity(0.4),
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 3.5
                                )
                                .frame(width: 30, height: 30)

                            RoundedRectangle(cornerRadius: 1)
                                .fill(Color.white.opacity(0.6))
                                .frame(width: 2.5, height: 9)
                                .offset(y: -4.5)

                            RoundedRectangle(cornerRadius: 1)
                                .fill(Color.white.opacity(0.6))
                                .frame(width: 2, height: 12)
                                .offset(y: -6)
                                .rotationEffect(.degrees(90))

                            Circle()
                                .fill(Color.white.opacity(0.5))
                                .frame(width: 3.5, height: 3.5)
                        }
                    } else if style == .map {
                        ZStack {
                            Image(systemName: "map.fill")
                                .font(.system(size: 32))
                                .foregroundStyle(style.previewForeground.opacity(0.15))

                            Image(systemName: "mappin.and.ellipse")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundStyle(style.previewAccent)
                        }
                    } else {
                        HStack(spacing: 0) {
                            Text("12")
                                .font(previewFont)
                                .foregroundStyle(style.previewForeground)
                                .monospacedDigit()
                            Text(":")
                                .font(previewFont)
                                .foregroundStyle(style.previewAccent)
                                .offset(y: -2)
                            Text("34")
                                .font(previewFont)
                                .foregroundStyle(style.previewForeground)
                                .monospacedDigit()
                        }
                    }
                }
                .frame(width: 100, height: 56)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(
                            isSelected ? theme.colors.accent : Color.primary.opacity(0.12),
                            lineWidth: isSelected ? 2.5 : 1
                        )
                }

                Text(style.rawValue)
                    .font(.subheadline.weight(isSelected ? .semibold : .medium))
                    .foregroundStyle(isSelected ? theme.colors.accent : .primary)

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(theme.colors.accent)
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

    let gradient: GradientPreset
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
                            isSelected ? theme.colors.accent : Color.primary.opacity(0.15),
                            lineWidth: isSelected ? 3 : 1
                        )
                }
                .overlay(alignment: .topTrailing) {
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.white)
                            .background(Circle().fill(theme.colors.accent).frame(width: 18, height: 18))
                            .offset(x: -3, y: 3)
                    }
                }

                Text(gradient.name)
                    .font(.caption2.weight(isSelected ? .bold : .medium))
                    .foregroundStyle(isSelected ? theme.colors.accent : .primary)
                    .lineLimit(1)
            }
        }
        .buttonStyle(.plain)
        .animation(.easeOut(duration: 0.2), value: isSelected)
    }
}

