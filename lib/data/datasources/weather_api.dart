import 'dart:convert';
import 'dart:io';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/network_helper.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class WeatherApi {
  final http.Client client;

  WeatherApi({required this.client});

  Future<WeatherModel> getCurrentWeather(String city) async {
    final hasInternet = await NetworkHelper.checkInternetConnection();
    if (!hasInternet) {
      throw SocketException('No internet connection');
    }
    // API call using http package
    try {
      final response = await client.get(
        Uri.parse(
          '${AppConstants.baseUrl}/weather?q=$city&appid=${AppConstants.apiKey}&units=metric',
        ),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        // Parse JSON response
        return weatherModelFromJson(response.body);
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API Key. Please check your OpenWeatherMap API key.');
      } else if (response.statusCode == 404) {
        throw Exception('City "$city" not found. Try a different city name.');
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } on SocketException catch (e) {
      throw Exception('No internet connection. Please check your network.');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
// Other methods using http
  Future<ForecastModel> getWeatherForecast(String city) async {
    final hasInternet = await NetworkHelper.checkInternetConnection();
    if (!hasInternet) {
      throw SocketException('No internet connection');
    }

    try {
      final response = await client.get(
        Uri.parse(
          '${AppConstants.baseUrl}/forecast?q=$city&appid=${AppConstants.apiKey}&units=metric&cnt=40',
        ),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return forecastModelFromJson(response.body);
      } else {
        throw Exception('Failed to load forecast: ${response.statusCode}');
      }
    } on SocketException catch (e) {
      throw Exception('No internet connection');
    } catch (e) {
      throw Exception('Failed to load forecast data: $e');
    }
  }

  Future<WeatherModel> getWeatherByLocation(double lat, double lon) async {
    final hasInternet = await NetworkHelper.checkInternetConnection();
    if (!hasInternet) {
      throw SocketException('No internet connection');
    }

    try {
      final response = await client.get(
        Uri.parse(
          '${AppConstants.baseUrl}/weather?lat=$lat&lon=$lon&appid=${AppConstants.apiKey}&units=metric',
        ),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return weatherModelFromJson(response.body);
      } else {
        throw Exception('Failed to load location weather: ${response.statusCode}');
      }
    } on SocketException catch (e) {
      throw Exception('No internet connection');
    } catch (e) {
      throw Exception('Failed to load location weather: $e');
    }
  }
}