//
//  SettingsControls.swift
//  TTime
//
//  Created by Tomas Hustoles on 24/1/26.
//

import SwiftUI

// MARK: - TV Segmented Control

struct TVSegmentedControl<T: RawRepresentable & Hashable & CaseIterable>: View where T.RawValue == String {
    @Environment(\.theme) private var theme
    @Binding var selection: T
    let options: [T]
    var displayName: ((T) -> String)?
    
    init(
        selection: Binding<T>,
        options: [T],
        displayName: ((T) -> String)? = nil
    ) {
        self._selection = selection
        self.options = options
        self.displayName = displayName
    }
    
    var body: some View {
        HStack(spacing: theme.spacing.small) {
            ForEach(options, id: \.self) { option in
                SegmentButton(
                    title: displayName?(option) ?? option.rawValue,
                    isSelected: selection == option
                ) {
                    selection = option
                }
            }
        }
    }
}

struct SegmentButton: View {
    @Environment(\.theme) private var theme
    @Environment(\.isFocused) private var isFocused
    
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(
                    size: theme.typography.standardSize,
                    weight: isSelected ? .bold : .semibold,
                    design: .default
                ))
                .foregroundStyle(isSelected ? .white : theme.colors.foreground)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, theme.spacing.medium)
                .padding(.vertical, theme.spacing.small)
                .background {
                    RoundedRectangle(cornerRadius: theme.radius.small)
                        .fill(isSelected ? theme.colors.accent : Color.clear)
                        .overlay {
                            if !isSelected {
                                RoundedRectangle(cornerRadius: theme.radius.small)
                                    .strokeBorder(theme.colors.cardBorder, lineWidth: 2)
                            }
                        }
                }
                .scaleEffect(isFocused ? theme.motion.focusScale : 1.0)
                .shadow(
                    color: isFocused ? theme.colors.focusRing.opacity(0.4) : .clear,
                    radius: isFocused ? 12 : 0
                )
        }
        .buttonStyle(.plain)
        .animation(.easeOut(duration: theme.motion.focusDuration), value: isFocused)
        .animation(.easeOut(duration: 0.2), value: isSelected)
    }
}

// MARK: - TV Toggle

struct TVToggle: View {
    @Environment(\.theme) private var theme
    @Environment(\.isFocused) private var isFocused
    @Binding var isOn: Bool
    
    let title: String
    let subtitle: String?
    
    init(title: String, subtitle: String? = nil, isOn: Binding<Bool>) {
        self.title = title
        self.subtitle = subtitle
        self._isOn = isOn
    }
    
    var body: some View {
        Button(action: { isOn.toggle() }) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(
                            size: theme.typography.standardSize,
                            weight: .semibold,
                            design: .default
                        ))
                        .foregroundStyle(theme.colors.foreground)
                    
                    if let subtitle {
                        Text(subtitle)
                            .font(.system(
                                size: theme.typography.standardSize - 4,
                                weight: .regular,
                                design: .default
                            ))
                            .foregroundStyle(theme.colors.secondaryForeground)
                    }
                }
                
                Spacer()
                
                // Toggle Switch
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isOn ? theme.colors.accent : theme.colors.secondaryForeground.opacity(0.3))
                        .frame(width: 80, height: 44)
                    
                    Circle()
                        .fill(.white)
                        .frame(width: 36, height: 36)
                        .offset(x: isOn ? 16 : -16)
                }
            }
            .padding(theme.spacing.medium)
            .background {
                RoundedRectangle(cornerRadius: theme.radius.small)
                    .fill(theme.colors.cardBackground)
                    .overlay {
                        RoundedRectangle(cornerRadius: theme.radius.small)
                            .strokeBorder(
                                isFocused ? theme.colors.focusRing : theme.colors.cardBorder,
                                lineWidth: isFocused ? 3 : 1
                            )
                    }
            }
            .scaleEffect(isFocused ? 1.02 : 1.0)
            .shadow(
                color: isFocused ? theme.colors.focusRing.opacity(0.3) : .clear,
                radius: isFocused ? 12 : 0
            )
        }
        .buttonStyle(.plain)
        .animation(.easeOut(duration: theme.motion.focusDuration), value: isFocused)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isOn)
    }
}

// MARK: - Background Swatch Button

struct BackgroundSwatchButton: View {
    @Environment(\.theme) private var theme
    @Environment(\.isFocused) private var isFocused
    
