//
//  ServiceFactory.swift
//  TTime
//
//  Created by Tomas Hustoles on 23/1/26.
//

import Foundation

/// Factory for creating service instances
/// Automatically switches between mock and live implementations based on Config
struct ServiceFactory {
    
    /// Create weather service instance
    static func createWeatherService() -> WeatherServiceProtocol {
        if Config.useLiveData {
            if Config.weatherAPIKey.isEmpty {
                print("⚠️ Weather API key not configured, falling back to mock service")
                return MockWeatherService()
            }
            return LiveWeatherService(apiKey: Config.weatherAPIKey)
        } else {
            return MockWeatherService()
        }
    }
    
    /// Create news service instance
    static func createNewsService() -> NewsServiceProtocol {
        if Config.useLiveData {
            if Config.newsAPIKey.isEmpty {
                print("⚠️ News API key not configured, falling back to mock service")
                return MockNewsService()
            }
            return LiveNewsService(
                apiKey: Config.newsAPIKey,
                category: Config.newsCategory,
                country: Config.newsCountry,
                sources: Config.newsSources
            )
        } else {
            return MockNewsService()
        }
    }
    
    /// Create market service instance
    static func createMarketService() -> MarketServiceProtocol {
        if Config.useLiveData {
            return LiveMarketService()
        } else {
            return MockMarketService()
        }
    }
}

// MARK: - Cached Service Wrappers

extension ServiceFactory {
    
    /// Create weather service with caching enabled
    static func createCachedWeatherService() -> WeatherServiceProtocol {
        let baseService = createWeatherService()
        
        if Config.enableCaching {
            return CachedWeatherService(
                wrapping: baseService,
                cacheDuration: Config.cacheDuration
            )
        }
        
        return baseService
    }
    
    /// Create news service with caching enabled
    static func createCachedNewsService() -> NewsServiceProtocol {
        let baseService = createNewsService()
        
        if Config.enableCaching {
            return CachedNewsService(
                wrapping: baseService,
                cacheDuration: Config.cacheDuration
            )
        }
        
        return baseService
    }
    
    /// Create market service with caching enabled
    static func createCachedMarketService() -> MarketServiceProtocol {
        let baseService = createMarketService()
        
        if Config.enableCaching {
            return CachedMarketService(
                wrapping: baseService,
                cacheDuration: Config.cacheDuration
            )
        }
        
        return baseService
    }
}

// MARK: - Cached Service Implementations

/// Wraps weather service with caching
class CachedWeatherService: WeatherServiceProtocol {
    private let wrappedService: WeatherServiceProtocol
    private let cache: ServiceCache<WeatherData>
    
    init(wrapping service: WeatherServiceProtocol, cacheDuration: TimeInterval) {
        self.wrappedService = service
        self.cache = ServiceCache(cacheDuration: cacheDuration)
    }
    
    func getCurrentWeather() async throws -> WeatherData {
        if let cached = await cache.get() {
            if Config.debugAPIRequests {
                print("🔄 Using cached weather data")
            }
            return cached
        }
        
        if Config.debugAPIRequests {
            print("🌐 Fetching fresh weather data")
        }
        
        let fresh = try await wrappedService.getCurrentWeather()
        await cache.set(fresh)
        return fresh
    }
}

/// Wraps news service with caching
class CachedNewsService: NewsServiceProtocol {
    private let wrappedService: NewsServiceProtocol
    private let cache: ServiceCache<[NewsHeadline]>
    
    init(wrapping service: NewsServiceProtocol, cacheDuration: TimeInterval) {
        self.wrappedService = service
        self.cache = ServiceCache(cacheDuration: cacheDuration)
    }
    
    func getHeadlines() async throws -> [NewsHeadline] {
        if let cached = await cache.get() {
            if Config.debugAPIRequests {
                print("🔄 Using cached news data")
            }
            return cached
        }
        
        if Config.debugAPIRequests {
            print("🌐 Fetching fresh news data")
        }
        
        let fresh = try await wrappedService.getHeadlines()
        await cache.set(fresh)
        return fresh
    }
}

/// Wraps market service with caching
class CachedMarketService: MarketServiceProtocol {
    private let wrappedService: MarketServiceProtocol
    private let cache: ServiceCache<[MarketData]>
    
    init(wrapping service: MarketServiceProtocol, cacheDuration: TimeInterval) {
        self.wrappedService = service
        self.cache = ServiceCache(cacheDuration: cacheDuration)
    }
    
    func getMarketSnapshot() async throws -> [MarketData] {
        if let cached = await cache.get() {
            if Config.debugAPIRequests {
                print("🔄 Using cached market data")
            }
            return cached
        }
        
        if Config.debugAPIRequests {
            print("🌐 Fetching fresh market data")
        }
        
        let fresh = try await wrappedService.getMarketSnapshot()
        await cache.set(fresh)
        return fresh
    }
}

// MARK: - Service Cache

/// Generic cache for service responses
actor ServiceCache<T> {
    private var cachedValue: T?
    private var cacheTime: Date?
    private let cacheDuration: TimeInterval
    
    init(cacheDuration: TimeInterval) {
        self.cacheDuration = cacheDuration
    }
    
    func get() -> T? {
        guard let cacheTime = cacheTime,
              Date().timeIntervalSince(cacheTime) < cacheDuration,
              let value = cachedValue else {
            return nil
        }
        return value
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
