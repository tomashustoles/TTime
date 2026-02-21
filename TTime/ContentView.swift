//
//  ContentView.swift
//  TTime
//
//  Created by Tomas Hustoles on 22/1/26.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.theme) private var theme
    @Environment(\.colorScheme) private var deviceColorScheme
    let appState: AppState

    // MARK: - Effective darkness

    /// True when the current combination of theme + appearance results in a dark background.
    private var isDarkBackground: Bool {
        switch appState.themeStyle {
        case .organic:
            let effectiveHour = organicForcedHour ?? Double(Calendar.current.component(.hour, from: Date()))
            return effectiveHour < 7 || effectiveHour >= 18
        case .basic, .elegant:
            switch appState.appearanceMode {
            case .light:  return false
            case .dark:   return true
            case .system: return deviceColorScheme == .dark
            }
        }
    }

    // MARK: - Background

    /// For Organic theme: override the fractional hour so Light forces midday colours,
    /// Dark forces night colours, and System follows the real clock.
    private var organicForcedHour: Double? {
        switch appState.appearanceMode {
        case .light:  return 12.0   // midday — bright, airy
        case .dark:   return 2.0    // deep night — dark, cool
        case .system: return nil    // real time of day
        }
    }

    @ViewBuilder
    private var themeBackground: some View {
        switch appState.themeStyle {
        case .organic:
            OrganicGradientBackground(
                temperature: appState.currentTemperature,
                forcedHour: organicForcedHour
            )
        case .basic:
            isDarkBackground ? Color.black : Color.white
        case .elegant:
            isDarkBackground
                ? Color(red: 0.07, green: 0.07, blue: 0.12)
                : Color(red: 0.97, green: 0.95, blue: 0.91)
        }
    }

    // MARK: - Adaptive Colors

    private var adaptiveForeground: Color {
        isDarkBackground ? .white : .black
    }

    private var adaptiveSecondaryForeground: Color {
        isDarkBackground ? Color(white: 0.7) : Color(white: 0.4)
    }

    private var adaptiveCardBackground: Color {
        isDarkBackground ? Color(white: 0.15, opacity: 0.6) : Color(white: 0.98, opacity: 0.95)
    }

    private var adaptiveCardBorder: Color {
        isDarkBackground ? Color(white: 0.35) : Color(white: 0.85)
    }

    var body: some View {
        ZStack {
            // Background layer
            themeBackground
                .ignoresSafeArea()

            // Main dashboard layout
            ZStack {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if !appState.isSettingsPanelOpen {
                            withAnimation(.easeInOut(duration: theme.motion.transitionDuration)) {
                                appState.isSettingsPanelOpen = true
                            }
                        }
                    }

                ClockView(timezone: appState.selectedTimezone, timeFormat: appState.timeFormat)

                VStack {
                    HStack(alignment: .top) {
                        AppIdentityButton {
                            withAnimation(.easeInOut(duration: theme.motion.transitionDuration)) {
                                appState.isSettingsPanelOpen.toggle()
                            }
                        }
                        .focusable()

                        Spacer()

                        WeatherView(
                            weatherService: appState.weatherService,
                            temperatureUnit: appState.temperatureUnit,
                            showLocation: appState.showWeatherLocation
                        )
                        .focusable()
                    }

                    Spacer()

                    HStack(alignment: .bottom) {
                        NewsView(newsService: appState.newsService)
                            .focusable()

                        Spacer()

                        MarketView(
                            marketService: appState.marketService,
                            enabledTickers: appState.enabledTickers
                        )
                        .focusable()
                    }
                }
                .padding(theme.spacing.cornerPadding)
                .allowsHitTesting(false)

                if appState.isSettingsPanelOpen {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: theme.motion.transitionDuration)) {
                                appState.isSettingsPanelOpen = false
                            }
                        }

                    SettingsPanel(appState: appState) {
                        withAnimation(.easeInOut(duration: theme.motion.transitionDuration)) {
                            appState.isSettingsPanelOpen = false
                        }
                    }
                }
            }
        }
        .environment(\.adaptiveForeground, adaptiveForeground)
        .environment(\.adaptiveSecondaryForeground, adaptiveSecondaryForeground)
        .environment(\.adaptiveCardBackground, adaptiveCardBackground)
        .environment(\.adaptiveCardBorder, adaptiveCardBorder)
        .persistentSystemOverlays(.hidden)
        #if !os(tvOS)
        .gesture(
            DragGesture(minimumDistance: 50)
                .onEnded { value in
                    if value.translation.width > 100 && abs(value.translation.height) < 80 {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                            appState.isSettingsPanelOpen = true
                        }
                    } else if value.translation.width < -100 && abs(value.translation.height) < 80 && appState.isSettingsPanelOpen {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                            appState.isSettingsPanelOpen = false
                        }
                    }
                }
        )
        #endif
        .onTapGesture {
            if !appState.isSettingsPanelOpen {
                withAnimation(.easeInOut(duration: theme.motion.transitionDuration)) {
                    appState.isSettingsPanelOpen = true
                }
            }
        }
        .onPlayPauseCommand {
            withAnimation(.easeInOut(duration: theme.motion.transitionDuration)) {
                appState.isSettingsPanelOpen.toggle()
            }
        }
        .task {
            await fetchTemperatureForOrganic()
        }
    }

    private func fetchTemperatureForOrganic() async {
        do {
            let weather = try await appState.weatherService.getCurrentWeather()
            appState.currentTemperature = weather.temperature
        } catch {
            appState.currentTemperature = nil
        }
    }
}

#Preview {
    let appState = AppState()
    ContentView(appState: appState)
        .theme(OrganicTheme())
}
