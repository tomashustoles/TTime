# Quick Start Guide — Time tvOS App

## Building & Running

### Requirements
- Xcode 16.0 or later
- tvOS 18.0 SDK or later
- Apple TV simulator or physical device

### Build Steps
1. Open `TTime.xcodeproj` in Xcode
2. Select tvOS device/simulator
3. Press ⌘R to build and run

## Testing the App

### tvOS Simulator Controls

| Action | Keyboard Shortcut | Mouse |
|--------|------------------|-------|
| Navigate | Arrow keys | Move cursor |
| Select (Click) | Return/Enter | Click |
| Menu/Back | Escape | — |
| Play/Pause | Space | — |

### Focus Navigation

The app has 4 focusable areas:

```
┌─────────────────────────┐
│  1. App Identity        │
│     (opens settings)    │
│                         │
│                         │
│  3. News                │
└─────────────────────────┘

┌─────────────────────────┐
│         2. Weather      │
│                         │
│                         │
│                         │
│        4. Markets       │
└─────────────────────────┘
```

Navigation flow:
- **Horizontal**: 1 ↔ 2, 3 ↔ 4
- **Vertical**: 1 ↔ 3, 2 ↔ 4

## Features to Test

### ✅ Main Dashboard
- [ ] Clock updates every second
- [ ] Weather shows temperature
- [ ] News headlines rotate every 8 seconds
- [ ] Market data displays BTC and S&P 500
- [ ] Background gradient animates smoothly

### ✅ Focus Behavior
- [ ] Each corner element responds to focus
- [ ] Red accent appears on focused items
- [ ] Subtle scale effect (1.08x) on focus
- [ ] Smooth transitions between elements

### ✅ Settings Panel
- [ ] Opens when selecting App Identity button
- [ ] Floats in top-left corner
- [ ] Background dims (40% opacity)
- [ ] Clicking outside dismisses panel
- [ ] Settings are navigable with focus
- [ ] Temperature unit toggle works
- [ ] Gradient preview buttons work

### ✅ Animations
- [ ] Gradient background moves organically
- [ ] News flip animation is smooth
- [ ] Settings panel scales in/out
- [ ] Focus animations feel polished

## Customization

### Change Mock Data

Edit the mock services to test different scenarios:

**Weather** (`WeatherService.swift`):
```swift
return WeatherData(
    temperature: 25.0,      // Change temperature
    condition: "Sunny",     // Change condition
    location: "New York"    // Change location
)
```

**News** (`NewsService.swift`):
```swift
// Add/modify headlines in the array
NewsHeadline(
    title: "Your custom headline",
    source: "Your Source",
    publishedAt: Date()
)
```

**Markets** (`MarketService.swift`):
```swift
MarketData(
    symbol: "BTC/USD",
    name: "Bitcoin",
    price: 50000.00,        // Change price
    change: 2500.00,        // Change delta
    changePercent: 5.26     // Change percentage
)
```

### Change Theme Colors

Edit `DesignSystem.swift`:

```swift
struct DefaultTheme: Theme {
    let colors = ColorTokens(
        background: .white,                          // Main background
        foreground: .black,                          // Text color
        accent: Color(red: 1.0, green: 0.0, blue: 0.0),  // Focus color
        secondaryForeground: Color(white: 0.3),     // Secondary text
        focusRing: Color(red: 1.0, green: 0.0, blue: 0.0)
    )
    // ...
}
```

### Adjust Typography Sizes

```swift
let typography = TypographyTokens(
    clockSize: 120,        // Larger = bigger clock
    headlineSize: 36,      // Weather temperature, etc.
    bodySize: 28,          // News, market prices
    captionSize: 24,       // Labels, secondary info
    appTitleSize: 22       // "Time" label
)
```

### Modify Spacing

```swift
let spacing = SpacingTokens(
    tiny: 8,
    small: 16,
    medium: 24,
    large: 32,
    extraLarge: 48,
    edgeInset: 60,
    cornerPadding: 80      // Smaller = elements closer to edges
)
```

### Change Animation Speed

