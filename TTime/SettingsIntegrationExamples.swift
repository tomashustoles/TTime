//
//  SettingsIntegrationExamples.swift
//  TTime
//
//  Created by Tomas Hustoles on 24/1/26.
//

import SwiftUI
import Foundation

// MARK: - Example: ClockView Integration

/*
 Update your ClockView to use the new settings:
 
 struct ClockView: View {
     @Environment(\.theme) private var theme
     @State private var currentTime = Date()
     
     let timezone: TimeZone
     let format: TimeFormat          // NEW
     let fontStyle: ClockFontStyle   // NEW
     
     var body: some View {
         Text(formattedTime)
             .font(fontStyle.font(               // Use fontStyle
                 size: theme.typography.clockSize,
                 weight: theme.typography.clockWeight
             ))
             .foregroundStyle(theme.colors.foreground)
             .onAppear { startTimer() }
     }
     
     private var formattedTime: String {
         let formatter = DateFormatter()
         formatter.timeZone = timezone
         
         // Use format setting
         switch format {
         case .twelveHour:
             formatter.dateFormat = "h:mm"
         case .twentyFourHour:
             formatter.dateFormat = "HH:mm"
         }
         
         return formatter.string(from: currentTime)
     }
 }
 
 // Usage in ContentView:
 ClockView(
     timezone: appState.selectedTimezone,
     format: appState.timeFormat,        // NEW
     fontStyle: appState.clockFontStyle  // NEW
 )
*/

// MARK: - Example: WeatherView Integration

/*
 Update your WeatherView to use location and visibility settings:
 
 struct WeatherView: View {
     @Environment(\.theme) private var theme
     
     let weatherService: WeatherServiceProtocol
     let temperatureUnit: TemperatureUnit
     let location: WeatherLocation           // NEW
     let showLocation: Bool                  // NEW
     
     @State private var weatherData: WeatherData?
     
     var body: some View {
         VStack(alignment: .trailing, spacing: 4) {
             Text(formattedTemperature(weatherData?.temperature ?? 0))
                 .font(.system(
                     size: theme.typography.standardSize,
                     weight: theme.typography.weight
                 ))
                 .foregroundStyle(theme.colors.foreground)
             
             Text(weatherData?.condition ?? "Loading...")
                 .font(.system(
                     size: theme.typography.standardSize,
                     weight: theme.typography.weight
                 ))
                 .foregroundStyle(theme.colors.foreground)
             
             // NEW: Conditional location display
             if showLocation {
                 Text(locationDisplayName)
                     .font(.system(
                         size: theme.typography.standardSize - 4,
                         weight: .regular
                     ))
                     .foregroundStyle(theme.colors.secondaryForeground)
             }
         }
         .task {
             await loadWeather()
         }
     }
     
     // NEW: Location display name
     private var locationDisplayName: String {
         switch location {
         case .current:
             return "Current Location"
         case .berlin:
             return "Berlin"
         case .newYork:
             return "New York"
         case .tokyo:
             return "Tokyo"
         case .london:
             return "London"
         case .paris:
             return "Paris"
         case .sydney:
             return "Sydney"
         }
     }
     
     // NEW: Load weather based on location
     private func loadWeather() async {
         // Use location setting to fetch appropriate data
         if location == .current {
             weatherData = await weatherService.getCurrentWeather()
         } else {
             weatherData = await weatherService.getWeatherForCity(locationDisplayName)
         }
     }
     
     private func formattedTemperature(_ temp: Double) -> String {
         let converted = temperatureUnit == .celsius 
             ? temp 
             : (temp * 9/5) + 32
         return String(format: "%.0f%@", converted, temperatureUnit.symbol)
     }
 }
 
 // Usage in ContentView:
 WeatherView(
     weatherService: appState.weatherService,
     temperatureUnit: appState.temperatureUnit,
     location: appState.weatherLocation,      // NEW
     showLocation: appState.showWeatherLocation  // NEW
 )
*/

// MARK: - Example: NewsView Integration

