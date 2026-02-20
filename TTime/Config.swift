//
//  Config.swift
//  TTime
//
//  Created by Tomas Hustoles on 23/1/26.
//

import Foundation

/// Centralized configuration for the TTime app
/// Controls API keys, feature flags, and service behavior
struct Config {
    
    // MARK: - Feature Flags
    
    /// Toggle between mock data (false) and live APIs (true)
    /// Set to false for development/testing, true for production
    static let useLiveData = true
    
    // MARK: - API Keys
    
    /// OpenWeather API key — resolved from env var, then Secrets.swift (gitignored)
    static let weatherAPIKey: String = {
        if let envKey = ProcessInfo.processInfo.environment["WEATHER_API_KEY"], !envKey.isEmpty {
            return envKey
        }
        return Secrets.weatherAPIKey
    }()
    
    /// NewsAPI key — resolved from env var, then Secrets.swift (gitignored)
    static let newsAPIKey: String = {
        if let envKey = ProcessInfo.processInfo.environment["NEWS_API_KEY"], !envKey.isEmpty {
            return envKey
        }
        return Secrets.newsAPIKey
    }()
    
    // MARK: - News Configuration
    
    /// News category to display
    /// Options: general, business, technology, science, health, sports, entertainment
    static let newsCategory = "general"
    
    /// Country code for news (ISO 3166-1 alpha-2)
    /// Examples: us, gb, ca, au, de, fr
    static let newsCountry = "us"
    
    /// Specific news sources (optional)
    /// If empty, uses country + category instead
    /// Example: ["bbc-news", "cnn", "the-verge"]
    static let newsSources: [String] = []
    
    // MARK: - Weather Configuration
    
    /// Default location for weather data
    static let defaultWeatherLocation = "Prague"
    
    // MARK: - Caching Configuration
    
    /// Enable/disable response caching
    static let enableCaching = true
    
    /// How long to cache API responses (in seconds)
    /// Default: 300 seconds (5 minutes)
    /// This helps stay within free API tier limits:
    /// - Weather: ~288 calls/day (vs 1000 limit)
    /// - News: ~96 calls/day (vs 100 limit)
    static let cacheDuration: TimeInterval = 300
    
    // MARK: - Network Configuration
    
    /// Timeout for API requests (in seconds)
    static let requestTimeout: TimeInterval = 10.0
    
    // MARK: - Debug Configuration
    
    /// Enable detailed API request logging
    /// Set to true to see API calls in console
    static let debugAPIRequests = false
    
    // MARK: - Helper Methods
    
    /// Print current configuration status
    static func printStatus() {
        print("""
        
        📱 TTime Configuration Status
        ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        Mode: \(useLiveData ? "🌐 LIVE" : "🔧 MOCK")
        
        API Keys:
          Weather: \(weatherAPIKey.isEmpty ? "❌ Not configured" : "✅ Configured")
          News: \(newsAPIKey.isEmpty ? "❌ Not configured" : "✅ Configured")
          Markets: ✅ No key required (using free APIs)
        
        News Settings:
          Category: \(newsCategory)
          Country: \(newsCountry)
          Sources: \(newsSources.isEmpty ? "None (using category)" : newsSources.joined(separator: ", "))
        
        Weather Settings:
          Location: \(defaultWeatherLocation)
        
        Performance:
          Cache Enabled: \(enableCaching ? "✅" : "❌")
          Cache Duration: \(Int(cacheDuration))s
          Request Timeout: \(Int(requestTimeout))s
        
        Debug:
          API Logging: \(debugAPIRequests ? "✅" : "❌")
        
        ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        
        """)
    }
}
