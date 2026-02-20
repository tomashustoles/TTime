//
//  WeatherView.swift
//  TTime
//
//  Created by Tomas Hustoles on 22/1/26.
//

import SwiftUI

struct WeatherView: View {
    @Environment(\.theme) private var theme
    @Environment(\.isFocused) private var isFocused
    
    let weatherService: WeatherServiceProtocol
    let temperatureUnit: TemperatureUnit
    
    @State private var weatherData: WeatherData?
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    var body: some View {
        Group {
            if let weather = weatherData {
                VStack(alignment: .trailing, spacing: 4) {
                    // Temperature
                    Text(formattedTemperature(weather.temperature))
                        .font(.system(
                            size: theme.typography.standardSize,
                            weight: theme.typography.weight,
                            design: .default
                        ))
                        .foregroundStyle(theme.colors.foreground)
                    
                    // Condition
                    Text(weather.condition)
                        .font(.system(
                            size: theme.typography.standardSize,
                            weight: theme.typography.weight,
                            design: .default
                        ))
                        .foregroundStyle(theme.colors.secondaryForeground)
                    
                    // Location
                    Text(weather.location)
                        .font(.system(
                            size: theme.typography.standardSize,
                            weight: theme.typography.weight,
                            design: .default
                        ))
                        .foregroundStyle(theme.colors.secondaryForeground)
                }
            } else if isLoading {
                VStack(alignment: .trailing, spacing: 4) {
                    Text("--")
                        .font(.system(
                            size: theme.typography.standardSize,
                            weight: theme.typography.weight,
                            design: .default
                        ))
                        .foregroundStyle(theme.colors.foreground)
                    
                    Text("Loading...")
                        .font(.system(
                            size: theme.typography.standardSize,
                            weight: theme.typography.weight,
                            design: .default
                        ))
                        .foregroundStyle(theme.colors.secondaryForeground)
                }
            } else if let error = errorMessage {
                VStack(alignment: .trailing, spacing: 4) {
                    Text("--")
                        .font(.system(
                            size: theme.typography.standardSize,
                            weight: theme.typography.weight,
                            design: .default
                        ))
                        .foregroundStyle(theme.colors.foreground)
                    
                    Text(error)
                        .font(.system(
                            size: theme.typography.standardSize,
                            weight: theme.typography.weight,
                            design: .default
                        ))
                        .foregroundStyle(theme.colors.secondaryForeground)
                }
            }
        }
        .scaleEffect(isFocused ? theme.motion.focusScale : 1.0)
        .animation(.easeOut(duration: theme.motion.focusDuration), value: isFocused)
        .task {
            await loadWeather()
        }
    }
    
    private func formattedTemperature(_ celsius: Double) -> String {
        let temp: Double
        switch temperatureUnit {
        case .celsius:
            temp = celsius
        case .fahrenheit:
            temp = celsius * 9/5 + 32
        }
        return String(format: "%.0f%@", temp, temperatureUnit.symbol)
    }
    
    private func loadWeather() async {
        do {
            weatherData = try await weatherService.getCurrentWeather()
            isLoading = false
            errorMessage = nil
        } catch {
            isLoading = false
            errorMessage = "Weather unavailable"
            print("❌ Weather error: \(error.localizedDescription)")
        }
    }
}
