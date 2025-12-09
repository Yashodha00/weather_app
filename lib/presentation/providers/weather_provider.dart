import 'package:flutter/material.dart';
import '../../data/models/weather_model.dart';
import '../../data/models/forecast_model.dart';
import '../../data/repositories/weather_repository.dart';
import '../../services/location_service.dart';
import '../../core/utils/weather_alerts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeatherProvider with ChangeNotifier {
  // PRIVATE STATE VARIABLES
  final WeatherRepository _repository;
  final LocationService _locationService;

  WeatherModel? _currentWeather;          // Current weather data
  ForecastModel? _forecast;               // 5-day forecast data
  List<String> _favoriteCities = [];      // User's favorite cities
  String _currentCity = 'Colombo';        // Currently selected city
  bool _isLoading = false;                // Loading state indicator
  String? _error;                         // Error message (if any)
  List<String> _alerts = [];              // Weather alerts
  List<String> _tips = [];                // Weather tips
  bool _alertsEnabled = true;             // Alerts toggle state

  WeatherProvider({
    required WeatherRepository repository,
    required LocationService locationService,
  }) : _repository = repository, _locationService = locationService {
    _loadFavorites();
    _loadSettings();
    fetchWeather(_currentCity);
  }

  // PUBLIC GETTERS (READ-ONLY ACCESS)
  WeatherModel? get currentWeather => _currentWeather;
  ForecastModel? get forecast => _forecast;
  List<String> get favoriteCities => _favoriteCities;
  String get currentCity => _currentCity;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<String> get alerts => _alerts;
  List<String> get tips => _tips;
  bool get alertsEnabled => _alertsEnabled;

  Future<void> fetchWeather(String city) async {
    _isLoading = true;
    _error = null;  // CLEAR previous errors
    notifyListeners();

    try {
      _currentCity = city;  // UPDATE city
      _currentWeather = await _repository.getCurrentWeather(city);  // UPDATE weather data
      _forecast = await _repository.getWeatherForecast(city);  // UPDATE forecast
      _error = null;  // SUCCESS - no error

      if (_currentWeather != null) {
        _alerts = WeatherAlerts.checkAlerts(_currentWeather!);  // UPDATE alerts
        _tips = WeatherAlerts.getGeneralTips();
      }
    } catch (e) {
      _error = e.toString();  // ERROR - store message
      _currentWeather = null;
      _forecast = null;
      _alerts = ['⚠️ Could not fetch weather alerts. Check internet connection.'];
      _tips = WeatherAlerts.getGeneralTips();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchWeatherByLocation() async {
    _isLoading = true;   // UPDATE to loading
    notifyListeners();

    try {
      final position = await _locationService.getCurrentLocation();
      _currentWeather = await _repository.getWeatherByLocation(
        position.latitude,
        position.longitude,
      );
      _currentCity = _currentWeather?.name ?? 'Current Location';
      _forecast = await _repository.getWeatherForecast(_currentCity);
      _error = null;  // DELETE error message

      if (_currentWeather != null) {
        _alerts = WeatherAlerts.checkAlerts(_currentWeather!);
        _tips = WeatherAlerts.getGeneralTips();
      }
    } catch (e) {
      _error = e.toString();
      _alerts = ['📍 Could not get location. Enable location services.'];
      _tips = WeatherAlerts.getGeneralTips();
    } finally {
      _isLoading = false;  // UPDATE to not loading
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(String city) async {
    if (_favoriteCities.contains(city)) {
      _favoriteCities.remove(city);
    } else {
      _favoriteCities.add(city);
    }
    await _saveFavorites();          // Save to SharedPreferences
    notifyListeners();
  }

  Future<void> toggleAlerts() async {
    _alertsEnabled = !_alertsEnabled;
    await _saveSettings();
    notifyListeners();
  }

  bool isFavorite(String city) {
    return _favoriteCities.contains(city);
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    _favoriteCities = prefs.getStringList('favorite_cities') ?? [];
    notifyListeners();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _alertsEnabled = prefs.getBool('alerts_enabled') ?? true;
    notifyListeners();
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorite_cities', _favoriteCities);
  }
// Save user preferences
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('alerts_enabled', _alertsEnabled);
  }

  List<ForecastItem> getDailyForecast() {
    if (_forecast?.list == null) return [];

    final dailyForecast = <ForecastItem>[];
    final dates = <String>{};

    for (var item in _forecast!.list!) {
      final date = item.dtTxt?.split(' ')[0];
      if (date != null && !dates.contains(date)) {
        dates.add(date);
        dailyForecast.add(item);
        if (dailyForecast.length >= 5) break;
      }
    }

    return dailyForecast;
  }
}