    let gradient: GradientPreset
    let isSelected: Bool
    let isAnimated: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: theme.spacing.tiny) {
                MeshGradient(
                    width: 3,
                    height: 3,
                    points: GradientPreset.meshPoints,
                    colors: gradient.meshColors
                )
                .frame(height: 80)
                .clipShape(RoundedRectangle(cornerRadius: theme.radius.small))
                .overlay {
                    RoundedRectangle(cornerRadius: theme.radius.small)
                        .strokeBorder(
                            isSelected ? theme.colors.accent : (isFocused ? theme.colors.foreground : theme.colors.cardBorder),
                            lineWidth: isSelected ? 4 : (isFocused ? 3 : 1)
                        )
                }
                .overlay(alignment: .topTrailing) {
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(.white)
                            .background {
                                Circle()
                                    .fill(theme.colors.accent)
                                    .frame(width: 28, height: 28)
                            }
                            .offset(x: -4, y: 4)
                    }
                }
                
                Text(gradient.name)
                    .font(.system(
                        size: theme.typography.standardSize - 4,
                        weight: isSelected ? .bold : .semibold,
                        design: .default
                    ))
                    .foregroundStyle(isSelected ? theme.colors.accent : theme.colors.foreground)
                    .lineLimit(1)
            }
            .scaleEffect(isFocused ? 1.05 : 1.0)
            .shadow(
                color: isFocused ? theme.colors.focusRing.opacity(0.3) : .clear,
                radius: isFocused ? 16 : 0
            )
        }
        .buttonStyle(.plain)
        .animation(.easeOut(duration: theme.motion.focusDuration), value: isFocused)
        .animation(.easeOut(duration: 0.2), value: isSelected)
    }
}

// MARK: - Clock Font Style Button

struct ClockFontStyleButton: View {
    @Environment(\.theme) private var theme
    @Environment(\.isFocused) private var isFocused
    
    let style: ClockFontStyle
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: theme.spacing.small) {
                // Preview
                Text(style.previewText)
                    .font(style.font(size: 48, weight: .bold))
                    .foregroundStyle(theme.colors.foreground)
                    .frame(maxWidth: .infinity)
                    .frame(height: 80)
                    .background {
                        RoundedRectangle(cornerRadius: theme.radius.small)
                            .fill(Color.white.opacity(0.5))
                    }
                
                // Label
                Text(style.rawValue)
                    .font(.system(
                        size: theme.typography.standardSize - 2,
                        weight: isSelected ? .bold : .semibold,
                        design: .default
                    ))
                    .foregroundStyle(isSelected ? theme.colors.accent : theme.colors.foreground)
            }
            .padding(theme.spacing.small)
            .background {
                RoundedRectangle(cornerRadius: theme.radius.small)
                    .fill(theme.colors.cardBackground)
                    .overlay {
                        RoundedRectangle(cornerRadius: theme.radius.small)
                            .strokeBorder(
                                isSelected ? theme.colors.accent : (isFocused ? theme.colors.focusRing : theme.colors.cardBorder),
                                lineWidth: isSelected ? 4 : (isFocused ? 3 : 1)
                            )
                    }
            }
            .scaleEffect(isFocused ? theme.motion.focusScale : 1.0)
            .shadow(
                color: isFocused ? theme.colors.focusRing.opacity(0.3) : .clear,
                radius: isFocused ? 12 : 0
            )
        }
        .buttonStyle(.plain)
        .animation(.easeOut(duration: theme.motion.focusDuration), value: isFocused)
        .animation(.easeOut(duration: 0.2), value: isSelected)
    }
}

// MARK: - Location Row Button

struct LocationRowButton: View {
    @Environment(\.theme) private var theme
    @Environment(\.isFocused) private var isFocused
    
