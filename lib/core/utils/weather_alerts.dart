import '../../data/models/weather_model.dart';
import '../constants/app_constants.dart';

class WeatherAlerts {
  static List<String> checkAlerts(WeatherModel weather) {
    final alerts = <String>[];

    if (weather.main != null) {
      final temp = weather.main!.temp ?? 0;
      final humidity = weather.main!.humidity ?? 0;
      final windSpeed = weather.wind?.speed ?? 0;

      // Temperature alerts
      if (temp > AppConstants.weatherThresholds['high_temp']) {
        alerts.add('🌡️ High Temperature Alert: ${temp.round()}°C - Stay hydrated!');
      } else if (temp < AppConstants.weatherThresholds['low_temp']) {
        alerts.add('❄️ Cool Weather: ${temp.round()}°C - Wear warm clothes');
      }

      // Humidity alerts
      if (humidity > AppConstants.weatherThresholds['high_humidity']) {
        alerts.add('💧 High Humidity: $humidity% - Very humid conditions');
      } else if (humidity < AppConstants.weatherThresholds['low_humidity']) {
        alerts.add('🏜️ Low Humidity: $humidity% - Dry air, stay hydrated');
      }

      // Wind alerts
      if (windSpeed > AppConstants.weatherThresholds['high_wind']) {
        alerts.add('💨 Strong Winds: ${windSpeed.toStringAsFixed(1)} m/s - Be cautious');
      }

      // Weather condition alerts
      if (weather.weather != null && weather.weather!.isNotEmpty) {
        final condition = weather.weather!.first.main?.toLowerCase() ?? '';
        final description = weather.weather!.first.description?.toLowerCase() ?? '';

        if (condition.contains('thunderstorm')) {
          alerts.add('⚡ Thunderstorm Alert - Stay indoors!');
        }

        if (condition.contains('rain') || description.contains('rain')) {
          alerts.add('🌧️ Rain Alert - Carry an umbrella');

          if (description.contains('heavy') || description.contains('intense')) {
            alerts.add('⚠️ Heavy Rain Warning - Possible flooding');
          }
        }
      }
    }

    // Sri Lanka specific alerts
    final city = weather.name?.toLowerCase() ?? '';
    if (city.contains('colombo') || city.contains('galle') || city.contains('matara')) {
      alerts.add('🇱🇰 Southwest Monsoon Season: ${AppConstants.sriLankaMonsoonSeasons['Southwest']}');
    } else if (city.contains('trinco') || city.contains('batticaloa') || city.contains('jaffna')) {
      alerts.add('🇱🇰 Northeast Monsoon Season: ${AppConstants.sriLankaMonsoonSeasons['Northeast']}');
    }

    return alerts;
  }

  static List<String> getGeneralTips() {
    return [
      '🇱🇰 Sri Lanka Tip: Always carry an umbrella - rain can come suddenly!',
      '🌡️ Temperature Tip: Drink plenty of water in hot weather',
      '👕 Clothing Tip: Wear light cotton clothes in humid conditions',
      '🚗 Travel Tip: Check weather before traveling to hill country',
      '🌅 Best Time: Visit Sri Lanka Dec-Mar (west/south), May-Sep (east)',
    ];
  }
}