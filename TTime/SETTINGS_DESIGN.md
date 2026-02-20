# Settings Sidebar Visual Design Specification

## Layout Structure

```
┌─────────────────────────────────────────────────────────────┐
│  Dashboard (Background with gradient)                        │
│                                                               │
│  ┌─────────────────┐                                         │
│  │  SETTINGS     X │  ← Header (48pt title, close button)   │
│  ├─────────────────┤                                         │
│  │                 │                                         │
│  │  ┌───────────┐  │  ← ScrollView with cards              │
│  │  │  DESIGN   │  │                                         │
│  │  │           │  │     • Appearance Mode (segmented)      │
│  │  │  ○ ○ ○    │  │     • Background grid (3x3)            │
│  │  │  ○ ○ ○    │  │     • Animated toggle                  │
│  │  │  ○ ○ ○    │  │                                         │
│  │  └───────────┘  │                                         │
│  │                 │                                         │
│  │  ┌───────────┐  │                                         │
│  │  │   TIME    │  │     • Time format (segmented)          │
│  │  │           │  │     • Clock font (preview cards)       │
│  │  └───────────┘  │                                         │
│  │                 │                                         │
│  │  ┌───────────┐  │                                         │
│  │  │  WEATHER  │  │     • Temperature unit (segmented)     │
│  │  │           │  │     • Show location (toggle)           │
│  │  │  ⦿ Berlin │  │     • Location list (7 rows)           │
│  │  │  ○ NYC    │  │                                         │
│  │  └───────────┘  │                                         │
│  │                 │                                         │
│  │  ┌───────────┐  │                                         │
│  │  │   NEWS    │  │     • Category chips (grid)            │
│  │  │  ■ □ □    │  │                                         │
│  │  └───────────┘  │                                         │
│  │                 │                                         │
│  │  ┌───────────┐  │                                         │
│  │  │  MARKETS  │  │     • Ticker toggles (8 rows)          │
│  │  │  BTC ●━━  │  │                                         │
│  │  │  S&P ●━━  │  │                                         │
│  │  └───────────┘  │                                         │
│  │                 │                                         │
│  └─────────────────┘                                         │
│   800pt wide                                                  │
│   Full height                                                 │
│   Left-aligned                                                │
└─────────────────────────────────────────────────────────────┘
```

## Color Palette

### Light Mode (Default)
```
Background:          rgb(235, 230, 222)  // Beige (#EBE6DE)
Foreground:          rgb(0, 0, 0)        // Black
Accent:              rgb(255, 0, 0)      // Pure Red (#FF0000)
Secondary:           rgb(128, 128, 128)  // Gray (#808080)

Sidebar:             rgba(242, 242, 242, 0.98)  // Near-white
Card Background:     rgba(250, 250, 250, 0.95)  // Off-white
Card Border:         rgb(217, 217, 217)  // Light gray
Overlay:             rgba(0, 0, 0, 0.5)   // Semi-transparent black
```

### Dark Mode (Future)
```
Background:          rgb(18, 18, 18)     // Near-black
Foreground:          rgb(255, 255, 255)  // White
Accent:              rgb(255, 70, 70)    // Bright Red
Secondary:           rgb(142, 142, 147)  // iOS Gray

Sidebar:             rgba(28, 28, 30, 0.98)
Card Background:     rgba(44, 44, 46, 0.95)
Card Border:         rgb(58, 58, 60)
Overlay:             rgba(0, 0, 0, 0.7)
```

## Typography

### Hierarchy
```
Section Header (Design, Time, etc.):
  Size: 28pt
  Weight: Bold
  Color: Foreground
  Icon: 28pt (accent color)

Subsection Header (Temperature Unit, etc.):
  Size: 22pt
  Weight: Semibold
  Color: Secondary
  Case: UPPERCASE
  Tracking: 0.5pt

Body Text (button labels, row titles):
  Size: 24pt
  Weight: Semibold
  Color: Foreground

Subtitle Text (toggle descriptions):
  Size: 20pt
  Weight: Regular
  Color: Secondary

Monospace (ticker symbols):
  Size: 24pt
  Weight: Bold
  Design: Monospaced
```

## Spacing System

```
Tiny:        8pt   (between stacked elements)
Small:       16pt  (card internal padding, grid gaps)
Medium:      24pt  (section spacing, toggle padding)
Large:       32pt  (between cards)
Extra Large: 48pt  (header spacing)

Edge Inset:  60pt  (main dashboard edges)
Corner Pad:  16pt  (dashboard corner widgets)
```

## Border Radius

```
Small:       8pt   (buttons, swatches, rows)
Medium:      16pt  (cards, main containers)
Large:       24pt  (modals, large panels)
App Icon:    18pt  (iOS-style rounded squares)
```

## Component Specifications

### Segmented Control
```
Button Size:        Auto-width, 60pt height
Padding:            24pt horizontal, 16pt vertical
Selected:           Red fill (#FF0000), white text
Unselected:         Clear fill, black text, 2pt border
Focus:              1.08x scale, red glow (12pt radius)
Animation:          0.2s ease-out
```

### Toggle Switch
```
Track Size:         80pt × 44pt
Thumb Size:         36pt circle
Track Color (on):   Red (#FF0000)
Track Color (off):  Gray 30% opacity
Thumb Color:        White
Thumb Offset:       ±16pt from center
Animation:          Spring (0.3s, 0.7 damping)
```

