# Integration Guide: Live APIs

This guide explains how to integrate real APIs into the Time app by replacing mock services.

## Architecture Overview

The app uses **protocol-based dependency injection**. All views depend on protocols, not concrete implementations:

```swift
protocol WeatherServiceProtocol {
    func getCurrentWeather() async throws -> WeatherData
}
```

This means you can swap implementations without changing any UI code.

## Step-by-Step Integration

### 1. Weather Service Integration

#### Example: OpenWeather API

Create a new file `LiveWeatherService.swift`:

```swift
import Foundation

class LiveWeatherService: WeatherServiceProtocol {
    private let apiKey: String
    private let baseURL = "https://api.openweathermap.org/data/2.5"
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func getCurrentWeather() async throws -> WeatherData {
        let url = URL(string: "\(baseURL)/weather?q=Prague&appid=\(apiKey)&units=metric")!
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(OpenWeatherResponse.self, from: data)
        
        return WeatherData(
            temperature: response.main.temp,
            condition: response.weather.first?.main ?? "Unknown",
            location: response.name
        )
    }
}

// Response model matching API structure
struct OpenWeatherResponse: Codable {
    let main: Main
    let weather: [Weather]
    let name: String
    
    struct Main: Codable {
        let temp: Double
    }
    
    struct Weather: Codable {
        let main: String
    }
}
```

#### Update AppState

```swift
init(
    weatherService: WeatherServiceProtocol = LiveWeatherService(apiKey: "YOUR_API_KEY"),
    // ... other services
) {
    // ...
}
```

### 2. News Service Integration

#### Example: NewsAPI

Create `LiveNewsService.swift`:

```swift
class LiveNewsService: NewsServiceProtocol {
    private let apiKey: String
    private let baseURL = "https://newsapi.org/v2"
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func getHeadlines() async throws -> [NewsHeadline] {
        let url = URL(string: "\(baseURL)/top-headlines?country=us&apiKey=\(apiKey)")!
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(NewsAPIResponse.self, from: data)
        
        return response.articles.map { article in
            NewsHeadline(
                title: article.title,
                source: article.source.name,
                publishedAt: ISO8601DateFormatter().date(from: article.publishedAt) ?? Date()
            )
        }
    }
}

struct NewsAPIResponse: Codable {
    let articles: [Article]
    
    struct Article: Codable {
        let title: String
        let source: Source
        let publishedAt: String
        
        struct Source: Codable {
            let name: String
        }
    }
}
```

### 3. Market Service Integration

#### Example: CoinGecko + Alpha Vantage

Create `LiveMarketService.swift`:

```swift
class LiveMarketService: MarketServiceProtocol {
    private let cryptoURL = "https://api.coingecko.com/api/v3"
    private let stockAPIKey: String
    
    init(stockAPIKey: String) {
        self.stockAPIKey = stockAPIKey
    }
    
    func getMarketSnapshot() async throws -> [MarketData] {
        async let btc = fetchBitcoin()
        async let sp500 = fetchSP500()
        
        return try await [btc, sp500]
    }
    
    private func fetchBitcoin() async throws -> MarketData {
        let url = URL(string: "\(cryptoURL)/simple/price?ids=bitcoin&vs_currencies=usd&include_24hr_change=true")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode([String: CryptoPrice].self, from: data)
        
        guard let btc = response["bitcoin"] else {
            throw MarketError.noData
        }
        
        return MarketData(
            symbol: "BTC/USD",
            name: "Bitcoin",
            price: btc.usd,
            change: btc.usd * (btc.usd_24h_change / 100),
            changePercent: btc.usd_24h_change
        )
    }
    
    private func fetchSP500() async throws -> MarketData {
        // Alpha Vantage API call for S&P 500
        // Implementation details...
    }
}

struct CryptoPrice: Codable {
    let usd: Double
    let usd_24h_change: Double
}

enum MarketError: Error {
    case noData
}
```

## Configuration Management

### Create Config File

`Config.swift`:

```swift
import Foundation

struct Config {
    // API Keys
    static let weatherAPIKey = ProcessInfo.processInfo.environment["WEATHER_API_KEY"] ?? ""
    static let newsAPIKey = ProcessInfo.processInfo.environment["NEWS_API_KEY"] ?? ""
    static let stockAPIKey = ProcessInfo.processInfo.environment["STOCK_API_KEY"] ?? ""
    
    // Feature Flags
    static let useLiveData = false  // Toggle between mock and live
    
    // Network
    static let requestTimeout: TimeInterval = 10.0
    static let cachePolicy: URLRequest.CachePolicy = .reloadIgnoringLocalCacheData
}
```

