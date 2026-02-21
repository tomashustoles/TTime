//
//  NewsView.swift
//  TTime
//
//  Created by Tomas Hustoles on 22/1/26.
//

import SwiftUI

struct NewsView: View {
    @Environment(\.theme) private var theme
    @Environment(\.isFocused) private var isFocused
    @Environment(\.adaptiveForeground) private var foreground
    @Environment(\.adaptiveSecondaryForeground) private var secondaryForeground
    
    let newsService: NewsServiceProtocol
    
    @State private var headlines: [NewsHeadline] = []
    @State private var currentIndex: Int = 0
    @State private var isLoading = true
    @State private var rotationTimer: Timer?
    @State private var errorMessage: String?
    
    private let rotationInterval: TimeInterval = 8.0
    
    var body: some View {
        Group {
            if !headlines.isEmpty {
                VStack(alignment: .leading, spacing: theme.spacing.tiny) {
                    Text(headlines[currentIndex].source)
                        .font(.system(
                            size: theme.typography.standardSize,
                            weight: theme.typography.weight,
                            design: .default
                        ))
                        .foregroundStyle(foreground)
                    
                    Text(headlines[currentIndex].title)
                        .font(.system(
                            size: theme.typography.standardSize,
                            weight: theme.typography.weight,
                            design: .default
                        ))
                        .foregroundStyle(isFocused ? theme.colors.accent : foreground)
                        .multilineTextAlignment(.leading)
                        .id(currentIndex)
                        .transition(.asymmetric(
                            insertion: .push(from: .bottom).combined(with: .opacity),
                            removal: .push(from: .top).combined(with: .opacity)
                        ))
                }
                .frame(maxWidth: 400, alignment: .leading)
            } else if isLoading {
                ProgressView()
                    .tint(foreground)
            } else if let errorMessage = errorMessage {
                VStack(alignment: .leading, spacing: theme.spacing.tiny) {
                    Text("News")
                        .font(.system(
                            size: theme.typography.standardSize,
                            weight: theme.typography.weight,
                            design: .default
                        ))
                        .foregroundStyle(secondaryForeground)
                    
                    Text("Error: \(errorMessage)")
                        .font(.system(
                            size: theme.typography.standardSize,
                            weight: theme.typography.weight,
                            design: .default
                        ))
                        .foregroundStyle(foreground)
                }
                .frame(maxWidth: 400, alignment: .leading)
            }
        }
        .background {
            RoundedRectangle(cornerRadius: theme.radius.medium)
                .fill(theme.colors.background.opacity(isFocused ? 0.3 : 0.0))
        }
        .scaleEffect(isFocused ? theme.motion.focusScale : 1.0)
        .animation(.easeOut(duration: theme.motion.focusDuration), value: isFocused)
        .task {
            await loadHeadlines()
            startRotation()
        }
        .onDisappear {
            rotationTimer?.invalidate()
            rotationTimer = nil
        }
    }
    
    private func loadHeadlines() async {
        do {
            print("📰 Loading headlines...")
            headlines = try await newsService.getHeadlines()
            print("📰 Loaded \(headlines.count) headlines")
            isLoading = false
        } catch {
            print("❌ Error loading headlines: \(error)")
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
    
    private func startRotation() {
        guard !headlines.isEmpty else { return }
        
        rotationTimer = Timer.scheduledTimer(withTimeInterval: rotationInterval, repeats: true) { _ in
            withAnimation(.easeInOut(duration: theme.motion.newsFlipDuration)) {
                currentIndex = (currentIndex + 1) % headlines.count
            }
        }
    }
}
