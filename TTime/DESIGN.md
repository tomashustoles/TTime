# Time App — Layout & Design Specifications

## Screen Layout

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│  ┌──────────┐                                    ┌──────────┐  │
│  │  [icon]  │                                    │   22°C   │  │
│  │  Time    │                                    │  Partly  │  │
│  └──────────┘                                    │  Cloudy  │  │
│  App Identity                                    └──────────┘  │
│  (Menu Button)                                      Weather    │
│                                                                 │
│                                                                 │
│                                                                 │
│                         ┌─────────┐                            │
│                         │         │                            │
│                         │  14:32  │                            │
│                         │         │                            │
│                         └─────────┘                            │
│                          Clock                                 │
│                                                                 │
│                                                                 │
│                                                                 │
│  ┌──────────────────┐                         ┌────────────┐  │
│  │  News            │                         │  Markets   │  │
│  │                  │                         │            │  │
│  │  Global Leaders  │                         │  BTC/USD   │  │
│  │  Gather for...   │                         │  $45,234   │  │
│  └──────────────────┘                         │            │  │
│     News Headlines                            │  S&P 500   │  │
│                                               │  $4,789    │  │
│                                               └────────────┘  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## Typography Scale

| Element | Size | Weight | Purpose |
|---------|------|--------|---------|
| Clock | 120pt | Bold | Center focal point, maximum readability |
| Headline | 36pt | Semibold | Section headers, weather temp |
| Body | 28pt | Regular | News headlines, market prices |
| Caption | 24pt | Regular | Secondary info, labels |
| App Title | 22pt | Semibold | App identity label |

## Color Palette

### Default Theme
- **Background**: White (`#FFFFFF`)
- **Foreground**: Black (`#000000`)
- **Accent**: Pure Red (`#FF0000`) — used sparingly
- **Secondary**: Gray 30% (`#4D4D4D`)

### Accent Usage (~1%)
- Focus rings
- Active selections
- Negative market changes
- Emphasis states

## Spacing System

| Token | Value | Usage |
|-------|-------|-------|
| `tiny` | 8pt | Minimal internal spacing |
| `small` | 16pt | Component padding |
| `medium` | 24pt | Card padding |
| `large` | 32pt | Section spacing |
| `extraLarge` | 48pt | Major separations |
| `edgeInset` | 60pt | Screen edge distance |
| `cornerPadding` | 80pt | Corner element padding |

## Focus Behavior

### Interactive Elements
All focusable elements respond to tvOS Focus Engine:

| State | Transform | Color | Duration |
|-------|-----------|-------|----------|
| **Default** | scale(1.0) | Foreground (black) | — |
| **Focused** | scale(1.08) | Accent (red) | 0.2s |

### Focus Transition
```swift
.scaleEffect(isFocused ? 1.08 : 1.0)
.foregroundStyle(isFocused ? accent : foreground)
.animation(.easeOut(duration: 0.2), value: isFocused)
```

## Animation Timing

| Animation | Duration | Easing | Purpose |
|-----------|----------|--------|---------|
| Focus | 0.2s | easeOut | Scale and color change |
| Transition | 0.35s | easeInOut | View changes, navigation |
| News Flip | 0.8s | easeInOut | Headline rotation |
| Gradient | 20.0s | continuous | Background animation |

## Gradient Presets

### Calm (Default)
- Colors: Very subtle blue-white tones
- Flow: Top-leading to bottom-trailing
- Motion: Slow, organic mesh movement

### Warm
- Colors: Very subtle warm-white tones
- Flow: Top-leading to bottom-trailing
- Motion: Slow, organic mesh movement

**Note**: Gradients are extremely subtle to keep focus on content.

## Settings Panel

### Dimensions
- Width: 700pt
- Height: 600pt
- Corner Radius: 24pt
- Position: Top-left anchor

### Overlay Behavior
- Background dim: Black 40% opacity
- Shadow: 40pt blur, 20pt Y-offset
- Transition: Scale + Opacity (0.35s)

### Settings Items

```
Settings
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Temperature Unit
  ◉ Celsius    ○ Fahrenheit

Clock Timezone
  [ Current Timezone     ]

Weather Location
  [ Prague              ]

News Source
  [ World News ▾        ]

Background Gradient
  [■ Calm]  [■ Warm]
```

## Component Details

### Clock View
- Format: 24-hour (HH:mm)
- Update: Every 1 second (TimelineView)
- Font: Monospaced digits (prevents jitter)
- Alignment: Center-center

### Weather View
- Temperature: Converted based on unit setting
- Precision: Whole numbers (e.g., "22°C")
- Update: Task on appear
- Fallback: ProgressView while loading

### News View
- Headlines: One visible at a time
- Rotation: 8 seconds per headline
- Animation: Push from bottom / top
- Line Limit: 2 lines maximum
- Max Width: 600pt

### Market View
- Items: Vertical stack
- Alignment: Trailing (right-aligned)
- Price Format: 
  - > $10,000: No decimals (e.g., "$45,234")
  - < $10,000: Two decimals (e.g., "$4,789.32")
- Change Color:
  - Positive: Green
  - Negative: Red accent

## tvOS Considerations

### Safe Areas
- Overscan: Accounted for via cornerPadding
- No content within 80pt of edges
- Center content is always visible

### Focus Navigation
- Top row: Left ↔ Right (App Identity ↔ Weather)
- Bottom row: Left ↔ Right (News ↔ Markets)
- Vertical: Predictable focus movement
- Settings: Modal focus trap

### Remote Interaction
- Click/Touch: Activate focused element
- Swipe: Navigate between elements
- Menu button: Back/dismiss (in settings)
- Play/Pause: Not used

## Accessibility

### Focus Engine
- All interactive elements are focusable
- Clear focus indicators (red accent)
- Logical focus order

### Typography
- Large, bold fonts for distance viewing
- High contrast (black on white)
- Monospaced digits for stability

### Motion
- Calm, predictable animations
- No flashing or rapid movement
- Gradient animation is subtle and slow

## Extensibility Points

### Future Dashboard Tiles
Architecture supports additional tiles:
```swift
// Potential future tiles:
- Calendar events
- Photos carousel
- Music now playing
- Smart home controls
- Custom widgets
```

### Theme Switching
Easy to add new themes:
```swift
struct DarkTheme: Theme {
    let colors = ColorTokens(
        background: .black,
        foreground: .white,
        accent: .red,
        // ...
    )
    // ... rest of tokens
}
```

### Service Integration
Swap mock for live:
```swift
// Mock
let weatherService = MockWeatherService()

// Live
let weatherService = OpenWeatherService(
    apiKey: config.weatherAPIKey,
    networkClient: URLSession.shared
)
```

## Performance Notes

### Gradient Animation
- Uses MeshGradient (modern API)
- TimelineView updates on animation timeline
- GPU-accelerated
- Minimal CPU usage

### News Rotation
- Timer-based (8s intervals)
- Only animates content change
- No continuous animation

### Focus Effects
- Hardware-accelerated transforms
- Implicit animations via SwiftUI
- Negligible performance impact

## Design Philosophy

1. **Content First**: UI recedes, content is prominent
2. **Calm & Ambient**: No aggressive motion or flashy effects
3. **Distance Optimized**: Readable from couch (10+ feet)
4. **Consistent**: Design tokens ensure consistency
5. **Refined**: Apple-quality polish and attention to detail
6. **Focused**: Every element has a purpose
7. **Extensible**: Easy to add features without refactoring
