# 🌦️ Sri Lanka Weather App

A feature-rich cross-platform weather application built with Flutter, providing accurate weather forecasts for Sri Lankan cities with beautiful UI and real-time alerts.


## ✨ Features

### ✅ Core Features (Coursework Requirements)
1. **📍 Location-based Weather Search** - Get weather for any Sri Lankan/international city
2. **📅 Forecast by Date** - Select specific dates for detailed forecasts
3. **⭐ Favorite Cities** - Save and manage favorite locations
4. **⚠️ Weather Alerts** - Real-time alerts for extreme conditions
5. **🌍 Filtering by Region** - Toggle between Sri Lanka and international cities
6. **📊 5-Day Forecast** - Detailed weather predictions with charts
7. **🎛️ Weather Dashboard** - Comprehensive metrics at a glance
8. **📍 Current Location** - GPS-based weather information

### 🎯 Additional Features
- **Beautiful UI** - Material Design with Sri Lankan theme colors
- **Offline Support** - Cached data and favorites storage
- **Real-time Updates** - Live weather data from OpenWeatherMap API
- **Multi-language Support** - Ready for localization
- **Responsive Design** - Works on all screen sizes

## 🏗️ Architecture

### Tech Stack
- **Framework:** Flutter 3.16.9
- **Language:** Dart 3.2.1
- **State Management:** Provider
- **Architecture:** MVVM (Model-View-ViewModel)
- **API:** OpenWeatherMap REST API
- **Database:** SharedPreferences (Local Storage)

### Project Structure


## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.16.9 or higher
- Dart 3.2.1 or higher
- Android Studio / VS Code
- OpenWeatherMap API Key (Free tier)

### Setup & Installation Guide

 ```bash
1. Clone & Setup

git clone https://github.com/yourusername/sri-lanka-weather-app.git
cd sri-lanka-weather-app
flutter pub get

2. Configure API Key

Get free API key from OpenWeatherMap

Edit lib/core/constants/app_constants.dart

Replace: static const String apiKey = 'YOUR_API_KEY_HERE';

3. Run the App

bash
# Android
flutter run

# iOS
flutter run -d iPhone

# Build APK
flutter build apk --release
