//
//  SettingsPanel.swift
//  TTime
//
//  Created by Tomas Hustoles on 24/1/26.
//

import SwiftUI

struct SettingsPanel: View {
    @Environment(\.theme) private var theme
    @Bindable var appState: AppState

    let onClose: () -> Void

    var body: some View {
        HStack(spacing: 0) {
            VStack(spacing: 0) {

                // MARK: - Header (stays fixed)
                HStack {
                    Text("Settings")
                        .font(.title2.bold())
                    Spacer()
                    Button(action: onClose) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 4)

                // MARK: - Single scrollable area for all content
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {

                        // MARK: Theme
                        VStack(alignment: .leading, spacing: 8) {
                            Text("THEME")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.secondary)
                                .padding(.leading, 4)

                            ForEach(ThemeStyle.allCases) { style in
                                ThemeStyleCard(
                                    style: style,
                                    isSelected: appState.themeStyle == style
                                ) {
                                    withAnimation(.easeOut(duration: 0.2)) {
                                        appState.themeStyle = style
                                    }
                                }
                            }
                        }

                        // MARK: Appearance
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Appearance")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .padding(.leading, 4)

                            Picker("Appearance", selection: $appState.appearanceMode) {
                                ForEach(AppearanceMode.allCases) { mode in
                                    Text(mode.rawValue).tag(mode)
                                }
                            }
                            .pickerStyle(.segmented)
                            .labelsHidden()
                        }

                        // MARK: Markets
                        VStack(alignment: .leading, spacing: 6) {
                            Text("MARKETS")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.secondary)
                                .padding(.leading, 4)

                            let tickers = MarketTicker.availableTickers
                                .filter { $0.id == "btc-usd" || $0.id == "sp500" }
                            ForEach(tickers) { ticker in
                                HStack {
                                    Text(ticker.symbol)
                                        .font(.system(.body, design: .monospaced).bold())
                                    Spacer()
                                    Toggle("", isOn: Binding(
                                        get: { appState.enabledTickers.contains(ticker.id) },
                                        set: { enabled in
                                            if enabled { appState.enabledTickers.insert(ticker.id) }
                                            else { appState.enabledTickers.remove(ticker.id) }
                                        }
                                    ))
                                    .labelsHidden()
                                }
                                .padding(.vertical, 4)
                                .padding(.horizontal, 8)
                            }
                        }

                        // MARK: Time & Weather
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("Time")
                                Spacer()
                                Picker("", selection: $appState.timeFormat) {
                                    ForEach(TimeFormat.allCases) { format in
                                        Text(format.displayName).tag(format)
                                    }
                                }
                                .pickerStyle(.menu)
                                .labelsHidden()
                            }
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)

                            HStack {
                                Text("Weather")
                                Spacer()
                                Picker("", selection: $appState.temperatureUnit) {
                                    ForEach(TemperatureUnit.allCases) { unit in
                                        Text(unit.symbol).tag(unit)
                                    }
                                }
                                .pickerStyle(.menu)
                                .labelsHidden()
                            }
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)

                            HStack {
                                Toggle("Show Location", isOn: $appState.showWeatherLocation)
                            }
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .padding(.bottom, 24)
                }
                .scrollIndicators(.hidden)
            }
            .frame(width: 480)
            .clipShape(RoundedRectangle(cornerRadius: 32))
            .background {
                RoundedRectangle(cornerRadius: 32)
                    .fill(.ultraThinMaterial)
                    .overlay {
                        RoundedRectangle(cornerRadius: 32)
                            .strokeBorder(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.5),
                                        Color.white.opacity(0.15),
                                        Color.white.opacity(0.05)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    }
                    .shadow(color: .black.opacity(0.2), radius: 50, x: 15, y: 0)
                    .shadow(color: .white.opacity(0.05), radius: 1, x: -1, y: -1)
            }
            .padding(.vertical, 24)
            .padding(.leading, 16)

            Spacer()
        }
        .transition(.move(edge: .leading).combined(with: .opacity))
    }
}
