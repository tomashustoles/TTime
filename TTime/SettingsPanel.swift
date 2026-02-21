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

                // MARK: - Header
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

                // MARK: - Theme Section (outside Form to avoid row scaling on tvOS)
                VStack(alignment: .leading, spacing: 14) {

                    Text("THEME")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)

                    HStack(spacing: 10) {
                        ForEach(ThemeStyle.allCases) { style in
                            ThemeStyleCard(
                                style: style,
                                isSelected: appState.themeStyle == style
                            ) {
                                withAnimation(.easeOut(duration: 0.2)) {
                                    appState.themeStyle = style
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }

                    // Appearance
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Appearance")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        Picker("Appearance", selection: $appState.appearanceMode) {
                            ForEach(AppearanceMode.allCases) { mode in
                                Text(mode.rawValue).tag(mode)
                            }
                        }
                        .pickerStyle(.segmented)
                        .labelsHidden()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)

                // MARK: - Form (Markets + Time & Weather only)
                Form {

                    // MARK: Markets
                    Section {
                        ForEach(
                            MarketTicker.availableTickers.filter { $0.id == "btc-usd" || $0.id == "sp500" }
                        ) { ticker in
                            Toggle(isOn: Binding(
                                get: { appState.enabledTickers.contains(ticker.id) },
                                set: { enabled in
                                    if enabled {
                                        appState.enabledTickers.insert(ticker.id)
                                    } else {
                                        appState.enabledTickers.remove(ticker.id)
                                    }
                                }
                            )) {
                                Text(ticker.symbol)
                                    .font(.system(.body, design: .monospaced).bold())
                            }
                        }
                    } header: {
                        Text("Markets")
                    }

                    // MARK: Time & Weather
                    Section {
                        Picker("Time", selection: $appState.timeFormat) {
                            ForEach(TimeFormat.allCases) { format in
                                Text(format.displayName).tag(format)
                            }
                        }
                        .pickerStyle(.navigationLink)

                        Picker("Weather", selection: $appState.temperatureUnit) {
                            ForEach(TemperatureUnit.allCases) { unit in
                                Text(unit.symbol).tag(unit)
                            }
                        }
                        .pickerStyle(.navigationLink)

                        Toggle("Show Location", isOn: $appState.showWeatherLocation)

                        Picker("Location", selection: $appState.weatherLocation) {
                            ForEach(WeatherLocation.allCases) { location in
                                Text(location.displayName).tag(location)
                            }
                        }
                        .pickerStyle(.navigationLink)
                    } header: {
                        Text("Time & Weather")
                    }
                }
                .formStyle(.grouped)
                .padding(.horizontal, 12)
                #if !os(tvOS)
                .scrollContentBackground(.hidden)
                #endif
                .scrollClipDisabled()
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
