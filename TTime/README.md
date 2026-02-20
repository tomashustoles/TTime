# Time — tvOS Dashboard App

A calm, ambient, glanceable tvOS dashboard app built with SwiftUI, designed to feel like a first-party Apple TV app.

## Features

### Dashboard Components

- **Center Clock**: Large, bold digital clock with timezone support
- **App Identity (Top-Left)**: Menu button that opens Settings panel
- **Weather (Top-Right)**: Current temperature and conditions
- **News (Bottom-Left)**: Rotating world news headlines
- **Markets (Bottom-Right)**: BTC/USD and S&P 500 snapshot

### Visual Design

- **Default Theme**: White background, bold black typography, red accent (used sparingly ~1%)
- **Animated Gradient Background**: Slow, organic mesh gradient animation
- **tvOS Focus Engine**: Full support with scale effects, focus rings, and red accents
- **Distance-optimized Typography**: Large, readable fonts designed for couch viewing
- **Calm Motion**: Smooth, Apple-like animations and transitions

### Settings Panel

Non-persistent settings UI (architecture ready for persistence):
- Temperature unit (Celsius/Fahrenheit)
- Clock timezone selection
- Weather location selection
- News source selection
- Background gradient themes

## Architecture

### Design System (`DesignSystem.swift`)

Central theme and token system:
- **Theme Protocol**: Defines all design tokens
- **ColorTokens**: Background, foreground, accent, secondary colors
- **TypographyTokens**: Font sizes and weights for all text styles
- **SpacingTokens**: Consistent spacing values throughout the app
- **RadiusTokens**: Corner radius values
- **MotionTokens**: Animation durations and scale values
- **GradientPreset**: Named gradient configurations

All visual values are tokenized — no hardcoded values in views.

### Services

Protocol-based service architecture for easy swapping:

#### Weather Service
- **Protocol**: `WeatherServiceProtocol`
- **Mock**: `MockWeatherService`
- **Model**: `WeatherData`, `TemperatureUnit`

#### News Service
- **Protocol**: `NewsServiceProtocol`
- **Mock**: `MockNewsService`
- **Model**: `NewsHeadline`, `NewsSource`

#### Market Service
- **Protocol**: `MarketServiceProtocol`
- **Mock**: `MockMarketService`
- **Model**: `MarketData`

All services use async/await and return realistic mock data.

### State Management

**AppState** (`AppState.swift`):
- Observable class managing app-wide state
- Settings preferences
- Service dependencies (protocol-based)
- UI state (settings panel visibility)

### View Components

Modular, focused view components:
- `AnimatedGradientBackground`: Mesh gradient with organic animation
- `ClockView`: Time display with timezone support
- `AppIdentityButton`: Focusable menu button
- `WeatherView`: Temperature and conditions
- `NewsView`: Auto-rotating headlines
- `MarketView`: Financial snapshot
- `SettingsPanel`: Floating settings overlay

All views:
- Use `@Environment(\.theme)` for design tokens
- Use `@Environment(\.isFocused)` for focus states
- Support tvOS Focus Engine
- Implement smooth animations

## tvOS Optimization

### Focus Engine
- All interactive elements are focusable
- Focus states use red accent color
- Subtle scale effects (1.08x)
- Smooth focus animations (0.2s duration)

### Layout
- Corner padding: 80pt for comfortable edge distance
- Spatial separation between elements
- Predictable focus navigation
- Center-anchored clock for visual hierarchy

### Motion
- Calm, organic animations
- Mesh gradient for sophisticated background motion
- News headlines rotate slowly (8s intervals)
- Settings panel with smooth overlay transitions

## Future-Ready Architecture

The app is architected to support (but does not yet implement):
- User accounts and authentication
- Paywalls and subscriptions
- Live API integration (swap mock services)
- Persistent settings (UserDefaults/CloudKit)
- Additional dashboard tiles
- Feature flags

## Data Flow

```
ContentView
    ├─ AppState (@State)
    │   ├─ Settings (temperatureUnit, timezone, etc.)
    │   ├─ Services (weatherService, newsService, marketService)
    │   └─ UI State (isSettingsPanelOpen)
    │
    ├─ Theme (@Environment)
    │   └─ Design tokens accessed by all views
    │
    └─ Child Views
        ├─ ClockView (timezone)
        ├─ WeatherView (service, temperatureUnit)
        ├─ NewsView (service)
        ├─ MarketView (service)
        └─ SettingsPanel (appState binding)
```

## Implementation Notes

### Mock Services
All services return static/simulated data. Services use protocols so real implementations can be swapped in later:

```swift
// Current (Mock)
let weatherService: WeatherServiceProtocol = MockWeatherService()

// Future (Live API)
let weatherService: WeatherServiceProtocol = LiveWeatherService(apiKey: "...")
```

### Theme Tokens
All visual values come from the theme:

```swift
@Environment(\.theme) private var theme

Text("Hello")
    .font(.system(size: theme.typography.bodySize, weight: theme.typography.bodyWeight))
    .foregroundStyle(theme.colors.foreground)
    .padding(theme.spacing.medium)
```

### Focus States
tvOS focus is handled via environment:

```swift
@Environment(\.isFocused) private var isFocused

.foregroundStyle(isFocused ? theme.colors.accent : theme.colors.foreground)
.scaleEffect(isFocused ? theme.motion.focusScale : 1.0)
```

## Color Usage

**Red accent** is used sparingly (~1%) for:
- Focus states on interactive elements
- Active selections
- Small emphasis (e.g., negative market changes)

Primary visual hierarchy relies on:
- Bold black typography on white background
- Size and weight contrast
- Spatial separation
- Subtle motion

## File Structure

```
TTime/
├── TTimeApp.swift                      # App entry point
├── ContentView.swift                   # Main dashboard layout
├── DesignSystem.swift                  # Theme and design tokens
├── AppState.swift                      # Observable app state
├── Services/
│   ├── WeatherService.swift           # Weather protocol & mock
│   ├── NewsService.swift              # News protocol & mock
│   └── MarketService.swift            # Market protocol & mock
└── Views/
    ├── AnimatedGradientBackground.swift
    ├── ClockView.swift
    ├── AppIdentityButton.swift
    ├── WeatherView.swift
    ├── NewsView.swift
    ├── MarketView.swift
    └── SettingsPanel.swift
```

## Requirements

- tvOS 18.0+
- Swift 6.0+
- SwiftUI
- Xcode 16.0+

## Next Steps

To enable live data:
1. Implement real service classes conforming to protocols
2. Add API keys and configuration
3. Update AppState to use live services
4. Add error handling UI

To enable persistence:
1. Add UserDefaults or CloudKit storage
2. Load/save settings in AppState
3. Add @AppStorage property wrappers where appropriate

## Design Philosophy

This app follows Apple's design principles:
- **Clarity**: Bold typography, clear hierarchy
- **Deference**: Content is primary, UI is secondary
- **Depth**: Layering with shadows and motion
- **Focus**: Optimized for tvOS Focus Engine
- **Polish**: Smooth animations, attention to detail
