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
    
    var body: some View {
        ZStack {
            // Gradient background - brighter in the middle
            RadialGradient(
                gradient: Gradient(colors: [
                    Color(hex: "FFFFFF"), // Brighter white in center
                    Color(hex: "F8F8F8")  // #F8F8F8 at edges
                ]),
                center: .center,
                startRadius: 100,
                endRadius: 800
            )
            .ignoresSafeArea()
            
            // Main dashboard layout
            ZStack {
                // Invisible tap area to open settings (click anywhere on screen)
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
                        // Subtle hint: gear icon in top-right
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(theme.colors.secondaryForeground.opacity(0.3))
                            .padding(theme.spacing.cornerPadding)
                    }
                    Spacer()
                }
                
                // Center: Large clock
                ClockView(timezone: appState.selectedTimezone)
                
                VStack {
                    // Top row
                    HStack(alignment: .top) {
                        // Top-left: App identity / menu button
                        AppIdentityButton {
                            withAnimation(.easeInOut(duration: theme.motion.transitionDuration)) {
                                appState.isSettingsPanelOpen.toggle()
                            }
                        }
                        .focusable()
                        
                        Spacer()
                        
                        // Top-right: Weather
                        WeatherView(
                            weatherService: appState.weatherService,
                            temperatureUnit: appState.temperatureUnit
                        )
                        .focusable()
                    }
                    
                    Spacer()
                    
                    // Bottom row
                    HStack(alignment: .bottom) {
                        // Bottom-left: News
                        NewsView(newsService: appState.newsService)
                            .focusable()
                        
                        Spacer()
                        
                        // Bottom-right: Markets
                        MarketView(marketService: appState.marketService)
                            .focusable()
                    }
                }
                .padding(theme.spacing.cornerPadding)
                .allowsHitTesting(false) // Allow taps to pass through to the clear layer
                
                // Settings panel overlay
                if appState.isSettingsPanelOpen {
                    // Semi-transparent overlay
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: theme.motion.transitionDuration)) {
                                appState.isSettingsPanelOpen = false
                            }
                        }
                    
                    // Settings sidebar from left
                    SettingsPanel(appState: appState) {
                        withAnimation(.easeInOut(duration: theme.motion.transitionDuration)) {
                            appState.isSettingsPanelOpen = false
                        }
                    }
                }
            }
        }
        .persistentSystemOverlays(.hidden)
        .onTapGesture {
            // Also allow tapping the main view to open settings
            if !appState.isSettingsPanelOpen {
                withAnimation(.easeInOut(duration: theme.motion.transitionDuration)) {
                    appState.isSettingsPanelOpen = true
                }
            }
        }
        // Keyboard shortcut: Press "S" or Menu button to toggle settings
        .onPlayPauseCommand {
            withAnimation(.easeInOut(duration: theme.motion.transitionDuration)) {
                appState.isSettingsPanelOpen.toggle()
            }
        }
    }
}

#Preview {
    ContentView()
        .theme(DefaultTheme())
}
