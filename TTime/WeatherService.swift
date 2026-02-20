//
//  WeatherService.swift
//  TTime
//
//  Created by Tomas Hustoles on 22/1/26.
//

import Foundation

// MARK: - Models

struct WeatherData: Identifiable {
    let id = UUID()
    let temperature: Double
    let condition: String
    let location: String
}

enum TemperatureUnit: String, CaseIterable, Identifiable {
    case celsius = "Celsius (°C)"
    case fahrenheit = "Fahrenheit (°F)"
    
    var id: String { rawValue }
    
    var symbol: String {
        switch self {
        case .celsius: return "°C"
        case .fahrenheit: return "°F"
        }
    }
}

// MARK: - Protocol

protocol WeatherServiceProtocol {
    func getCurrentWeather() async throws -> WeatherData
}

// MARK: - Mock Implementation

@Observable
class MockWeatherService: WeatherServiceProtocol {
    func getCurrentWeather() async throws -> WeatherData {
        // Simulate network delay
        try await Task.sleep(for: .milliseconds(100))
        
        return WeatherData(
            temperature: 22.0,
            condition: "Partly Cloudy",
            location: "Prague"
        )
    }
}
