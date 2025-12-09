import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/datasources/weather_api.dart';
import 'data/repositories/weather_repository.dart';
import 'presentation/providers/weather_provider.dart';
import 'services/location_service.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/weather_detail_screen.dart';
import 'presentation/screens/forecast_screen.dart';
import 'presentation/screens/favorites_screen.dart';
import 'presentation/screens/settings_screen.dart';
import 'presentation/screens/date_forecast_screen.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Setting up Provider for state management
        Provider<WeatherApi>(
          create: (_) => WeatherApi(client: http.Client()),
        ),
        Provider<WeatherRepository>(
          create: (context) => WeatherRepository(
            weatherApi: context.read<WeatherApi>(),
          ),
        ),
        Provider<LocationService>(
          create: (_) => LocationService(),
        ),
        ChangeNotifierProvider<WeatherProvider>(
          create: (context) => WeatherProvider(
            repository: context.read<WeatherRepository>(),
            locationService: context.read<LocationService>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Sri Lanka Weather',
        theme: ThemeData(
          primaryColor: const Color(0xFF8D153A),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF8D153A),
            foregroundColor: Colors.white,
          ),
        ),
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}