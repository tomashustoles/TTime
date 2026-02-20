//
//  AppIdentityButton.swift
//  TTime
//
//  Created by Tomas Hustoles on 22/1/26.
//

import SwiftUI

struct AppIdentityButton: View {
    @Environment(\.theme) private var theme
    @Environment(\.isFocused) private var isFocused
    
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 2) {
                Text(currentDayOfWeek)
                    .font(.system(
                        size: theme.typography.standardSize,
                        weight: theme.typography.weight,
                        design: .default
                    ))
                    .foregroundStyle(theme.colors.foreground)
                
                Text(currentDayAndMonth)
                    .font(.system(
                        size: theme.typography.standardSize,
                        weight: theme.typography.weight,
                        design: .default
                    ))
                    .foregroundStyle(theme.colors.foreground)
                
                Text(currentYear)
                    .font(.system(
                        size: theme.typography.standardSize,
                        weight: theme.typography.weight,
                        design: .default
                    ))
                    .foregroundStyle(theme.colors.foreground)
            }
            .padding(theme.spacing.small)
            .background {
                RoundedRectangle(cornerRadius: theme.radius.medium)
                    .fill(theme.colors.background.opacity(isFocused ? 0.3 : 0.0))
            }
            .scaleEffect(isFocused ? theme.motion.focusScale : 1.0)
            .animation(.easeOut(duration: theme.motion.focusDuration), value: isFocused)
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Date Formatting
    
    private var currentDayOfWeek: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE" // Full day name
        return formatter.string(from: Date())
    }
    
    private var currentDayAndMonth: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d. MMMM" // Day number, dot, full month name
        return formatter.string(from: Date())
    }
    
    private var currentYear: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy" // Four-digit year
        return formatter.string(from: Date())
    }
}
