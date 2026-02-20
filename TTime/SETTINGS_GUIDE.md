# Settings Sidebar Implementation Guide

## Overview

The Settings sidebar is a comprehensive, tvOS-optimized control panel that follows Apple's Human Interface Guidelines while incorporating the clean, card-based aesthetic of shadcn/ui design patterns. It provides a cohesive, beautiful interface for managing all aspects of the TTime dashboard.

## Architecture

### Core Components

1. **SettingsPanel.swift** - Main container view with scrollable card-based layout
2. **SettingsControls.swift** - Reusable tvOS-optimized UI controls
3. **SettingsModels.swift** - All settings-related enums and data structures
4. **AppState.swift** - Observable state management with UserDefaults persistence

### Design System Integration

All settings components use the centralized design tokens from `DesignSystem.swift`:
- Color tokens (including new card-specific colors)
- Typography tokens (consistent font sizing)
- Spacing tokens (systematic padding and margins)
- Radius tokens (rounded corners)
- Motion tokens (animation durations and scales)

## Settings Sections

### 1. Design Section

**Appearance Mode**
- Two-option segmented control: Light / Dark
- Immediate visual feedback with smooth cross-fade
- Future: Preview tile showing mode change

**Background Selection**
- Grid of gradient swatches (9 presets)
- Includes solid colors and animated gradients:
  - Classic White (default radial gradient)
  - Calm (soft blues)
  - Warm (peachy tones)
  - Aurora Night (cool blues and purples)
  - Sunset Fade (warm oranges and pinks)
  - Neon Pulse (saturated accent gradients)
  - Charcoal (dark neutral)
  - Deep Blue (navy tones)
  - Muted Teal (seafoam greens)
  
**Animated Gradient Toggle**
- Switch to enable/disable mesh gradient animation
- Slow, subtle motion optimized for TV viewing
- Uses Metal-shader-driven MeshGradient

### 2. Time Section

**Time Format**
- Segmented control: 12-hour (AM/PM) / 24-hour
- Clear labeling for international users

**Clock Font**
- Two preview cards showing Standard vs. Monospaced
- Live preview with "12:34" sample
- Monospaced option maintains consistent digit width

### 3. Weather Section

**Temperature Unit**
- Segmented control: Celsius (°C) / Fahrenheit (°F)

**Show Location Toggle**
- Switch to show/hide city name
- Subtitle: "Displays city name under temperature"

**Location Source**
- Vertical list of location rows:
  - Current Location (uses device location)
  - Berlin
  - New York City
  - Tokyo
  - London
  - Paris
  - Sydney
- Icon differentiation (location.fill for Current Location, mappin.circle.fill for cities)
- Clear visual selection state

### 4. News Section

**Category Selection**
- Grid of category chips (7 categories)
- Each chip shows:
  - Category icon (newspaper, cpu, chart, etc.)
  - Category name
  - Bold fill when selected
- Categories:
  - General
  - Technology
  - Business
  - Science
  - Health
  - Sports
  - Entertainment

### 5. Markets Section

**Ticker Selection**
- Vertical list of toggle rows (8 tickers)
- Pre-selected: BTC/USD, S&P 500
- Available tickers:
  - Bitcoin (BTC/USD)
  - S&P 500
  - NASDAQ
  - Dow Jones
  - Ethereum (ETH/USD)
  - Apple Inc. (AAPL)
  - Tesla (TSLA)
  - Gold
- Each row shows:
  - Ticker symbol (monospaced font)
  - Display name
  - Toggle switch

## tvOS Optimization

### Focus Engine Integration

All interactive elements support Focus Engine:
- Clear focus states with scale effects (1.08x)
- Red accent color for focused elements
- Smooth animations (0.2s duration)
- Subtle shadows and glows on focus

### Typography

- Large, legible text (24pt standard size)
- Bold and semibold weights for hierarchy
- High contrast against backgrounds
- Optimized for 10+ foot viewing distance

### Touch & Remote Navigation

- Directional navigation (up/down/left/right)
- Logical focus order (top to bottom)
- Swipe left from main content to open Settings
- Click Settings button in top-left corner
- Click outside sidebar to dismiss
- Large tap targets (minimum 44pt height)

### Motion Design

- Smooth slide-in from left edge
- Semi-transparent backdrop (50% black)
- Easing animations (.easeInOut, .easeOut)
- Parallax-style layering
- Subtle scaling on focus
- Spring animations for toggles

## Custom Controls

### TVSegmentedControl
- Flexible generic implementation
- Supports any enum with RawValue == String
- Custom display name mapping
- Bold text for selected option
- Red fill for selection

### TVToggle
- Custom toggle switch design
- Animated sliding circle
- Red accent when enabled
- Supports title and subtitle
- Large, thumb-friendly size

### BackgroundSwatchButton
- Gradient preview thumbnail
- Selected checkmark badge
- Name label below swatch
- Focus glow effect
- 140-160pt width (adaptive grid)

