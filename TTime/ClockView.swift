//
//  ClockView.swift
//  TTime
//
//  Created by Tomas Hustoles on 22/1/26.
//

import SwiftUI

struct ClockView: View {
    @Environment(\.theme) private var theme
    @Environment(\.adaptiveForeground) private var foreground
    let timezone: TimeZone
    let timeFormat: TimeFormat
    
    // A single, very subtle contact shadow — just enough to lift text off the background.
    private var shadowColor: Color {
        foreground == .white ? .black.opacity(0.18) : .black.opacity(0.07)
    }

    var body: some View {
        TimelineView(.periodic(from: .now, by: 1.0)) { timeline in
            HStack(spacing: 0) {
                Text(formatHours(timeline.date))
                    .font(theme.clockFont(at: theme.typography.clockSize))
                    .foregroundStyle(foreground)
                    .monospacedDigit()
                    .tracking(theme.typography.clockSize * theme.typography.clockTracking)
                    .fixedSize()
                    .shadow(color: shadowColor, radius: 6, x: 0, y: 2)

                Text(":")
                    .font(theme.clockFont(at: theme.typography.clockSize))
                    .foregroundStyle(foreground)
                    .offset(y: theme.typography.clockSize * -0.05)
                    .padding(.horizontal, theme.typography.clockSize * 0.05)
                    .shadow(color: shadowColor, radius: 6, x: 0, y: 2)

                Text(formatMinutes(timeline.date))
                    .font(theme.clockFont(at: theme.typography.clockSize))
                    .foregroundStyle(foreground)
                    .monospacedDigit()
                    .tracking(theme.typography.clockSize * theme.typography.clockTracking)
                    .fixedSize()
                    .shadow(color: shadowColor, radius: 6, x: 0, y: 2)
            }
        }
    }
    
    private func formatHours(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = timezone
        formatter.dateFormat = timeFormat == .twelveHour ? "h" : "HH"
        return formatter.string(from: date)
    }
    
    private func formatMinutes(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = timezone
        formatter.dateFormat = "mm"
        return formatter.string(from: date)
    }
    
    private func formatSeconds(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = timezone
        formatter.dateFormat = "ss"
        return formatter.string(from: date)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = timezone
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: date)
    }
}