### Background Swatch
```
Swatch Size:        140-160pt width, 80pt height
Grid Columns:       Adaptive (min 140pt)
Grid Spacing:       16pt
Border (normal):    1pt gray
Border (focused):   3pt black
Border (selected):  4pt red
Badge:              Checkmark circle (24pt) in top-right
Label:              Below swatch, 20pt semibold
```

### Location Row
```
Row Height:         Auto (min 60pt)
Padding:            24pt all sides
Icon:               24pt (location.fill or mappin.circle.fill)
Text:               24pt semibold
Checkmark:          28pt (when selected)
Background:         Card background, or 10% red tint when selected
Border:             1pt gray (normal), 3pt red (focused/selected)
```

### Category Chip
```
Chip Size:          160-200pt width, auto height
Padding:            24pt vertical, 16pt horizontal
Icon:               32pt above text
Text:               22pt below icon
Selected State:     Red fill, white text
Unselected State:   Card background, black text, 1pt border
Focus:              1.05x scale, red glow (16pt radius)
```

### Ticker Row
```
Row Height:         Auto (min 70pt)
Padding:            24pt all sides
Symbol:             24pt bold monospaced
Name:               20pt regular (below symbol)
Toggle:             80×44pt switch on right
Border:             1pt gray (normal), 3pt red (focused)
```

## Focus States

### Scale Effect
```
Normal:     1.0x (no scale)
Focused:    1.08x for buttons
            1.05x for swatches
            1.02x for rows
Duration:   0.2s ease-out
```

### Shadow & Glow
```
Normal:     No shadow
Focused:    Red glow
  - Color:  Red 30-40% opacity
  - Radius: 12-16pt depending on component
  - Offset: 0, 0 (centered glow)
```

### Border
```
Normal:     1pt gray border
Focused:    3pt red border
Selected:   4pt red border (backgrounds)
            3pt red border (rows)
```

## Animation Timings

```
Focus:              0.2s ease-out
Selection:          0.2s ease-out
Toggle:             0.3s spring (0.7 damping)
Sidebar Open:       0.35s ease-in-out
Sidebar Close:      0.35s ease-in-out
Gradient Animate:   20s continuous loop
```

## Accessibility

### Minimum Sizes
```
Touch Target:       44pt minimum (tvOS remote)
Text Size:          20pt minimum (living room viewing)
Focus Border:       3pt minimum (visible at distance)
```

### Contrast Ratios
```
Text on Background:     7:1 (AAA)
Secondary on BG:        4.5:1 (AA)
Accent on Background:   4.5:1 (AA)
Focus Indicators:       3:1 minimum
```

## Interaction Patterns

### Opening Settings
```
Method 1: Click "Settings" button (top-left corner)
  - Button scales on focus (1.08x)
  - Red accent color when focused
  - Opens with 0.35s slide-in

Method 2: Swipe left from main content
  - Focus moves to Settings button
  - Auto-opens if user presses select
  - Same slide-in animation
```

### Navigating Settings
```
Vertical:   Up/Down to move between sections
Horizontal: Left/Right within segments, grids, toggles
Select:     Activate focused control
Menu:       Close settings (or click X)
```

### Closing Settings
```
Method 1: Click X button (top-right of sidebar)
Method 2: Click outside sidebar (on dark overlay)
Method 3: Press Menu button on remote

Animation: 0.35s slide-out to left
```

## Responsive Behavior

### Sidebar Width
```
Fixed:      800pt
Height:     Full screen
Position:   Left edge, no margin
Scroll:     Vertical only, smooth scrolling
```

### Card Layout
```
Grid (backgrounds):  3 columns adaptive (min 140pt)
Grid (categories):   2-3 columns adaptive (min 160pt)
Rows (locations):    Single column, full width
Rows (tickers):      Single column, full width
```

## Layer Hierarchy

```
Z-Index (bottom to top):
1. Dashboard background (gradient)
2. Dashboard content (clock, widgets)
3. Dark overlay (50% black) ← when settings open
4. Settings sidebar (left edge) ← slides in/out
```

## State Management

### AppState Properties
```swift
// UI State
isSettingsPanelOpen: Bool  // Controls visibility

// Appearance
appearanceMode: AppearanceMode
selectedGradientIndex: Int
useAnimatedGradient: Bool

// Time
timeFormat: TimeFormat
clockFontStyle: ClockFontStyle
selectedTimezone: TimeZone

// Weather
temperatureUnit: TemperatureUnit
showWeatherLocation: Bool
weatherLocation: WeatherLocation

// News
newsCategory: NewsCategory
selectedNewsSource: NewsSource

// Markets
enabledTickers: Set<String>
```

### Persistence Keys
All settings save to UserDefaults with the same key name as the property (e.g., "temperatureUnit", "timeFormat").

## Design Inspirations

1. **Apple tvOS HIG**
   - Large touch targets
   - Clear focus states
   - Generous spacing
   - Distance-optimized typography

2. **shadcn/ui**
   - Card-based sections
   - Subtle borders and shadows
   - Clean, minimal aesthetic
   - Consistent component patterns

3. **iOS Settings App**
   - Section grouping
   - Row-based lists
   - Toggle switches
   - Hierarchical navigation

4. **Material Design**
   - Motion principles (easing, springs)
   - Elevation and depth
   - Responsive scaling
   - Focus indicators

## Implementation Notes

- All components use `@Environment(\.theme)` for design tokens
- All interactive elements use `@Environment(\.isFocused)` for focus states
- All animations use design token durations
- All colors reference theme color tokens
- Settings changes trigger immediate UserDefaults writes
- Dashboard observes AppState and reflects changes in real-time
