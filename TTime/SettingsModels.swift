//
//  SettingsModels.swift
//  TTime
//
//  Created by Tomas Hustoles on 24/1/26.
//

import Foundation
import SwiftUI

// MARK: - Appearance Mode

enum AppearanceMode: String, CaseIterable, Identifiable {
    case light = "Light"
    case dark = "Dark"
    
    var id: String { rawValue }
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
    case berlin = "Berlin"
    case newYork = "New York City"
    case tokyo = "Tokyo"
    case london = "London"
    case paris = "Paris"
    case sydney = "Sydney"
    
    var id: String { rawValue }
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

