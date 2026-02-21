//
//  SettingsModels.swift
//  TTime
//
//  Created by Tomas Hustoles on 24/1/26.
//

import Foundation
import SwiftUI

// MARK: - Theme Style

enum ThemeStyle: String, CaseIterable, Identifiable {
    case organic = "Organic"
    case basic = "Basic"
    case elegant = "Elegant"

    var id: String { rawValue }

    var theme: Theme {
        switch self {
        case .organic:  return OrganicTheme()
        case .basic:    return BasicTheme()
        case .elegant:  return ElegantTheme()
        }
    }

    var description: String {
        switch self {
        case .organic:  return "Living gradient"
        case .basic:    return "Clean & minimal"
        case .elegant:  return "Refined serif"
        }
    }

    var previewBackground: Color {
        switch self {
        case .organic:  return Color(red: 0.22, green: 0.28, blue: 0.48)
        case .basic:    return Color(white: 0.97)
        case .elegant:  return Color(red: 0.97, green: 0.95, blue: 0.91)
        }
    }

    var previewForeground: Color {
        switch self {
        case .organic:  return .white
        case .basic:    return .black
        case .elegant:  return Color(red: 0.18, green: 0.14, blue: 0.10)
        }
    }

    var previewAccent: Color {
        switch self {
        case .organic:  return Color(red: 1.0, green: 0.38, blue: 0.18)
        case .basic:    return Color(red: 0.0, green: 0.48, blue: 1.0)
        case .elegant:  return Color(red: 0.72, green: 0.54, blue: 0.28)
        }
    }
}

// MARK: - Appearance Mode

enum AppearanceMode: String, CaseIterable, Identifiable {
    case light  = "Light"
    case dark   = "Dark"
    case system = "Auto"

    var id: String { rawValue }

    /// Returns the SwiftUI ColorScheme to enforce, or nil to follow the device.
    var colorScheme: ColorScheme? {
        switch self {
        case .light:  return .light
        case .dark:   return .dark
        case .system: return nil
        }
    }
}

// MARK: - Background Type

enum BackgroundType: Identifiable, Equatable {
    case gradient(Int) // Index into gradients array
    case solid(Color)
    
    var id: String {
        switch self {
        case .gradient(let index):
            return "gradient_\(index)"
        case .solid(let color):
            return "solid_\(color.description)"
        }
    }
}

// MARK: - Time Format

enum TimeFormat: String, CaseIterable, Identifiable {
    case twelveHour = "12-hour"
    case twentyFourHour = "24-hour"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .twelveHour:
            return "12-hour (AM/PM)"
        case .twentyFourHour:
            return "24-hour"
        }
    }
}

// MARK: - Clock Font Style

enum ClockFontStyle: String, CaseIterable, Identifiable {
    case standard = "Standard"
    case monospaced = "Monospaced"
    
    var id: String { rawValue }
    
    func font(size: CGFloat, weight: Font.Weight) -> Font {
        switch self {
        case .standard:
            return .system(size: size, weight: weight, design: .default)
        case .monospaced:
            return .system(size: size, weight: weight, design: .monospaced)
        }
    }
    
    var previewText: String {
        "12:34"
    }
}

// NOTE: TemperatureUnit is defined in WeatherService.swift
// We use that definition throughout the app

// MARK: - Weather Location

enum WeatherLocation: String, CaseIterable, Identifiable {
    case current = "Current Location"
    case berlin  = "Berlin"
    case newYork = "New York City"
    case tokyo   = "Tokyo"
    case london  = "London"
    case paris   = "Paris"
    case sydney  = "Sydney"

    var id: String { rawValue }

    /// Short display name shown in the picker row.
    var displayName: String {
        self == .current ? "Current" : rawValue
    }
}

// MARK: - News Category

enum NewsCategory: String, CaseIterable, Identifiable {
    case general = "General"
    case technology = "Technology"
    case business = "Business"
    case science = "Science"
    case health = "Health"
    case sports = "Sports"
    case entertainment = "Entertainment"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .general:
            return "newspaper"
        case .technology:
            return "cpu"
        case .business:
            return "chart.line.uptrend.xyaxis"
        case .science:
            return "flask"
        case .health:
            return "heart"
        case .sports:
            return "sportscourt"
        case .entertainment:
            return "film"
        }
    }
}

// NOTE: NewsSource is defined in NewsService.swift
// We use that definition throughout the app

// MARK: - Market Ticker

struct MarketTicker: Identifiable, Hashable {
    let id: String
    let symbol: String
    let displayName: String
    
    static let availableTickers: [MarketTicker] = [
        MarketTicker(id: "btc-usd", symbol: "BTC/USD", displayName: "Bitcoin"),
        MarketTicker(id: "sp500", symbol: "S&P 500", displayName: "S&P 500"),
        MarketTicker(id: "nasdaq", symbol: "NASDAQ", displayName: "NASDAQ"),
        MarketTicker(id: "dow", symbol: "DOW", displayName: "Dow Jones"),
        MarketTicker(id: "eth-usd", symbol: "ETH/USD", displayName: "Ethereum"),
        MarketTicker(id: "aapl", symbol: "AAPL", displayName: "Apple Inc."),
        MarketTicker(id: "tsla", symbol: "TSLA", displayName: "Tesla"),
        MarketTicker(id: "gold", symbol: "GOLD", displayName: "Gold"),
    ]
}

