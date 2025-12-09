import 'package:flutter/material.dart';

class AppConstants {
  // Replace with your OpenWeatherMap API Key
  static const String apiKey = '9fb18ad0fc357aaa639fd1f736e8f869'; // Your API key
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String geoUrl = 'http://api.openweathermap.org/geo/1.0';

  // Sri Lanka Cities and Districts
  static const List<String> sriLankaCities = [
    'Colombo',
    'Kandy',
    'Galle',
    'Jaffna',
    'Negombo',
    'Trincomalee',
    'Anuradhapura',
    'Polonnaruwa',
    'Matara',
    'Ratnapura',
    'Badulla',
    'Nuwara Eliya',
    'Kurunegala',
    'Puttalam',
    'Kalutara',
    'Hambantota',
    'Batticaloa',
    'Mannar',
    'Vavuniya',
    'Kilinochchi',
    'Mullaitivu',
    'Ampara',
    'Monaragala',
  ];

  // International Cities
  static const List<String> internationalCities = [
    'London',
    'New York',
    'Tokyo',
    'Paris',
    'Sydney',
    'Dubai',
    'Singapore',
    'Mumbai',
    'Beijing',
    'Hong Kong',
  ];

  // Combined list
  static List<String> get cities => [...sriLankaCities, ...internationalCities];

  // Sri Lanka specific coordinates
  static const Map<String, Map<String, double>> sriLankaCoordinates = {
    'Colombo': {'lat': 6.9271, 'lon': 79.8612},
    'Kandy': {'lat': 7.2906, 'lon': 80.6337},
    'Galle': {'lat': 6.0329, 'lon': 80.2168},
    'Jaffna': {'lat': 9.6615, 'lon': 80.0255},
    'Negombo': {'lat': 7.2086, 'lon': 79.8358},
    'Trincomalee': {'lat': 8.5874, 'lon': 81.2152},
  };

  // Dummy data for Sri Lanka (Colombo weather)
  static Map<String, dynamic> get dummyWeatherData {
    return {
      "coord": {"lon": 79.8612, "lat": 6.9271},
      "weather": [
        {"id": 801, "main": "Clouds", "description": "scattered clouds", "icon": "03d"}
      ],
      "base": "stations",
      "main": {
        "temp": 29.0,
        "feels_like": 35.0,
        "temp_min": 28.0,
        "temp_max": 32.0,
        "pressure": 1010,
        "humidity": 77
      },
      "visibility": 10000,
      "wind": {"speed": 8.8, "deg": 120},
      "clouds": {"all": 40},
      "dt": 1620000000,
      "sys": {
        "type": 1,
        "id": 1234,
        "country": "LK",
        "sunrise": 1619971200,
        "sunset": 1620014400
      },
      "timezone": 19800,
      "id": 1248991,
      "name": "Colombo",
      "cod": 200
    };
  }

  // Colors for Sri Lanka theme
  static const Color primaryColor = Color(0xFF8D153A);
  static const Color secondaryColor = Color(0xFFFFB400);
  static const Color accentColor = Color(0xFF00534C);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color textColor = Color(0xFF333333);

  // App info
  static const String appName = 'Sri Lanka Weather';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Weather forecast for Sri Lanka and worldwide';

  // Weather tips
  static const List<String> weatherTips = [
    'Monsoon season: May to September (Southwest) & December to February (Northeast)',
    'Best time to visit: December to March for west/south, May to September for east coast',
    'Average temperature: 27°C in lowlands, 16°C in highlands',
    'Humidity is high year-round (70-90%)',
    'Carry an umbrella - sudden showers are common!',
  ];

  // Sri Lanka monsoon seasons
  static const Map<String, String> sriLankaMonsoonSeasons = {
    'Southwest': 'May to September',
    'Northeast': 'December to February',
  };

  // Weather thresholds for Sri Lanka
  static const Map<String, dynamic> weatherThresholds = {
    'high_temp': 35.0,
    'low_temp': 20.0,
    'high_humidity': 80,
    'low_humidity': 30,
    'high_wind': 10.0,
  };
}