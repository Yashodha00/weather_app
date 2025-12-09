import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/presentation/providers/weather_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late WeatherProvider weatherProvider;

  setUp(() async {
    await Hive.initFlutter();
    await Hive.openBox('favorites_test');
    await Hive.openBox('settings_test');

    weatherProvider = WeatherProvider();
  });

  tearDown(() async {
    await Hive.box('favorites_test').clear();
    await Hive.box('settings_test').clear();
  });

  group('WeatherProvider Tests', () {
    test('Initial state is correct', () {
      expect(weatherProvider.isLoading, false);
      expect(weatherProvider.error, '');
      expect(weatherProvider.favoriteCities, isEmpty);
      expect(weatherProvider.isCelsius, true);
    });

    test('Toggle temperature unit', () {
      expect(weatherProvider.isCelsius, true);
      weatherProvider.toggleTemperatureUnit();
      expect(weatherProvider.isCelsius, false);
    });

    test('Toggle notifications', () {
      expect(weatherProvider.notificationsEnabled, true);
      weatherProvider.toggleNotifications();
      expect(weatherProvider.notificationsEnabled, false);
    });
  });
}