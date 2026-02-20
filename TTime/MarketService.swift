//
//  MarketService.swift
//  TTime
//
//  Created by Tomas Hustoles on 22/1/26.
//

import Foundation

// MARK: - Models

struct MarketData: Identifiable {
    let id = UUID()
    let symbol: String
    let name: String
    let price: Double
    let change: Double
    let changePercent: Double
}

// MARK: - Protocol

protocol MarketServiceProtocol {
    func getMarketSnapshot() async throws -> [MarketData]
}

// MARK: - Mock Implementation

@Observable
class MockMarketService: MarketServiceProtocol {
    func getMarketSnapshot() async throws -> [MarketData] {
        // Simulate network delay
        try await Task.sleep(for: .milliseconds(100))
        
        return [
            MarketData(
                symbol: "BTC/USD",
                name: "Bitcoin",
                price: 45234.50,
                change: 1234.50,
                changePercent: 2.8
            ),
            MarketData(
                symbol: "S&P 500",
                name: "S&P 500",
                price: 4789.32,
                change: -12.45,
                changePercent: -0.26
            )
        ]
    }
}
