//
//  SettingsPanel.swift
//  TTime
//
//  Created by Tomas Hustoles on 24/1/26.
//

import SwiftUI

struct SettingsPanel: View {
    @Environment(\.theme) private var theme
    @Bindable var appState: AppState
    
    let onClose: () -> Void
    
    var body: some View {
        HStack(spacing: 0) {
            // Settings Sidebar Content
            ScrollView {
                VStack(alignment: .leading, spacing: theme.spacing.large) {
                    // Header
                    HStack {
                        Text("Settings")
                            .font(.system(
                                size: theme.typography.standardSize + 8,
                                weight: .bold,
                                design: .default
                            ))
                            .foregroundStyle(theme.colors.foreground)
                        
                        Spacer()
                        
                        Button(action: onClose) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 40))
                                .foregroundStyle(theme.colors.secondaryForeground)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.bottom, theme.spacing.small)
                    
                    // Design Section
                    SettingsCard(title: "Design", icon: "paintbrush.fill") {
                        VStack(alignment: .leading, spacing: theme.spacing.medium) {
                            // Dark / Light Mode
                            SettingSectionHeader(title: "Appearance Mode")
                            
                            TVSegmentedControl(
                                selection: $appState.appearanceMode,
                                options: AppearanceMode.allCases
                            )
                            
                            Divider()
                                .background(theme.colors.secondaryForeground.opacity(0.2))
                                .padding(.vertical, theme.spacing.tiny)
                            
                            // Backgrounds
                            SettingSectionHeader(title: "Background")
                            
                            LazyVGrid(columns: [
                                GridItem(.adaptive(minimum: 140, maximum: 160), spacing: theme.spacing.small)
                            ], spacing: theme.spacing.small) {
                                ForEach(0..<theme.gradients.count, id: \.self) { index in
                                    BackgroundSwatchButton(
                                        gradient: theme.gradients[index],
                                        isSelected: appState.selectedGradientIndex == index,
                                        isAnimated: appState.useAnimatedGradient && appState.selectedGradientIndex == index
                                    ) {
                                        appState.selectedGradientIndex = index
                                    }
                                }
                            }
                            
                            // Animated gradient toggle
                            TVToggle(
                                title: "Animate gradient",
                                subtitle: "Slow, subtle motion",
                                isOn: $appState.useAnimatedGradient
                            )
                        }
                    }
                    
                    // Time Section
                    SettingsCard(title: "Time", icon: "clock.fill") {
                        VStack(alignment: .leading, spacing: theme.spacing.medium) {
                            // Time Format
                            SettingSectionHeader(title: "Time Format")
                            
                            TVSegmentedControl(
                                selection: $appState.timeFormat,
                                options: TimeFormat.allCases,
                                displayName: { $0.displayName }
                            )
                            
                            Divider()
                                .background(theme.colors.secondaryForeground.opacity(0.2))
                                .padding(.vertical, theme.spacing.tiny)
                            
                            // Clock Font
                            SettingSectionHeader(title: "Clock Font")
                            
                            HStack(spacing: theme.spacing.medium) {
                                ForEach(ClockFontStyle.allCases) { style in
                                    ClockFontStyleButton(
                                        style: style,
                                        isSelected: appState.clockFontStyle == style
                                    ) {
                                        appState.clockFontStyle = style
                                    }
                                }
                            }
                        }
                    }
                    
                    // Weather Section
                    SettingsCard(title: "Weather", icon: "cloud.sun.fill") {
                        VStack(alignment: .leading, spacing: theme.spacing.medium) {
                            // Temperature Unit
                            SettingSectionHeader(title: "Temperature Unit")
                            
                            TVSegmentedControl(
                                selection: $appState.temperatureUnit,
                                options: TemperatureUnit.allCases
                            )
                            
                            Divider()
                                .background(theme.colors.secondaryForeground.opacity(0.2))
                                .padding(.vertical, theme.spacing.tiny)
                            
                            // Location Visibility
                            TVToggle(
                                title: "Show location",
                                subtitle: "Displays city name under temperature",
                                isOn: $appState.showWeatherLocation
                            )
                            
                            Divider()
                                .background(theme.colors.secondaryForeground.opacity(0.2))
                                .padding(.vertical, theme.spacing.tiny)
                            
                            // Location Source
                            SettingSectionHeader(title: "Location Source")
                            
                            VStack(spacing: theme.spacing.tiny) {
                                ForEach(WeatherLocation.allCases) { location in
                                    LocationRowButton(
                                        location: location,
                                        isSelected: appState.weatherLocation == location
                                    ) {
                                        appState.weatherLocation = location
                                    }
                                }
                            }
                        }
                    }
                    
                    // News Section
                    SettingsCard(title: "News", icon: "newspaper.fill") {
                        VStack(alignment: .leading, spacing: theme.spacing.medium) {
                            SettingSectionHeader(title: "Category")
                            
                            LazyVGrid(columns: [
                                GridItem(.adaptive(minimum: 160, maximum: 200), spacing: theme.spacing.small)
                            ], spacing: theme.spacing.small) {
                                ForEach(NewsCategory.allCases) { category in
                                    NewsCategoryChip(
                                        category: category,
                                        isSelected: appState.newsCategory == category
                                    ) {
                                        appState.newsCategory = category
                                    }
                                }
                            }
                        }
                    }
                    
                    // Markets Section
                    SettingsCard(title: "Markets", icon: "chart.line.uptrend.xyaxis") {
                        VStack(alignment: .leading, spacing: theme.spacing.medium) {
                            SettingSectionHeader(title: "Visible Tickers")
                            
                            VStack(spacing: theme.spacing.tiny) {
                                ForEach(MarketTicker.availableTickers) { ticker in
                                    TickerToggleRow(
                                        ticker: ticker,
                                        isEnabled: appState.enabledTickers.contains(ticker.id)
                                    ) { enabled in
                                        if enabled {
                                            appState.enabledTickers.insert(ticker.id)
                                        } else {
                                            appState.enabledTickers.remove(ticker.id)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    // Bottom padding
                    Color.clear.frame(height: theme.spacing.medium)
                }
                .padding(theme.spacing.large)
            }
            .frame(width: 800)
            .background {
                RoundedRectangle(cornerRadius: 0)
                    .fill(theme.colors.sidebarBlur)
                    .shadow(color: .black.opacity(0.3), radius: 60, x: 20, y: 0)
            }
            
            Spacer()
        }
        .transition(.move(edge: .leading).combined(with: .opacity))
    }
}

// MARK: - Settings Card

struct SettingsCard<Content: View>: View {
    @Environment(\.theme) private var theme
    
    let title: String
    let icon: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: theme.spacing.medium) {
            HStack(spacing: theme.spacing.small) {
                Image(systemName: icon)
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(theme.colors.accent)
                
                Text(title)
                    .font(.system(
                        size: theme.typography.standardSize + 4,
                        weight: .bold,
                        design: .default
                    ))
                    .foregroundStyle(theme.colors.foreground)
            }
            
            content
        }
        .padding(theme.spacing.medium)
        .background {
            RoundedRectangle(cornerRadius: theme.radius.medium)
                .fill(theme.colors.cardBackground)
                .overlay {
                    RoundedRectangle(cornerRadius: theme.radius.medium)
                        .strokeBorder(theme.colors.cardBorder, lineWidth: 1)
                }
        }
    }
}

// MARK: - Section Header

struct SettingSectionHeader: View {
    @Environment(\.theme) private var theme
    
    let title: String
    
    var body: some View {
        Text(title)
            .font(.system(
                size: theme.typography.standardSize - 2,
                weight: .semibold,
                design: .default
            ))
            .foregroundStyle(theme.colors.secondaryForeground)
            .textCase(.uppercase)
            .tracking(0.5)
    }
}
