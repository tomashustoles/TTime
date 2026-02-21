//
//  TTimeApp.swift
//  TTime
//
//  Created by Tomas Hustoles on 22/1/26.
//

import SwiftUI

@main
struct TTimeApp: App {
    var body: some Scene {
        WindowGroup {
            AppRoot()
        }
    }
}

struct AppRoot: View {
    @State private var appState = AppState()

    var body: some View {
        ContentView(appState: appState)
            .theme(appState.themeStyle.theme)
            .preferredColorScheme(appState.effectiveColorScheme)
    }
}
