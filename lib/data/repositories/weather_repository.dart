import '../datasources/weather_api.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';

class WeatherRepository {
  final WeatherApi weatherApi;

  WeatherRepository({required this.weatherApi});

  Future<WeatherModel> getCurrentWeather(String city) async {
    return await weatherApi.getCurrentWeather(city);
  }

  Future<ForecastModel> getWeatherForecast(String city) async {
    return await weatherApi.getWeatherForecast(city);
  }

  Future<WeatherModel> getWeatherByLocation(double lat, double lon) async {
    return await weatherApi.getWeatherByLocation(lat, lon);
  }
}