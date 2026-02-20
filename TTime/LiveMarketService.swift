//
//  LiveMarketService.swift
//  TTime
//
//  Created by Tomas Hustoles on 23/1/26.
//

import Foundation

class LiveMarketService: NSObject, MarketServiceProtocol, URLSessionDelegate {
    private let cryptoBaseURL = "https://api.coingecko.com/api/v3"
    private let stockBaseURL = "https://query1.finance.yahoo.com/v8/finance/chart"
    private var urlSession: URLSession!
    
    override init() {
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
        print("🔐 [MARKET] URLSession delegate called for: \(challenge.protectionSpace.host)")
        print("🔐 [MARKET] Authentication method: \(challenge.protectionSpace.authenticationMethod)")
        
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
           let serverTrust = challenge.protectionSpace.serverTrust {
            print("✅ [MARKET] Accepting server trust for Zscaler certificate")
            let credential = URLCredential(trust: serverTrust)
            completionHandler(.useCredential, credential)
        } else {
            print("⚠️ [MARKET] Using default handling for challenge")
            completionHandler(.performDefaultHandling, nil)
        }
    }
    
    func getMarketSnapshot() async throws -> [MarketData] {
        // Fetch both crypto and stock data concurrently
        async let bitcoin = fetchBitcoin()
        async let sp500 = fetchSP500()
        
        do {
            let btc = try await bitcoin
            let stock = try await sp500
            return [btc, stock]
        } catch {
            // If one fails, return what we can
            if let btc = try? await fetchBitcoin() {
                return [btc]
            }
            throw error
        }
    }
    
    private func fetchBitcoin() async throws -> MarketData {
        let url = URL(string: "\(cryptoBaseURL)/simple/price?ids=bitcoin&vs_currencies=usd&include_24hr_change=true")!
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 10.0
        
        let (data, response) = try await urlSession.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw MarketError.invalidResponse
        }
        
        let decoder = JSONDecoder()
        let prices = try decoder.decode([String: CryptoPrice].self, from: data)
        
        guard let btcData = prices["bitcoin"] else {
            throw MarketError.noData
        }
        
        let price = btcData.usd
        let changePercent = btcData.usd_24h_change
        let change = price * (changePercent / 100)
        
        return MarketData(
            symbol: "BTC/USD",
            name: "Bitcoin",
            price: price,
            change: change,
            changePercent: changePercent
        )
    }
    
    private func fetchSP500() async throws -> MarketData {
        // Using Yahoo Finance API for S&P 500 (^GSPC)
        let symbol = "%5EGSPC" // URL encoded ^GSPC
        let url = URL(string: "\(stockBaseURL)/\(symbol)")!
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 10.0
        
        let (data, response) = try await urlSession.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw MarketError.invalidResponse
        }
        
        let decoder = JSONDecoder()
        let chartResponse = try decoder.decode(YahooFinanceResponse.self, from: data)
        
        guard let result = chartResponse.chart.result.first,
              let meta = result.meta,
              let currentPrice = meta.regularMarketPrice,
              let previousClose = meta.previousClose else {
            throw MarketError.noData
        }
        
        let change = currentPrice - previousClose
        let changePercent = (change / previousClose) * 100
        
        return MarketData(
            symbol: "S&P 500",
            name: "S&P 500",
            price: currentPrice,
            change: change,
            changePercent: changePercent
        )
    }
}

// MARK: - API Response Models

private struct CryptoPrice: Codable {
    let usd: Double
    let usd_24h_change: Double
}

private struct YahooFinanceResponse: Codable {
    let chart: Chart
    
    struct Chart: Codable {
        let result: [Result]
        let error: String?
        
        struct Result: Codable {
            let meta: Meta?
            
            struct Meta: Codable {
                let regularMarketPrice: Double?
                let previousClose: Double?
                let currency: String?
            }
        }
    }
}

// MARK: - Errors

enum MarketError: LocalizedError {
    case invalidResponse
    case noData
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Unable to fetch market data"
        case .noData:
            return "No market data available"
        case .decodingError:
            return "Failed to decode market data"
        }
    }
}
