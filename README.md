Here is the English translation of your project description:

---

# Jewelry Store — iOS SwiftUI Application

## 📱 Overview
Brief description: SwiftUI application for a jewelry store with a catalog, authentication, Face ID, push notifications, WidgetKit widget, and a support form via Telegram.

## ✨ Features
- Catalog with category filtering
- Registration / login with SwiftData
- Face ID lock (banking scenario: cold start → Face ID, background >15s → re-lock)
- Favorites, theme/font/currency settings
- Push notifications via APNs, SwiftData history
- Notification Center (swipe-to-delete, mark as read)
- Contact Support → Node.js server → Telegram Bot
- WidgetKit widget with the latest notification

## 🏗 Architecture
- SwiftUI + iOS 17+ (MapKit, SwiftData)
- @Observable instead of ObservableObject
- MVVM (ViewModels), service layer (Services)
- @AppStorage for settings, UserDefaults(suiteName:) for shared data with the widget
- DI via EnvironmentValues

## 📁 Project Structure
(core directories)
```
Jewelry_store_project/
├── App/            # RootView, AppContainer, BiometricLock
├── Models/         # SwiftData and Codable models
├── Services/       # AuthManager, NotificationService, ProductCatalog
├── ViewModels/     # MVVM logic
├── Views/          # Auth, Home, Catalog, Profile, Notifications
├── Components/     # Reusable UI components
├── Navigation/     # DeepLink, MainTab, routes
├── Settings/       # Theme, Currency, FontSize enums
├── Theme/          # AppTheme (adaptive colors)
├── Managers/       # AppChromeState
└── Views/Widget/   # WidgetDataSync (App Group)

JewelryNotificationsWidget/  # WidgetKit extension
server/                      # Node.js Telegram Bot API
```

## 🚀 Quick Start
1. Open .xcodeproj in Xcode 16+
2. Select the Jewelry_store_project scheme
3. Configure Signing & Capabilities:
   - Main App: App Groups group.com.jewelrystore
   - Widget: App Groups group.com.jewelrystore
   - Same Team for both targets
4. Cmd+R on device (iOS 17+)

## 📩 Push Notifications
Payload:
```json
{
  "type": "product",
  "id": "...",
  "title": "...",
  "body": "...",
  "notification_type": "offer|order|update"
}
```

Setup: APNs key in Apple Developer → Capability Push Notifications.

## 🌐 Backend (Support via Telegram)
`server/support.js` — Express POST /api/v1/support

Setup:
```
cd server && cp .env.example .env
# Fill in TELEGRAM_BOT_TOKEN, TELEGRAM_CHAT_ID
npm install && node support.js
```
Listens on 0.0.0.0:5678.

## 🧩 Widget
- systemSmall, StaticConfiguration + TimelineProvider
- Reads last_title / last_body from UserDefaults(suiteName:)
- Updated via WidgetCenter.shared.reloadTimelines
- App Group entitlements are mandatory

## 🔐 Configuration
- ATS: NSAllowsArbitraryLoads = YES (dev server over HTTP)
- Face ID: NSFaceIDUsageDescription
- App Transport Security configured in Jewelry-store-project-Info.plist

## 🛠 Requirements
- Xcode 16+, iOS 17+
- Node.js 18+ (for the server)
- Apple Developer Program (push + App Groups)
