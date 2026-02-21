//
//  AppState.swift
//  TTime
//
//  Created by Tomas Hustoles on 22/1/26.
//  Enhanced on 24/1/26 with comprehensive settings support
//

import Foundation
import SwiftUI

@Observable
class AppState {
    // MARK: - UI State
    var isSettingsPanelOpen: Bool = false
    
    // MARK: - Appearance Settings
    var themeStyle: ThemeStyle = .organic {
        didSet {
            UserDefaults.standard.set(themeStyle.rawValue, forKey: "themeStyle")
        }
    }

    var appearanceMode: AppearanceMode = .system {
        didSet {
            UserDefaults.standard.set(appearanceMode.rawValue, forKey: "appearanceMode")
        }
    }

    /// The SwiftUI ColorScheme to enforce, or nil to follow the device.
    var effectiveColorScheme: ColorScheme? {
        appearanceMode.colorScheme
    }

    // MARK: - Time Settings
    var timeFormat: TimeFormat = .twelveHour {
        didSet {
            UserDefaults.standard.set(timeFormat.rawValue, forKey: "timeFormat")
        }
    }
    
    var selectedTimezone: TimeZone = .current {
        didSet {
            UserDefaults.standard.set(selectedTimezone.identifier, forKey: "selectedTimezone")
        }
    }
    
    // MARK: - Weather Settings
    var temperatureUnit: TemperatureUnit = .celsius {
        didSet {
            UserDefaults.standard.set(temperatureUnit.rawValue, forKey: "temperatureUnit")
        }
    }
    
    var showWeatherLocation: Bool = true {
        didSet {
            UserDefaults.standard.set(showWeatherLocation, forKey: "showWeatherLocation")
        }
    }
    
    var weatherLocation: WeatherLocation = .current {
        didSet {
            UserDefaults.standard.set(weatherLocation.rawValue, forKey: "weatherLocation")
            selectedLocation = weatherLocation.rawValue
        }
    }
    
    // Legacy support for existing code
    var selectedLocation: String = "Current Location"
    
    // MARK: - News Settings
    var newsCategory: NewsCategory = .general {
        didSet {
            UserDefaults.standard.set(newsCategory.rawValue, forKey: "newsCategory")
        }
    }
    
    var selectedNewsSource: NewsSource = .bbc {
        didSet {
            UserDefaults.standard.set(selectedNewsSource.rawValue, forKey: "selectedNewsSource")
        }
    }
    
    // MARK: - Market Settings
    var enabledTickers: Set<String> = ["btc-usd", "sp500"] {
        didSet {
            UserDefaults.standard.set(Array(enabledTickers), forKey: "enabledTickers")
        }
    }
    
    // MARK: - Cached Weather Data (for organic gradient)
    var currentTemperature: Double? = nil
    
    // MARK: - Services
    let weatherService: WeatherServiceProtocol
    let newsService: NewsServiceProtocol
    let marketService: MarketServiceProtocol
    
    // MARK: - Initialization
    init(
        weatherService: WeatherServiceProtocol = ServiceFactory.createCachedWeatherService(),
        newsService: NewsServiceProtocol = ServiceFactory.createCachedNewsService(),
        marketService: MarketServiceProtocol = ServiceFactory.createCachedMarketService()
    ) {
        self.weatherService = weatherService
        self.newsService = newsService
        self.marketService = marketService
        
        // Load persisted settings
        loadSettings()

        // Print configuration status on launch
        #if DEBUG
        Config.printStatus()
        #endif
    }

    private func loadSettings() {
        if let s = UserDefaults.standard.string(forKey: "themeStyle"),
           let style = ThemeStyle(rawValue: s) { themeStyle = style }

        if let s = UserDefaults.standard.string(forKey: "appearanceMode"),
           let mode = AppearanceMode(rawValue: s) { appearanceMode = mode }

        if let s = UserDefaults.standard.string(forKey: "timeFormat"),
           let format = TimeFormat(rawValue: s) { timeFormat = format }

        if let timezoneId = UserDefaults.standard.string(forKey: "selectedTimezone"),
           let timezone = TimeZone(identifier: timezoneId) {
            selectedTimezone = timezone
        }
        
        // Weather
        if let unitString = UserDefaults.standard.string(forKey: "temperatureUnit"),
           let unit = TemperatureUnit(rawValue: unitString) {
            temperatureUnit = unit
        }
        
        showWeatherLocation = UserDefaults.standard.bool(forKey: "showWeatherLocation")
        
        if let locationString = UserDefaults.standard.string(forKey: "weatherLocation"),
           let location = WeatherLocation(rawValue: locationString) {
            weatherLocation = location
        }
        
        // News
        if let categoryString = UserDefaults.standard.string(forKey: "newsCategory"),
           let category = NewsCategory(rawValue: categoryString) {
            newsCategory = category
        }
        
        if let sourceString = UserDefaults.standard.string(forKey: "selectedNewsSource"),
           let source = NewsSource(rawValue: sourceString) {
            selectedNewsSource = source
        }
        
        // Markets
        if let tickersArray = UserDefaults.standard.array(forKey: "enabledTickers") as? [String] {
            enabledTickers = Set(tickersArray)
        }
    }
}
// MARK: - Testing Helpers

extension AppState {
    /// Reset all settings to defaults (useful for testing)
    static func resetToDefaults() {
        let defaults = UserDefaults.standard
        let keys = [
            "themeStyle", "appearanceMode",
            "timeFormat", "selectedTimezone",
            "temperatureUnit", "showWeatherLocation", "weatherLocation",
            "newsCategory", "selectedNewsSource", "enabledTickers"
        ]
        keys.forEach { defaults.removeObject(forKey: $0) }
    }

    /// Export settings as JSON (useful for debugging)
    func exportSettings() -> String {
        let dict: [String: Any] = [
            "themeStyle": themeStyle.rawValue,
            "appearanceMode": appearanceMode.rawValue,
            "timeFormat": timeFormat.rawValue,
            "selectedTimezone": selectedTimezone.identifier,
            "temperatureUnit": temperatureUnit.rawValue,
            "showWeatherLocation": showWeatherLocation,
            "weatherLocation": weatherLocation.rawValue,
            "newsCategory": newsCategory.rawValue,
            "selectedNewsSource": selectedNewsSource.rawValue,
            "enabledTickers": Array(enabledTickers)
        ]
        
        if let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
           let json = String(data: data, encoding: .utf8) {
            return json
        }
        return "{}"
    }
}

