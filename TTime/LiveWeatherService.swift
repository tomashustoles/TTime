//
//  LiveWeatherService.swift
//  TTime
//
//  Created by Tomas Hustoles on 23/1/26.
//

import Foundation
import CoreLocation

class LiveWeatherService: NSObject, WeatherServiceProtocol, URLSessionDelegate {
    private let apiKey: String
    private let baseURL = "https://api.openweathermap.org/data/2.5"
    private let locationManager = CLLocationManager()
    private var urlSession: URLSession!
    
    init(apiKey: String) {
        self.apiKey = apiKey
        
        super.init()
        
        // Create a custom URLSession configuration
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10.0
        configuration.timeoutIntervalForResource = 30.0
        
        // ⚠️ DEVELOPMENT ONLY: Bypass SSL for corporate proxy (Zscaler)
        // TODO: Remove this before production deployment
        self.urlSession = URLSession(
            configuration: configuration,
            delegate: self,
            delegateQueue: nil
        )
    }
    
    // ⚠️ DEVELOPMENT ONLY: Bypass SSL certificate validation
    // This allows the app to work behind Zscaler proxy
    // DO NOT use in production!
    func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        print("🔐 [WEATHER] URLSession delegate called for: \(challenge.protectionSpace.host)")
        print("🔐 [WEATHER] Authentication method: \(challenge.protectionSpace.authenticationMethod)")
        
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
           let serverTrust = challenge.protectionSpace.serverTrust {
            print("✅ [WEATHER] Accepting server trust for Zscaler certificate")
            let credential = URLCredential(trust: serverTrust)
            completionHandler(.useCredential, credential)
        } else {
            print("⚠️ [WEATHER] Using default handling for challenge")
            completionHandler(.performDefaultHandling, nil)
        }
    }
    
    func getCurrentWeather() async throws -> WeatherData {
        // Use a default location (Prague) or implement location services
        let location = "Prague"
        let url = URL(string: "\(baseURL)/weather?q=\(location)&appid=\(apiKey)&units=metric")!
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 10.0
        
        let (data, response) = try await urlSession.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw WeatherError.invalidResponse
        }
        
        let decoder = JSONDecoder()
        let apiResponse = try decoder.decode(OpenWeatherResponse.self, from: data)
        
        return WeatherData(
            temperature: apiResponse.main.temp,
            condition: apiResponse.weather.first?.main.capitalized ?? "Unknown",
            location: apiResponse.name
        )
    }
}

// MARK: - API Response Models

private struct OpenWeatherResponse: Codable {
    let main: Main
    let weather: [Weather]
    let name: String
    
    struct Main: Codable {
        let temp: Double
        let feelsLike: Double
        let tempMin: Double
        let tempMax: Double
        let humidity: Int
        
        enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case humidity
        }
    }
    
    struct Weather: Codable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
}

// MARK: - Errors

enum WeatherError: LocalizedError {
    case invalidResponse
    case locationNotAvailable
    case apiKeyMissing
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Unable to fetch weather data"
        case .locationNotAvailable:
            return "Location not available"
        case .apiKeyMissing:
            return "Weather API key not configured"
        }
    }
}