```swift
let motion = MotionTokens(
    focusScale: 1.08,                  // Focus scale effect
    focusDuration: 0.2,                // Focus animation speed
    transitionDuration: 0.35,          // Settings open/close
    newsFlipDuration: 0.8,             // News headline flip
    gradientAnimationDuration: 20.0    // Background movement
)
```

### Add New Gradient

In `DesignSystem.swift`:

```swift
let gradients: [GradientPreset] = [
    // Existing gradients...
    
    GradientPreset(
        id: "cool",
        name: "Cool",
        colors: [
            Color(red: 0.95, green: 0.97, blue: 1.0),
            Color(red: 0.93, green: 0.95, blue: 0.98),
            Color(red: 0.94, green: 0.96, blue: 0.99)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
]
```

## Common Issues

### Clock Not Updating
- Check that TimelineView is receiving updates
- Ensure timezone is valid
- Try restarting the simulator

### Focus Not Working
- Verify `.focusable()` modifier is applied
- Check focus navigation logic
- Try pressing Tab to cycle focus

### Gradient Not Animating
- MeshGradient requires iOS 18+ / tvOS 18+
- Check TimelineView is receiving timeline updates
- Try simplifying animation if performance is poor

### Settings Panel Won't Open
- Check `appState.isSettingsPanelOpen` state
- Verify button action is triggering
- Look for animation issues

## Performance Tips

### Optimization Checklist
- [ ] Use `.monospacedDigit()` for clock (prevents jitter)
- [ ] Limit news headline line count to 2
- [ ] Cache weather/market data (see INTEGRATION.md)
- [ ] Use `id()` modifier for news transition
- [ ] Keep gradient animation subtle

### Monitoring Performance
```swift
// Add to any view
.onAppear {
    print("View appeared")
}
.task {
    let start = Date()
    // Do work
    let duration = Date().timeIntervalSince(start)
    print("Task took \(duration)s")
}
```

## Next Steps

### Immediate Enhancements
1. Add more news headlines to mock service
2. Experiment with different gradient colors
3. Try different typography scales
4. Test on physical Apple TV if available

### Prepare for Live Data
1. Read `INTEGRATION.md`
2. Sign up for API keys
3. Create live service implementations
4. Test with real data

### Add Persistence
1. Use `@AppStorage` for simple settings
2. Implement UserDefaults wrapper
3. Sync via iCloud/CloudKit if needed

### Polish & Refinement
1. Add sound effects for interactions
2. Implement custom focus effects
3. Add haptic feedback (if applicable)
4. Fine-tune animation curves

## Troubleshooting

### Build Errors

**"Cannot find type 'Observable'"**
- Ensure deployment target is tvOS 18.0+
- Check Swift version is 6.0+

**MeshGradient not available**
- Requires tvOS 18.0+
- Fallback to LinearGradient if needed

### Runtime Issues

**App crashes on launch**
- Check mock service implementations
- Verify all @State/@Bindable properties initialized
- Look at Xcode console for errors

**Layout looks wrong**
- Verify device is tvOS (not iOS)
- Check corner padding values
- Test on different screen sizes

## Resources

- **Apple Documentation**: https://developer.apple.com/tvos/
- **SwiftUI for tvOS**: https://developer.apple.com/documentation/swiftui
- **Focus Engine**: https://developer.apple.com/design/human-interface-guidelines/focus-and-selection

## Getting Help

Check these files for detailed information:
- `README.md` — Architecture overview
- `DESIGN.md` — Design specifications
- `INTEGRATION.md` — API integration guide

## Demo Script

To showcase the app:

1. **Launch app** — Show ambient gradient and layout
2. **Navigate focus** — Demonstrate focus engine (arrow keys)
3. **Show clock** — Center-stage time display
4. **Visit weather** — Focus top-right corner
5. **Watch news rotate** — Wait 8 seconds for flip
6. **Check markets** — BTC and S&P 500 data
7. **Open settings** — Click App Identity button
8. **Change gradient** — Select different background
9. **Toggle temperature** — Switch Celsius ↔ Fahrenheit
10. **Close settings** — Click outside or X button

The app demonstrates:
- ✅ Clean, Apple-quality design
- ✅ Smooth focus navigation
- ✅ Ambient, calm experience
- ✅ Professional polish
- ✅ tvOS-optimized layout
