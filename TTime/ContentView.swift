//
//  ContentView.swift
//  TTime
//
//  Created by Tomas Hustoles on 22/1/26.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.theme) private var theme
    @State private var appState = AppState()
    
    private var safeGradientIndex: Int {
        min(appState.selectedGradientIndex, theme.gradients.count - 1)
    }
    
    var body: some View {
        ZStack {
            // Dynamic background layer
            Group {
                if !appState.backgroundGradientsEnabled {
                    (appState.appearanceMode == .dark ? Color.black : Color.white)
                } else if appState.organicGradientEnabled {
                    OrganicGradientBackground(temperature: appState.currentTemperature)
                } else if appState.useAnimatedGradient {
                    AnimatedGradientBackground(gradientPreset: theme.gradients[safeGradientIndex])
                } else {
                    MeshGradient(
                        width: 3,
                        height: 3,
                        points: GradientPreset.meshPoints,
                        colors: theme.gradients[safeGradientIndex].meshColors
                    )
                }
            }
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
                
                VStack {
                    HStack {
                        Spacer()
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(theme.colors.secondaryForeground.opacity(0.3))
                            .padding(theme.spacing.cornerPadding)
                    }
                    Spacer()
                }
                
                ClockView(timezone: appState.selectedTimezone)
                
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
                            temperatureUnit: appState.temperatureUnit
                        )
                        .focusable()
                    }
                    
                    Spacer()
                    
                    HStack(alignment: .bottom) {
                        NewsView(newsService: appState.newsService)
                            .focusable()
                        
                        Spacer()
                        
                        MarketView(marketService: appState.marketService)
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
        .persistentSystemOverlays(.hidden)
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
    ContentView()
        .theme(DefaultTheme())
}
