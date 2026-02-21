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

    let style: ThemeStyle
    let isSelected: Bool
    let action: () -> Void

    private var previewFont: Font {
        style.theme.clockFont(at: 24)
    }

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {

                // Clock preview
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(style.previewBackground)

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
                .frame(maxWidth: .infinity)
                .frame(height: 72)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(
                            isSelected ? theme.colors.accent : Color.primary.opacity(0.12),
                            lineWidth: isSelected ? 2.5 : 1
                        )
                }
                .overlay(alignment: .topTrailing) {
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(theme.colors.accent)
                            .background(Circle().fill(.white).frame(width: 14, height: 14))
                            .offset(x: -5, y: 5)
                    }
                }

                Text(style.rawValue)
                    .font(.caption.weight(isSelected ? .semibold : .medium))
                    .foregroundStyle(isSelected ? theme.colors.accent : .primary)
            }
        }
        .buttonStyle(.plain)
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