### Environment Variables (Xcode)

1. Edit Scheme → Run → Arguments → Environment Variables
2. Add:
   - `WEATHER_API_KEY`: Your OpenWeather key
   - `NEWS_API_KEY`: Your NewsAPI key
   - `STOCK_API_KEY`: Your Alpha Vantage key

### Factory Pattern

Create `ServiceFactory.swift`:

```swift
struct ServiceFactory {
    static func createWeatherService() -> WeatherServiceProtocol {
        if Config.useLiveData {
            return LiveWeatherService(apiKey: Config.weatherAPIKey)
        } else {
            return MockWeatherService()
        }
    }
    
    static func createNewsService() -> NewsServiceProtocol {
        if Config.useLiveData {
            return LiveNewsService(apiKey: Config.newsAPIKey)
        } else {
            return MockNewsService()
        }
    }
    
    static func createMarketService() -> MarketServiceProtocol {
        if Config.useLiveData {
            return LiveMarketService(stockAPIKey: Config.stockAPIKey)
        } else {
            return MockMarketService()
        }
    }
}
```

Update `AppState`:

```swift
init(
    weatherService: WeatherServiceProtocol = ServiceFactory.createWeatherService(),
    newsService: NewsServiceProtocol = ServiceFactory.createNewsService(),
    marketService: MarketServiceProtocol = ServiceFactory.createMarketService()
) {
    self.weatherService = weatherService
    self.newsService = newsService
    self.marketService = marketService
}
```

## Error Handling

### Add Error States to Views

Update views to handle failures gracefully:

```swift
struct WeatherView: View {
    @State private var weatherData: WeatherData?
    @State private var isLoading = true
    @State private var error: Error?
    
    var body: some View {
        Group {
            if let weather = weatherData {
                // Display weather
            } else if isLoading {
                ProgressView()
            } else if error != nil {
                ErrorView(message: "Unable to load weather")
            }
        }
        .task {
            await loadWeather()
        }
    }
    
    private func loadWeather() async {
        do {
            weatherData = try await weatherService.getCurrentWeather()
            isLoading = false
        } catch {
            self.error = error
            isLoading = false
        }
    }
}
```

### Retry Logic

Add automatic retry with exponential backoff:

```swift
actor RetryableService<T> {
    private let maxRetries = 3
    private let baseDelay: TimeInterval = 1.0
    
    func executeWithRetry(_ operation: () async throws -> T) async throws -> T {
        var lastError: Error?
        
        for attempt in 0..<maxRetries {
            do {
                return try await operation()
            } catch {
                lastError = error
                let delay = baseDelay * pow(2.0, Double(attempt))
                try await Task.sleep(for: .seconds(delay))
            }
        }
        
        throw lastError ?? NSError(domain: "RetryFailed", code: -1)
    }
}
```

## Caching Strategy

### Add Simple Cache

Create `CachedService.swift`:

```swift
actor ServiceCache<T> {
    private var cachedValue: T?
    private var cacheTime: Date?
    private let cacheDuration: TimeInterval
    
    init(cacheDuration: TimeInterval = 300) { // 5 minutes default
        self.cacheDuration = cacheDuration
    }
    
    func get() -> T? {
        guard let cacheTime = cacheTime,
              Date().timeIntervalSince(cacheTime) < cacheDuration else {
            return nil
        }
        return cachedValue
    }
    
    func set(_ value: T) {
        cachedValue = value
        cacheTime = Date()
    }
    
    func invalidate() {
        cachedValue = nil
        cacheTime = nil
    }
}
```

### Wrap Service

```swift
class CachedWeatherService: WeatherServiceProtocol {
    private let wrappedService: WeatherServiceProtocol
    private let cache = ServiceCache<WeatherData>(cacheDuration: 600) // 10 min
    
    init(wrapping service: WeatherServiceProtocol) {
        self.wrappedService = service
    }
    
    func getCurrentWeather() async throws -> WeatherData {
        if let cached = await cache.get() {
            return cached
        }
        
        let fresh = try await wrappedService.getCurrentWeather()
        await cache.set(fresh)
        return fresh
    }
}
```

## Rate Limiting

### Throttle Requests

