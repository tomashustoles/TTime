//
//  ClockView.swift
//  TTime
//
//  Created by Tomas Hustoles on 22/1/26.
//

import SwiftUI

struct ClockView: View {
    @Environment(\.theme) private var theme
    let timezone: TimeZone
    
    var body: some View {
        TimelineView(.periodic(from: .now, by: 1.0)) { timeline in
            // Time display with hours and minutes
            HStack(spacing: 0) {
                // Hours
                Text(formatHours(timeline.date))
                    .font(.system(
                        size: theme.typography.clockSize,
                        weight: theme.typography.clockWeight,
                        design: .default
                    ))
                    .foregroundStyle(theme.colors.foreground)
                    .monospacedDigit()
                    .tracking(theme.typography.clockSize * -0.04) // Tighter tracking for bold display type
                    .shadow(color: .black.opacity(0.15), radius: 3, x: 0, y: 2)
                    .shadow(color: .black.opacity(0.25), radius: 12, x: 0, y: 6)
                    .shadow(color: .black.opacity(0.15), radius: 30, x: 0, y: 15)
                
                // Colon - optical spacing
                Text(":")
                    .font(.system(
                        size: theme.typography.clockSize,
                        weight: theme.typography.clockWeight,
                        design: .default
                    ))
                    .foregroundStyle(theme.colors.foreground)
                    .offset(y: theme.typography.clockSize * -0.05) // Optical vertical adjustment
                    .padding(.horizontal, theme.typography.clockSize * 0.05) // Balanced horizontal rhythm
                    .shadow(color: .black.opacity(0.15), radius: 3, x: 0, y: 2)
                    .shadow(color: .black.opacity(0.25), radius: 12, x: 0, y: 6)
                
                // Minutes
                Text(formatMinutes(timeline.date))
                    .font(.system(
                        size: theme.typography.clockSize,
                        weight: theme.typography.clockWeight,
                        design: .default
                    ))
                    .foregroundStyle(theme.colors.foreground)
                    .monospacedDigit()
                    .tracking(theme.typography.clockSize * -0.04) // Matching hours tracking
                    .shadow(color: .black.opacity(0.15), radius: 3, x: 0, y: 2)
                    .shadow(color: .black.opacity(0.25), radius: 12, x: 0, y: 6)
                    .shadow(color: .black.opacity(0.15), radius: 30, x: 0, y: 15)
            }
        }
    }
    
    private func formatHours(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = timezone
        formatter.dateFormat = "HH"
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
