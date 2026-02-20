//
//  NewsService.swift
//  TTime
//
//  Created by Tomas Hustoles on 22/1/26.
//

import Foundation

// MARK: - Models

struct NewsHeadline: Identifiable {
    let id = UUID()
    let title: String
    let source: String
    let publishedAt: Date
}

enum NewsSource: String, CaseIterable, Identifiable {
    case world = "World News"
    case technology = "Technology"
    case business = "Business"
    case bbc = "BBC News"
    case cnn = "CNN"
    case reuters = "Reuters"
    case apNews = "AP News"
    case theGuardian = "The Guardian"
    
    var id: String { rawValue }
}

// MARK: - Protocol

protocol NewsServiceProtocol {
    func getHeadlines() async throws -> [NewsHeadline]
}

// MARK: - Mock Implementation

@Observable
class MockNewsService: NewsServiceProtocol {
    func getHeadlines() async throws -> [NewsHeadline] {
        // Simulate network delay
        try await Task.sleep(for: .milliseconds(100))
        
        return [
            NewsHeadline(
                title: "Global Leaders Gather for Climate Summit in Geneva",
                source: "World News",
                publishedAt: Date()
            ),
            NewsHeadline(
                title: "New Breakthrough in Quantum Computing Announced",
                source: "Technology",
                publishedAt: Date()
            ),
            NewsHeadline(
                title: "Markets Rally on Positive Economic Data",
                source: "Business",
                publishedAt: Date()
            ),
            NewsHeadline(
                title: "International Space Station Prepares for New Module",
                source: "Science",
                publishedAt: Date()
            ),
            NewsHeadline(
                title: "Renewable Energy Investments Reach Record Levels",
                source: "Environment",
                publishedAt: Date()
            )
        ]
    }
}