/*
 Update your NewsView to filter by category:
 
 struct NewsView: View {
     @Environment(\.theme) private var theme
     
     let newsService: NewsServiceProtocol
     let category: NewsCategory           // NEW
     
     @State private var headlines: [NewsHeadline] = []
     @State private var currentIndex = 0
     
     var body: some View {
         VStack(alignment: .leading, spacing: 8) {
             if !headlines.isEmpty {
                 // Category badge
                 HStack {
                     Image(systemName: category.icon)
                         .font(.system(size: 20))
                     Text(category.rawValue)
                         .font(.system(size: 20, weight: .semibold))
                 }
                 .foregroundStyle(theme.colors.secondaryForeground)
                 
                 Text(headlines[currentIndex].title)
                     .font(.system(
                         size: theme.typography.standardSize,
                         weight: theme.typography.weight
                     ))
                     .foregroundStyle(theme.colors.foreground)
                     .lineLimit(3)
             }
         }
         .task {
             await loadHeadlines()
         }
         // Reload when category changes
         .onChange(of: category) { _, _ in
             Task { await loadHeadlines() }
         }
     }
     
     // NEW: Load headlines for specific category
     private func loadHeadlines() async {
         headlines = await newsService.getHeadlines(category: category)
     }
 }
 
 // Usage in ContentView:
 NewsView(
     newsService: appState.newsService,
     category: appState.newsCategory      // NEW
 )
*/

// MARK: - Example: MarketView Integration

/*
 Update your MarketView to show only enabled tickers:
 
 struct MarketView: View {
     @Environment(\.theme) private var theme
     
     let marketService: MarketServiceProtocol
     let enabledTickers: Set<String>      // NEW
     
     @State private var allMarketData: [String: MarketData] = [:]
     
     var body: some View {
         VStack(alignment: .trailing, spacing: 8) {
             // Only show enabled tickers
             ForEach(visibleTickers, id: \.id) { ticker in
                 if let data = allMarketData[ticker.id] {
                     MarketTickerRow(ticker: ticker, data: data)
                 }
             }
         }
         .task {
             await loadMarketData()
         }
         // Reload when enabled tickers change
         .onChange(of: enabledTickers) { _, _ in
             Task { await loadMarketData() }
         }
     }
     
     // NEW: Filter tickers based on enabled set
     private var visibleTickers: [MarketTicker] {
         MarketTicker.availableTickers.filter { ticker in
             enabledTickers.contains(ticker.id)
         }
     }
     
     private func loadMarketData() async {
         for ticker in visibleTickers {
             allMarketData[ticker.id] = await marketService.getData(for: ticker.id)
         }
     }
 }
 
 struct MarketTickerRow: View {
     @Environment(\.theme) private var theme
     
     let ticker: MarketTicker
     let data: MarketData
     
     var body: some View {
         HStack {
             Text(ticker.symbol)
                 .font(.system(
                     size: theme.typography.standardSize - 2,
                     weight: .bold,
                     design: .monospaced
                 ))
             
             Text(String(format: "%.2f", data.price))
                 .font(.system(
                     size: theme.typography.standardSize,
                     weight: .semibold
                 ))
             
             Text(String(format: "%+.2f%%", data.change))
                 .font(.system(
                     size: theme.typography.standardSize - 2,
                     weight: .semibold
                 ))
                 .foregroundStyle(data.change >= 0 ? .green : .red)
         }
     }
 }
 
 // Usage in ContentView:
 MarketView(
     marketService: appState.marketService,
     enabledTickers: appState.enabledTickers  // NEW
 )
*/

// MARK: - Example: Background Integration

/*
 Update ContentView to use selected background:
 
 struct ContentView: View {
     @Environment(\.theme) private var theme
     @State private var appState = AppState()
     
     var body: some View {
         ZStack {
             // Dynamic background based on settings
             backgroundView
                 .ignoresSafeArea()
             
             // Main dashboard content...
         }
     }
     
     @ViewBuilder
     private var backgroundView: some View {
         if appState.useAnimatedGradient {
             // Animated mesh gradient
             AnimatedGradientBackground(
                 gradientPreset: theme.gradients[appState.selectedGradientIndex]
             )
         } else {
             // Static mesh gradient
             MeshGradient(
                 width: 3,
                 height: 3,
                 points: GradientPreset.meshPoints,
                 colors: theme.gradients[appState.selectedGradientIndex].meshColors
             )
         }
     }
 }
*/

