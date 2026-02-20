# API Integration Setup Guide

This guide will help you connect your TTime app to real APIs for weather, news, and market data.

## 🚀 Quick Start

### 1. Get API Keys

You'll need API keys for weather and news data. Market data uses free APIs that don't require keys.

#### Weather API (OpenWeather)
1. Go to [OpenWeather API](https://openweathermap.org/api)
2. Click "Sign Up" (free tier available)
3. Verify your email
4. Go to API Keys section
5. Copy your API key

**Free Tier Limits:** 1,000 calls/day, 60 calls/minute

#### News API (NewsAPI.org)
1. Go to [NewsAPI.org](https://newsapi.org)
2. Click "Get API Key"
3. Sign up for free developer account
4. Copy your API key

**Free Tier Limits:** 100 requests/day (perfect for development)

#### Market Data (No Keys Required!)
- **CoinGecko**: Free cryptocurrency data, no key needed
- **Yahoo Finance**: Free stock market data, no key needed

### 2. Configure Xcode with API Keys

#### Option A: Environment Variables (Recommended)

1. In Xcode, click on your scheme name (next to the device selector)
2. Select "Edit Scheme..."
3. Select "Run" on the left
4. Go to "Arguments" tab
5. Under "Environment Variables", click the "+" button
6. Add these variables:

```
Name: WEATHER_API_KEY
Value: [paste your OpenWeather API key here]

Name: NEWS_API_KEY
Value: [paste your NewsAPI key here]
```

7. Click "Close"

#### Option B: Direct Configuration (Not Recommended for Production)

Edit `Config.swift` and replace the empty strings:

```swift
static let weatherAPIKey = "your_openweather_key_here"
static let newsAPIKey = "your_newsapi_key_here"
```

⚠️ **Warning:** Never commit API keys to version control!

### 3. Enable Live Data

Open `Config.swift` and change:

```swift
static let useLiveData = false
```

to:

```swift
static let useLiveData = true
```

### 4. Build and Run

1. Press `Cmd + B` to build
2. Press `Cmd + R` to run
3. Check the console for configuration status

You should see:
```
📱 TTime Configuration Status
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Mode: 🌐 LIVE

API Keys:
  Weather: ✅ Configured
  News: ✅ Configured
  Markets: ✅ No key required (using free APIs)
```

## 🎯 What's Included

### Live Services

#### ✅ LiveWeatherService
- Uses OpenWeather API
- Real-time weather data
- Temperature in Celsius
- Current conditions
- Default location: Prague (configurable)

#### ✅ LiveNewsService
- Uses NewsAPI.org
- Top headlines
- Multiple categories (general, business, technology, etc.)
- Customizable country
- Filters out removed articles

#### ✅ LiveMarketService
- CoinGecko for Bitcoin prices
- Yahoo Finance for S&P 500
- Real-time prices
- 24-hour changes
- No API key required!

### Features

- ✅ **Automatic Caching**: Reduces API calls and improves performance
- ✅ **Error Handling**: Graceful fallbacks when APIs fail
- ✅ **Timeout Protection**: 10-second timeout for all requests
- ✅ **Debug Mode**: Optional logging for API requests
- ✅ **Factory Pattern**: Easy switching between mock and live services
- ✅ **Protocol-Based**: Clean architecture, easy to extend

## ⚙️ Configuration Options

### Config.swift Settings

```swift
// Toggle between mock and live data
static let useLiveData = true

// News configuration
static let newsCategory = "general" // or "business", "technology", etc.
static let newsCountry = "us" // or "gb", "ca", "au", etc.

// Weather configuration
static let defaultWeatherLocation = "Prague"

// Network settings
static let requestTimeout: TimeInterval = 10.0
static let cacheDuration: TimeInterval = 300 // 5 minutes

// Caching
static let enableCaching = true

// Debug mode
static let debugAPIRequests = false // Set to true to see API logs
```

### Available News Categories

- `general` - Top headlines
- `business` - Business news
- `technology` - Tech news
- `science` - Science news
- `health` - Health news
- `sports` - Sports news
- `entertainment` - Entertainment news

### Available Country Codes

- `us` - United States
- `gb` - United Kingdom
- `ca` - Canada
- `au` - Australia
- `de` - Germany
- `fr` - France
- And many more (ISO 3166-1 alpha-2 codes)

## 🔧 Troubleshooting

### "API key not configured" Error

**Problem:** You see mock data even though `useLiveData = true`

**Solution:**
1. Verify API keys are set in Xcode scheme (Edit Scheme → Run → Arguments → Environment Variables)
2. Check console for missing key warnings
3. Try restarting Xcode

### Weather Data Not Loading

**Problem:** Weather shows "Unable to fetch weather data"

**Solution:**
1. Check your API key is valid at [OpenWeather Account](https://home.openweathermap.org/api_keys)
2. Verify you've activated your API key (can take a few minutes after signup)
3. Check you haven't exceeded free tier limits (1000 calls/day)
4. Try a different location in Config.swift

### News Not Loading

**Problem:** News headlines not appearing

**Solution:**
1. Verify API key at [NewsAPI Dashboard](https://newsapi.org/account)
2. Check free tier limits (100 requests/day)
3. Try different category/country settings
4. Enable debug mode: `Config.debugAPIRequests = true`

### Market Data Not Loading

**Problem:** Market prices not showing

**Solution:**
1. Check your internet connection
2. APIs might be temporarily down (no keys required, so not an auth issue)
3. Check console for specific errors
4. CoinGecko has rate limits (10-50 calls/minute)

## 📊 API Rate Limits & Caching

### Default Caching Strategy

All services use 5-minute caching by default:
- Weather: Updates every 5 minutes
- News: Updates every 5 minutes
- Markets: Updates every 5 minutes

This keeps you well within free tier limits:
- Weather: ~288 calls/day (vs 1000 limit)
- News: ~96 calls/day (vs 100 limit)
- Markets: Unlimited (free APIs)

### Customize Cache Duration

In `Config.swift`:

```swift
static let cacheDuration: TimeInterval = 300 // 5 minutes

// Or customize per service in ServiceFactory.swift:
static func createCachedWeatherService() -> WeatherServiceProtocol {
    return CachedWeatherService(
        wrapping: createWeatherService(),
        cacheDuration: 600 // 10 minutes
    )
}
```

### Disable Caching

```swift
static let enableCaching = false
```

⚠️ **Warning:** Disabling cache will use more API calls and may hit rate limits quickly!

## 🧪 Testing

### Test with Mock Data First

Keep `useLiveData = false` while developing to avoid:
- API rate limits
- Slow network delays
- API costs
- Network dependency

### Test with Live Data

1. Set `useLiveData = true`
2. Set `debugAPIRequests = true`
3. Watch console for API calls
4. Verify data is real and updates
5. Test error scenarios (disconnect network)

### Switching Between Mock and Live

```swift
// In Config.swift
static let useLiveData = false // Use mock data

// Or inject at runtime for testing
let testAppState = AppState(
    weatherService: MockWeatherService(),
    newsService: LiveNewsService(apiKey: "test"),
    marketService: MockMarketService()
)
```

## 🔒 Security Best Practices

### ✅ Do:
- Use environment variables for API keys
- Add `Config.swift` with actual keys to `.gitignore` if you hardcode them
- Use different keys for development and production
- Rotate keys periodically
- Monitor API usage in provider dashboards

### ❌ Don't:
- Commit API keys to Git
- Share keys in screenshots or demos
- Use production keys in debug builds
- Hardcode keys in source code (use environment variables)

## 🎨 Customization Examples

### Change Weather Location

```swift
// In Config.swift
static let defaultWeatherLocation = "London"
```

### Show Only Technology News

```swift
static let newsCategory = "technology"
static let newsCountry = "us"
```

### Add More Market Symbols

Edit `LiveMarketService.swift`:

```swift
func getMarketSnapshot() async throws -> [MarketData] {
    async let bitcoin = fetchBitcoin()
    async let ethereum = fetchEthereum() // Add this
    async let sp500 = fetchSP500()
    
    return try await [bitcoin, ethereum, sp500]
}
```

### Increase Cache Duration

```swift
// Cache for 15 minutes instead of 5
static let cacheDuration: TimeInterval = 900
```

## 📚 API Documentation

### OpenWeather API
- [Documentation](https://openweathermap.org/api)
- [Current Weather API](https://openweathermap.org/current)
- [API Dashboard](https://home.openweathermap.org/api_keys)

### NewsAPI
- [Documentation](https://newsapi.org/docs)
- [Top Headlines Endpoint](https://newsapi.org/docs/endpoints/top-headlines)
- [Dashboard](https://newsapi.org/account)

### CoinGecko
- [Documentation](https://www.coingecko.com/en/api/documentation)
- [Simple Price API](https://www.coingecko.com/en/api/documentation)
- No account needed!

### Yahoo Finance
- Free, no documentation or account needed
- Public API widely used
- Real-time stock quotes

## 🚀 Next Steps

1. ✅ Set up API keys
2. ✅ Enable live data
3. ✅ Test the app
4. 📝 Customize locations/categories
5. 🎨 Adjust cache settings
6. 🔒 Set up production keys
7. 📊 Monitor API usage

## 💡 Tips

- Start with mock data while developing UI
- Enable live data to test real scenarios
- Use caching to stay within free tiers
- Monitor your API usage dashboards
- Consider upgrading to paid tiers for production apps
- Use debug mode to troubleshoot API issues

## ❓ Need Help?

Check:
1. Console output for error messages
2. API provider dashboards for key status
3. This README for common issues
4. API documentation for limits and usage

Enjoy your real-time data! 🎉