```swift
actor RequestThrottler {
    private var lastRequestTime: Date?
    private let minimumInterval: TimeInterval
    
    init(minimumInterval: TimeInterval = 1.0) {
        self.minimumInterval = minimumInterval
    }
    
    func throttle() async {
        if let lastTime = lastRequestTime {
            let elapsed = Date().timeIntervalSince(lastTime)
            if elapsed < minimumInterval {
                try? await Task.sleep(for: .seconds(minimumInterval - elapsed))
            }
        }
        lastRequestTime = Date()
    }
}
```

## Monitoring & Logging

### Add Telemetry

```swift
enum LogLevel {
    case debug, info, warning, error
}

struct Logger {
    static func log(_ message: String, level: LogLevel = .info, context: [String: Any] = [:]) {
        #if DEBUG
        print("[\(level)] \(message)")
        if !context.isEmpty {
            print("Context: \(context)")
        }
        #endif
        
        // In production, send to analytics service
    }
}
```

### Track API Calls

```swift
extension LiveWeatherService {
    func getCurrentWeather() async throws -> WeatherData {
        let startTime = Date()
        
        do {
            let result = try await performRequest()
            let duration = Date().timeIntervalSince(startTime)
            
            Logger.log("Weather API success", context: [
                "duration": duration,
                "location": result.location
            ])
            
            return result
        } catch {
            Logger.log("Weather API failed", level: .error, context: [
                "error": error.localizedDescription
            ])
            throw error
        }
    }
}
```

## Testing Live Services

### Create Test Doubles

```swift
class FakeWeatherService: WeatherServiceProtocol {
    var shouldFail = false
    var delayDuration: TimeInterval = 0
    var weatherToReturn = WeatherData(temperature: 20, condition: "Clear", location: "Test")
    
    func getCurrentWeather() async throws -> WeatherData {
        if delayDuration > 0 {
            try await Task.sleep(for: .seconds(delayDuration))
        }
        
        if shouldFail {
            throw NSError(domain: "TestError", code: -1)
        }
        
        return weatherToReturn
    }
}
```

### Unit Tests

```swift
import Testing

@Suite("Weather Service Tests")
struct WeatherServiceTests {
    @Test("Successful weather fetch")
    func successfulFetch() async throws {
        let service = FakeWeatherService()
        let weather = try await service.getCurrentWeather()
        #expect(weather.location == "Test")
    }
    
    @Test("Handle API failure")
    func handleFailure() async throws {
        let service = FakeWeatherService()
        service.shouldFail = true
        
        do {
            _ = try await service.getCurrentWeather()
            Issue.record("Should have thrown error")
        } catch {
            // Expected
        }
    }
}
```

## API Keys Best Practices

### Security Checklist

- ✅ Never commit API keys to Git
- ✅ Use environment variables or secure storage
- ✅ Rotate keys periodically
- ✅ Use different keys for dev/staging/production
- ✅ Monitor API usage and set up alerts
- ✅ Consider using a backend proxy for sensitive keys

### Backend Proxy (Recommended)

For production apps, proxy API calls through your own backend:

```
[tvOS App] → [Your Backend] → [External API]
```

Benefits:
- Hide API keys
- Add authentication
- Implement rate limiting
- Transform responses
- Add caching layer
- Monitor usage

## Migration Checklist

- [ ] Obtain API keys for all services
- [ ] Create live service implementations
- [ ] Add configuration management
- [ ] Implement error handling
- [ ] Add caching layer
- [ ] Test with real APIs
- [ ] Add rate limiting if needed
- [ ] Set up monitoring/logging
- [ ] Update documentation
- [ ] Deploy and monitor

## Recommended APIs

### Weather
- **OpenWeather**: https://openweathermap.org/api
  - Free tier: 1000 calls/day
  - Good documentation
  - Reliable

### News
- **NewsAPI**: https://newsapi.org
  - Free tier: 100 requests/day
  - Multiple sources
  - Good filtering

### Crypto
- **CoinGecko**: https://www.coingecko.com/en/api
  - Free, no API key required
  - Rate limit: 10-50 calls/min
  - Comprehensive data

### Stock Market
- **Alpha Vantage**: https://www.alphavantage.co
  - Free tier: 25 calls/day
  - Good for S&P 500 data
  - JSON responses

## Next Steps

1. Choose APIs and sign up for keys
2. Implement one service at a time
3. Test thoroughly with mock data first
4. Add error handling before going live
5. Monitor API usage and costs
6. Implement caching to reduce calls
7. Consider backend proxy for production