// MARK: - Example: Service Protocol Updates

/*
 Update your service protocols to support new features:
 
 protocol WeatherServiceProtocol {
     func getCurrentWeather() async -> WeatherData?
     func getWeatherForCity(_ city: String) async -> WeatherData?  // NEW
 }
 
 protocol NewsServiceProtocol {
     func getHeadlines() async -> [NewsHeadline]
     func getHeadlines(category: NewsCategory) async -> [NewsHeadline]  // NEW
 }
 
 protocol MarketServiceProtocol {
     func getData(for tickerId: String) async -> MarketData?  // NEW
     func getBulkData(for tickerIds: [String]) async -> [String: MarketData]  // NEW
 }
*/

// MARK: - Example: Mock Service Updates

/*
 Update your mock services to handle new features:
 
 class MockWeatherService: WeatherServiceProtocol {
     func getCurrentWeather() async -> WeatherData? {
         WeatherData(
             temperature: 22.0,
             condition: "Partly Cloudy",
             location: "Current Location"
         )
     }
     
     func getWeatherForCity(_ city: String) async -> WeatherData? {
         let temps: [String: Double] = [
             "Berlin": 15.0,
             "New York": 18.0,
             "Tokyo": 23.0,
             "London": 12.0,
             "Paris": 16.0,
             "Sydney": 25.0
         ]
         
         return WeatherData(
             temperature: temps[city] ?? 20.0,
             condition: "Clear",
             location: city
         )
     }
 }
 
 class MockNewsService: NewsServiceProtocol {
     func getHeadlines() async -> [NewsHeadline] {
         await getHeadlines(category: .general)
     }
     
     func getHeadlines(category: NewsCategory) async -> [NewsHeadline] {
         let headlines: [NewsCategory: [String]] = [
             .general: [
                 "Global summit addresses climate change",
                 "New archaeological discovery in Egypt"
             ],
             .technology: [
                 "Apple announces new product lineup",
                 "AI breakthrough in medical diagnostics"
             ],
             .business: [
                 "Stock markets reach new highs",
                 "Tech startup raises $100M in funding"
             ],
             .science: [
                 "NASA discovers potentially habitable planet",
                 "Breakthrough in quantum computing"
             ],
             .health: [
                 "New vaccine shows promising results",
                 "Study links exercise to longevity"
             ],
             .sports: [
                 "Championship game ends in overtime thriller",
                 "Athlete breaks world record"
             ],
             .entertainment: [
                 "Award-winning film breaks box office records",
                 "Streaming service announces new series"
             ]
         ]
         
         return (headlines[category] ?? []).map { title in
             NewsHeadline(id: UUID().uuidString, title: title)
         }
     }
 }
*/

// MARK: - Example: Appearance Mode (Future)

/*
 When implementing dark/light mode:
 
 struct DynamicTheme: Theme {
     let appearanceMode: AppearanceMode
     
     var colors: ColorTokens {
         switch appearanceMode {
         case .light:
             return ColorTokens(
                 background: Color(red: 0.92, green: 0.90, blue: 0.87),
                 foreground: .black,
                 accent: .red,
                 // ... other colors
             )
         case .dark:
             return ColorTokens(
                 background: Color(white: 0.07),  // Near-black
                 foreground: .white,
                 accent: Color(red: 1.0, green: 0.27, blue: 0.27),
                 // ... other colors
             )
         }
     }
     
     // Other theme properties remain the same
     let typography = TypographyTokens(...)
     let spacing = SpacingTokens(...)
     let radius = RadiusTokens(...)
     let motion = MotionTokens(...)
     let gradients: [GradientPreset] = [...]
 }
 
 // In TTimeApp.swift:
 @main
 struct TTimeApp: App {
     @State private var appState = AppState()
     
     var body: some Scene {
         WindowGroup {
             ContentView()
                 .theme(DynamicTheme(
                     appearanceMode: appState.appearanceMode
                 ))
         }
     }
 }
*/

// MARK: - Testing Helpers
// Note: These helpers are now included in AppState.swift directly
// See AppState extension for resetToDefaults() and exportSettings() methods

