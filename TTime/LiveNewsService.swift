//
//  LiveNewsService.swift
//  TTime
//
//  Created by Tomas Hustoles on 23/1/26.
//

import Foundation

class LiveNewsService: NSObject, NewsServiceProtocol, URLSessionDelegate {
    private let apiKey: String
    private let baseURL = "https://newsapi.org/v2"
    
    // Categories you can use: general, business, technology, science, health, sports, entertainment
    private let category: String
    private let country: String
    private let sources: [String]
    private var urlSession: URLSession!
    
    init(apiKey: String, category: String = "general", country: String = "us", sources: [String] = []) {
        self.apiKey = apiKey
        self.category = category
        self.country = country
        self.sources = sources
        
        super.init()
        
        // Create a custom URLSession with proper configuration
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10.0
        configuration.timeoutIntervalForResource = 30.0
        configuration.waitsForConnectivity = true
        
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
        print("🔐 [NEWS] URLSession delegate called for: \(challenge.protectionSpace.host)")
        print("🔐 [NEWS] Authentication method: \(challenge.protectionSpace.authenticationMethod)")
        
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
           let serverTrust = challenge.protectionSpace.serverTrust {
            print("✅ [NEWS] Accepting server trust for Zscaler certificate")
            let credential = URLCredential(trust: serverTrust)
            completionHandler(.useCredential, credential)
        } else {
            print("⚠️ [NEWS] Using default handling for challenge")
            completionHandler(.performDefaultHandling, nil)
        }
    }
    
    func getHeadlines() async throws -> [NewsHeadline] {
        guard !apiKey.isEmpty else {
            throw NewsError.apiKeyMissing
        }
        
        var components = URLComponents(string: "\(baseURL)/top-headlines")!
        
        // If sources are specified, use them instead of country/category
        // Note: NewsAPI doesn't allow mixing sources with country/category
        if !sources.isEmpty {
            components.queryItems = [
                URLQueryItem(name: "sources", value: sources.joined(separator: ",")),
                URLQueryItem(name: "pageSize", value: "10"),
                URLQueryItem(name: "apiKey", value: apiKey)
            ]
        } else {
            components.queryItems = [
                URLQueryItem(name: "country", value: country),
                URLQueryItem(name: "category", value: category),
                URLQueryItem(name: "pageSize", value: "10"),
                URLQueryItem(name: "apiKey", value: apiKey)
            ]
        }
        
        guard let url = components.url else {
            throw NewsError.invalidURL
        }
        
        print("📰 Requesting URL: \(url.absoluteString)")
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 10.0
        
        do {
            let (data, response) = try await urlSession.data(for: request)
        
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NewsError.invalidResponse
            }
            
            print("📰 Response status code: \(httpResponse.statusCode)")
            
            if httpResponse.statusCode == 401 {
                throw NewsError.unauthorized
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw NewsError.invalidResponse
            }
            
            let decoder = JSONDecoder()
            let apiResponse = try decoder.decode(NewsAPIResponse.self, from: data)
            
            if apiResponse.status != "ok" {
                throw NewsError.apiError(message: apiResponse.message ?? "Unknown error")
            }
            
            let dateFormatter = ISO8601DateFormatter()
            
            let headlines = apiResponse.articles
                .filter { !$0.title.contains("[Removed]") } // Filter out removed articles
                .map { article in
                    // Remove source suffix from title if present
                    var cleanTitle = article.title
                    
                    // Common patterns: " - SOURCE" or " – SOURCE" (en dash)
                    if let lastDashRange = cleanTitle.range(of: " - ", options: .backwards) {
                        cleanTitle = String(cleanTitle[..<lastDashRange.lowerBound])
                    } else if let lastEnDashRange = cleanTitle.range(of: " – ", options: .backwards) {
                        cleanTitle = String(cleanTitle[..<lastEnDashRange.lowerBound])
                    }
                    
                    return NewsHeadline(
                        title: cleanTitle,
                        source: article.source.name,
                        publishedAt: dateFormatter.date(from: article.publishedAt) ?? Date()
                    )
                }
            
            print("📰 Successfully loaded \(headlines.count) headlines")
            return headlines
            
        } catch let error as NewsError {
            print("❌ NewsError: \(error.localizedDescription)")
            throw error
        } catch {
            print("❌ Network error: \(error.localizedDescription)")
            throw NewsError.apiError(message: error.localizedDescription)
        }
    }
}

// MARK: - API Response Models

private struct NewsAPIResponse: Codable {
    let status: String
    let totalResults: Int?
    let articles: [Article]
    let message: String?
    
    struct Article: Codable {
        let source: Source
        let author: String?
        let title: String
        let description: String?
        let url: String
        let urlToImage: String?
        let publishedAt: String
        let content: String?
        
        struct Source: Codable {
            let id: String?
            let name: String
        }
    }
}

// MARK: - Errors

enum NewsError: LocalizedError {
    case invalidURL
    case invalidResponse
    case unauthorized
    case apiKeyMissing
    case apiError(message: String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid news URL"
        case .invalidResponse:
            return "Unable to fetch news"
        case .unauthorized:
            return "Invalid API key"
        case .apiKeyMissing:
            return "News API key not configured"
        case .apiError(let message):
            return "News API error: \(message)"
        }
    }
}
