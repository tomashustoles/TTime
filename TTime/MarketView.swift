//
//  MarketView.swift
//  TTime
//
//  Created by Tomas Hustoles on 22/1/26.
//

import SwiftUI

struct MarketView: View {
    @Environment(\.theme) private var theme
    @Environment(\.isFocused) private var isFocused
    @Environment(\.adaptiveForeground) private var foreground

    let marketService: MarketServiceProtocol
    let enabledTickers: Set<String>

    @State private var marketData: [MarketData] = []
    @State private var isLoading = true

    /// Symbols whose ticker IDs are currently enabled in settings.
    private var enabledSymbols: Set<String> {
        Set(MarketTicker.availableTickers
            .filter { enabledTickers.contains($0.id) }
            .map { $0.symbol })
    }

    private var visibleData: [MarketData] {
        marketData.filter { enabledSymbols.contains($0.symbol) }
    }

    var body: some View {
        Group {
            if !visibleData.isEmpty {
                VStack(alignment: .trailing, spacing: theme.spacing.medium) {
                    ForEach(visibleData) { data in
                        MarketItemView(data: data, isFocused: isFocused)
                    }
                }
            } else if isLoading {
                ProgressView()
                    .tint(foreground)
            }
        }
        .background {
            RoundedRectangle(cornerRadius: theme.radius.medium)
                .fill(theme.colors.background.opacity(isFocused ? 0.3 : 0.0))
        }
        .scaleEffect(isFocused ? theme.motion.focusScale : 1.0)
        .animation(.easeOut(duration: theme.motion.focusDuration), value: isFocused)
        .task {
            await loadMarketData()
        }
        .onChange(of: enabledTickers) { _, _ in
            // visibleData recomputes automatically from the stored marketData
        }
    }

    private func loadMarketData() async {
        do {
            marketData = try await marketService.getMarketSnapshot()
            isLoading = false
        } catch {
            isLoading = false
        }
    }
}

struct MarketItemView: View {
    @Environment(\.theme) private var theme
    @Environment(\.adaptiveForeground) private var foreground
    @Environment(\.adaptiveSecondaryForeground) private var secondaryForeground
    
    let data: MarketData
    let isFocused: Bool
    
    var body: some View {
        VStack(alignment: .trailing, spacing: theme.spacing.tiny) {
            Text(data.symbol)
                .font(.system(
                    size: theme.typography.standardSize,
                    weight: theme.typography.weight,
                    design: .default
                ))
                .foregroundStyle(secondaryForeground)
            
            HStack(alignment: .firstTextBaseline, spacing: theme.spacing.tiny) {
                Text(formattedPrice(data.price))
                    .font(.system(
                        size: theme.typography.standardSize,
                        weight: theme.typography.weight,
                        design: .default
                    ))
                    .foregroundStyle(isFocused ? theme.colors.accent : foreground)
                
                Text(formattedChange(data.changePercent))
                    .font(.system(
                        size: theme.typography.standardSize,
                        weight: theme.typography.weight,
                        design: .default
                    ))
                    .foregroundStyle(data.change >= 0 ? Color(hex: "429E9D") : Color(hex: "FF3300"))
            }
        }
    }
    
    private func formattedPrice(_ price: Double) -> String {
        if price > 10000 {
            return String(format: "$%.0f", price)
        } else {
            return String(format: "$%.2f", price)
        }
    }
    
    private func formattedChange(_ percent: Double) -> String {
        let sign = percent >= 0 ? "+" : ""
        return String(format: "%@%.2f%%", sign, percent)
    }
}