### ClockFontStyleButton
- Live font preview
- Sample text: "12:34"
- Card-based layout
- Preview background for contrast
- Selection border (red, 4pt)

### LocationRowButton
- Icon + text + checkmark layout
- Location icon for current location
- Map pin for city presets
- Filled background when selected
- Subtle accent tint

### NewsCategoryChip
- Icon above text layout
- Filled red when selected
- White text on selection
- Icon remains visible
- Grid layout (adaptive)

### TickerToggleRow
- Symbol in monospace font
- Display name subtitle
- Toggle switch on right
- Consistent row height
- Supports multi-selection

## Persistence

All settings are automatically persisted to UserDefaults:

```swift
// Appearance
appearanceMode: String
selectedGradientIndex: Int
useAnimatedGradient: Bool

// Time
timeFormat: String
clockFontStyle: String
selectedTimezone: String

// Weather
temperatureUnit: String
showWeatherLocation: Bool
weatherLocation: String

// News
newsCategory: String
selectedNewsSource: String

// Markets
enabledTickers: [String]
```

Settings are loaded on app launch and immediately reflected in the dashboard UI.

## Usage in Dashboard

### Opening Settings

```swift
// Button in top-left corner
AppIdentityButton {
    withAnimation(.easeInOut(duration: theme.motion.transitionDuration)) {
        appState.isSettingsPanelOpen.toggle()
    }
}

// Or via swipe left (handled by Focus Engine)
```

### Closing Settings

```swift
// Click X button
// Click outside sidebar (on overlay)
// Both trigger:
withAnimation(.easeInOut(duration: theme.motion.transitionDuration)) {
    appState.isSettingsPanelOpen = false
}
```

### Reading Settings in Views

```swift
// In ClockView
let format = appState.timeFormat
let font = appState.clockFontStyle

// In WeatherView
let unit = appState.temperatureUnit
let showLocation = appState.showWeatherLocation
let location = appState.weatherLocation

// In NewsView
let category = appState.newsCategory

// In MarketView
let tickers = appState.enabledTickers
```

## Accessibility

- All controls keyboard/remote navigable
- Clear focus indicators (3pt borders)
- High contrast text and backgrounds
- Logical tab order
- Descriptive labels and subtitles
- VoiceOver support (via native SwiftUI)

## Future Enhancements

1. **Appearance Mode Preview**
   - Small preview tile showing light/dark mode
   - Live update as user selects

2. **Timezone Picker**
   - Modal or inline picker
   - Search/filter by city or offset
   - Popular timezones at top

3. **Custom Ticker Input**
   - Add custom market symbols
   - Validate against API
   - Reorder ticker priority

4. **News Source per Category**
   - Different sources for different categories
   - Multi-source aggregation

5. **Widget Visibility Toggles**
   - Hide/show individual dashboard cards
   - Rearrange card positions
   - Save multiple layouts

6. **Theme Creator**
   - Custom gradient builder
   - Color picker for solid backgrounds
   - Save custom presets

## Testing

### Manual Testing Checklist

- [ ] Settings opens with left swipe
- [ ] Settings opens with button click
- [ ] Settings closes with X button
- [ ] Settings closes with outside click
- [ ] All segments respond to focus
- [ ] All toggles animate smoothly
- [ ] Background swatches show preview
- [ ] Font preview renders correctly
- [ ] Location list scrolls properly
- [ ] Category chips grid adapts
- [ ] Ticker toggles work independently
- [ ] Settings persist across launches
- [ ] Dashboard reflects changes immediately
- [ ] Focus order is logical
- [ ] All animations are smooth
- [ ] Text is legible from distance

### Automated Testing

```swift
import Testing

@Suite("Settings Panel Tests")
struct SettingsPanelTests {
    
    @Test("Settings persist to UserDefaults")
    func testSettingsPersistence() async throws {
        let appState = AppState()
        
        appState.temperatureUnit = .fahrenheit
        appState.timeFormat = .twentyFourHour
        
        let savedUnit = UserDefaults.standard.string(forKey: "temperatureUnit")
        let savedFormat = UserDefaults.standard.string(forKey: "timeFormat")
        
        #expect(savedUnit == "Fahrenheit (°F)")
        #expect(savedFormat == "24-hour")
    }
    
    @Test("Market tickers support multi-selection")
    func testTickerSelection() async throws {
        let appState = AppState()
        
        appState.enabledTickers = ["btc-usd", "sp500", "eth-usd"]
        
        #expect(appState.enabledTickers.count == 3)
        #expect(appState.enabledTickers.contains("btc-usd"))
    }
}
```

## Performance Considerations

- Lazy loading for gradient previews
- Efficient UserDefaults writes (only on change)
- Smooth animations (60 FPS target)
- Minimal re-renders (focused state management)
- ScrollView virtualization for long lists

## Credits

Design inspired by:
- Apple tvOS Human Interface Guidelines
- shadcn/ui component library
- Material Design motion principles
- iOS Settings app patterns
