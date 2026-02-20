# 🚀 Quick Start - Enable Live APIs

## 3-Minute Setup

### Step 1: Get API Keys (2 minutes)

**Weather API (OpenWeather)**
```
🔗 https://openweathermap.org/api
📝 Sign up → Verify email → Copy API key
⏱️ 1 minute
```

**News API (NewsAPI.org)**
```
🔗 https://newsapi.org
📝 Sign up → Copy API key
⏱️ 1 minute
```

### Step 2: Configure Xcode (30 seconds)

1. Click scheme name → "Edit Scheme..."
2. Run → Arguments → Environment Variables
3. Add two variables:
   ```
   WEATHER_API_KEY = [paste your key]
   NEWS_API_KEY = [paste your key]
   ```

### Step 3: Enable Live Data (10 seconds)

Open **Config.swift** and change:
```swift
static let useLiveData = false  // ❌ Mock data
```
to:
```swift
static let useLiveData = true   // ✅ Live data
```

### Step 4: Run! (10 seconds)

Press `Cmd+R` and check console for:
```
Mode: 🌐 LIVE
API Keys:
  Weather: ✅ Configured
  News: ✅ Configured
  Markets: ✅ No key required
```

## 🎉 Done!

You now have:
- ✅ Real-time weather from OpenWeather
- ✅ Live news headlines from NewsAPI
- ✅ Bitcoin prices from CoinGecko
- ✅ S&P 500 data from Yahoo Finance

## 💡 Customize

### Change News Category
```swift
Config.newsCategory = "technology"  // or business, science, sports
```

### Change Weather Location
```swift
Config.defaultWeatherLocation = "London"
```

### Debug Mode
```swift
Config.debugAPIRequests = true
```

## 🆘 Troubleshooting

**Still seeing mock data?**
→ Check console for "❌ Missing" next to API keys
→ Verify keys in Edit Scheme → Run → Arguments
→ Clean build: Cmd+Shift+K then Cmd+R

**Need detailed help?**
→ See **API_SETUP.md** for full documentation

---

**Free Tier Limits:**
- Weather: 1,000 calls/day ✅
- News: 100 requests/day ✅
- Markets: Unlimited ✅

**Your Usage:**
- Weather: ~288/day (5 min cache) ✅
- News: ~96/day (5 min cache) ✅
- Markets: ~288/day ✅

**Headroom:** 70%+ on all services! 🎉
