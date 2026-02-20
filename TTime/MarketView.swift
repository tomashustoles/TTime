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
    
    let marketService: MarketServiceProtocol
    
    @State private var marketData: [MarketData] = []
    @State private var isLoading = true
    
    var body: some View {
        Group {
            if !marketData.isEmpty {
                VStack(alignment: .trailing, spacing: theme.spacing.medium) {
                    ForEach(marketData) { data in
                        MarketItemView(data: data, isFocused: isFocused)
                    }
                }
            } else if isLoading {
                ProgressView()
                    .tint(theme.colors.foreground)
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
                .foregroundStyle(theme.colors.secondaryForeground)
            
            HStack(alignment: .firstTextBaseline, spacing: theme.spacing.tiny) {
                Text(formattedPrice(data.price))
                    .font(.system(
                        size: theme.typography.standardSize,
                        weight: theme.typography.weight,
                        design: .default
                    ))
                    .foregroundStyle(isFocused ? theme.colors.accent : theme.colors.foreground)
                
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