    let location: WeatherLocation
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: location == .current ? "location.fill" : "mappin.circle.fill")
                    .font(.system(size: 24))
                    .foregroundStyle(isSelected ? theme.colors.accent : theme.colors.secondaryForeground)
                
                Text(location.rawValue)
                    .font(.system(
                        size: theme.typography.standardSize,
                        weight: isSelected ? .bold : .semibold,
                        design: .default
                    ))
                    .foregroundStyle(theme.colors.foreground)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 28))
                        .foregroundStyle(theme.colors.accent)
                }
            }
            .padding(theme.spacing.medium)
            .background {
                RoundedRectangle(cornerRadius: theme.radius.small)
                    .fill(isSelected ? theme.colors.accent.opacity(0.1) : theme.colors.cardBackground)
                    .overlay {
                        RoundedRectangle(cornerRadius: theme.radius.small)
                            .strokeBorder(
                                isSelected ? theme.colors.accent : (isFocused ? theme.colors.focusRing : theme.colors.cardBorder),
                                lineWidth: isSelected ? 3 : (isFocused ? 3 : 1)
                            )
                    }
            }
            .scaleEffect(isFocused ? 1.02 : 1.0)
            .shadow(
                color: isFocused ? theme.colors.focusRing.opacity(0.3) : .clear,
                radius: isFocused ? 12 : 0
            )
        }
        .buttonStyle(.plain)
        .animation(.easeOut(duration: theme.motion.focusDuration), value: isFocused)
        .animation(.easeOut(duration: 0.2), value: isSelected)
    }
}

// MARK: - News Category Chip

struct NewsCategoryChip: View {
    @Environment(\.theme) private var theme
    @Environment(\.isFocused) private var isFocused
    
    let category: NewsCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: theme.spacing.tiny) {
                Image(systemName: category.icon)
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundStyle(isSelected ? .white : theme.colors.accent)
                
                Text(category.rawValue)
                    .font(.system(
                        size: theme.typography.standardSize - 2,
                        weight: isSelected ? .bold : .semibold,
                        design: .default
                    ))
                    .foregroundStyle(isSelected ? .white : theme.colors.foreground)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, theme.spacing.medium)
            .padding(.horizontal, theme.spacing.small)
            .background {
                RoundedRectangle(cornerRadius: theme.radius.small)
                    .fill(isSelected ? theme.colors.accent : theme.colors.cardBackground)
                    .overlay {
                        if !isSelected {
                            RoundedRectangle(cornerRadius: theme.radius.small)
                                .strokeBorder(
                                    isFocused ? theme.colors.focusRing : theme.colors.cardBorder,
                                    lineWidth: isFocused ? 3 : 1
                                )
                        }
                    }
            }
            .scaleEffect(isFocused ? 1.05 : 1.0)
            .shadow(
                color: isFocused ? theme.colors.focusRing.opacity(0.4) : .clear,
                radius: isFocused ? 16 : 0
            )
        }
        .buttonStyle(.plain)
        .animation(.easeOut(duration: theme.motion.focusDuration), value: isFocused)
        .animation(.easeOut(duration: 0.2), value: isSelected)
    }
}

// MARK: - Ticker Toggle Row

struct TickerToggleRow: View {
    @Environment(\.theme) private var theme
    @Environment(\.isFocused) private var isFocused
    
    let ticker: MarketTicker
    let isEnabled: Bool
    let onToggle: (Bool) -> Void
    
    var body: some View {
        Button(action: { onToggle(!isEnabled) }) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(ticker.symbol)
                        .font(.system(
                            size: theme.typography.standardSize,
                            weight: .bold,
                            design: .monospaced
                        ))
                        .foregroundStyle(theme.colors.foreground)
                    
                    Text(ticker.displayName)
                        .font(.system(
                            size: theme.typography.standardSize - 4,
                            weight: .regular,
                            design: .default
                        ))
                        .foregroundStyle(theme.colors.secondaryForeground)
                }
                
                Spacer()
                
                // Toggle Switch
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isEnabled ? theme.colors.accent : theme.colors.secondaryForeground.opacity(0.3))
                        .frame(width: 80, height: 44)
                    
                    Circle()
                        .fill(.white)
                        .frame(width: 36, height: 36)
                        .offset(x: isEnabled ? 16 : -16)
                }
            }
            .padding(theme.spacing.medium)
            .background {
                RoundedRectangle(cornerRadius: theme.radius.small)
                    .fill(theme.colors.cardBackground)
                    .overlay {
                        RoundedRectangle(cornerRadius: theme.radius.small)
                            .strokeBorder(
                                isFocused ? theme.colors.focusRing : theme.colors.cardBorder,
                                lineWidth: isFocused ? 3 : 1
                            )
                    }
            }
            .scaleEffect(isFocused ? 1.02 : 1.0)
            .shadow(
                color: isFocused ? theme.colors.focusRing.opacity(0.3) : .clear,
                radius: isFocused ? 12 : 0
            )
        }
        .buttonStyle(.plain)
        .animation(.easeOut(duration: theme.motion.focusDuration), value: isFocused)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isEnabled)
    }
}
