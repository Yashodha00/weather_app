import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/weather_card.dart';
import '../widgets/forecast_card.dart';
import '../widgets/search_bar.dart';
import '../widgets/city_selection_dialog.dart';
import 'favorites_screen.dart';
import 'forecast_screen.dart';
import 'weather_detail_screen.dart';
import 'settings_screen.dart';
import 'date_forecast_screen.dart';
import '../../core/constants/app_constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showSriLankaCities = true;

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final alertsCount = weatherProvider.alerts.length;
    final hasAlerts = alertsCount > 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sri Lanka Weather'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(
                  hasAlerts ? Icons.notifications_active : Icons.notifications,
                  color: hasAlerts ? Colors.yellow : Colors.white,
                ),
                onPressed: () {
                  _showAlertsDialog(context, weatherProvider);
                },
              ),
              if (hasAlerts)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$alertsCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DateForecastScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(
              _showSriLankaCities ? Icons.flag : Icons.public,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _showSriLankaCities = !_showSriLankaCities;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.list, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => CitySelectionDialog(
                  currentCity: weatherProvider.currentCity,
                  onCitySelected: (city) {
                    weatherProvider.fetchWeather(city);
                  },
                  showSriLankaCities: _showSriLankaCities,
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoritesScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.location_on, color: Colors.white),
            onPressed: () {
              weatherProvider.fetchWeatherByLocation();
            },
          ),
        ],
      ),
      body: _buildBody(context, weatherProvider),
      drawer: _buildDrawer(context, weatherProvider),
    );
  }

  void _showAlertsDialog(BuildContext context, WeatherProvider weatherProvider) {
    final alerts = weatherProvider.alerts;
    final alertsEnabled = weatherProvider.alertsEnabled;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Weather Alerts'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Show Alerts'),
                Switch(
                  value: alertsEnabled,
                  onChanged: (value) {
                    weatherProvider.toggleAlerts();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            if (alerts.isNotEmpty)
              Column(
                children: alerts
                    .map((alert) => ListTile(
                  leading: const Icon(Icons.warning, color: Colors.orange),
                  title: Text(alert),
                ))
                    .toList(),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, WeatherProvider weatherProvider) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppConstants.primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sri Lanka Weather',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                const SizedBox(height: 8),
                Text(
                  'Current: ${weatherProvider.currentCity}',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Forecast by Date'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DateForecastScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, WeatherProvider weatherProvider) {
    if (weatherProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (weatherProvider.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64),
            const SizedBox(height: 16),
            Text('Error: ${weatherProvider.error}'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => weatherProvider.fetchWeather('Colombo'),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (weatherProvider.currentWeather == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud, size: 80),
            const SizedBox(height: 24),
            const Text('Sri Lanka Weather'),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => weatherProvider.fetchWeather('Colombo'),
              child: const Text('Get Started'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          // Search Bar
          SearchBarWidget(
            onSearch: (city) => weatherProvider.fetchWeather(city),
          ),

          // Current Weather Card
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: WeatherCard(
              weather: weatherProvider.currentWeather!,
              cityName: weatherProvider.currentCity,
            ),
          ),

          // Favorite Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                weatherProvider.toggleFavorite(weatherProvider.currentCity);
              },
              icon: Icon(
                weatherProvider.isFavorite(weatherProvider.currentCity)
                    ? Icons.favorite
                    : Icons.favorite_border,
              ),
              label: Text(
                weatherProvider.isFavorite(weatherProvider.currentCity)
                    ? 'Remove Favorite'
                    : 'Add to Favorites',
              ),
            ),
          ),

          // City Selection Toggle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Chip(
                  label: Text(
                    _showSriLankaCities ? 'Sri Lanka Cities' : 'International Cities',
                  ),
                  backgroundColor: AppConstants.primaryColor.withOpacity(0.1),
                  labelStyle: TextStyle(color: AppConstants.primaryColor),
                ),
              ],
            ),
          ),

          // SIMPLIFIED City List - NO OVERFLOW
          _buildSimpleCityList(context, weatherProvider),

          // Weather Dashboard
          _buildWeatherDashboard(weatherProvider),

          // 5-Day Forecast Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '5-Day Forecast',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ForecastScreen(),
                                  ),
                                );
                              },
                              child: const Row(
                                children: [
                                  Text('View All'),
                                  SizedBox(width: 4),
                                  Icon(Icons.arrow_forward, size: 16),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.calendar_today, size: 20),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const DateForecastScreen(),
                                  ),
                                );
                              },
                              tooltip: 'Forecast by Date',
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...weatherProvider.getDailyForecast().take(3).map(
                          (forecast) => ForecastCard(forecast: forecast),
                    ),
                    const SizedBox(height: 8),
                    if (weatherProvider.getDailyForecast().length > 3)
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ForecastScreen(),
                              ),
                            );
                          },
                          child: const Text('+ Show More'),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // SIMPLE CITY LIST - NO OVERFLOW
  Widget _buildSimpleCityList(BuildContext context, WeatherProvider weatherProvider) {
    final cities = _showSriLankaCities
        ? AppConstants.sriLankaCities
        : AppConstants.internationalCities;

    return SizedBox(
      height: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
            child: Text(
              _showSriLankaCities ? 'Sri Lanka Cities' : 'International Cities',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: cities.length,
              itemBuilder: (context, index) {
                final city = cities[index];
                final isSelected = city == weatherProvider.currentCity;

                // Determine colors based on whether we're showing Sri Lanka or International cities
                final Color primaryColor = _showSriLankaCities ? AppConstants.primaryColor : Colors.blue;
                final Color backgroundColor = isSelected ? primaryColor.withOpacity(0.2) : Colors.transparent;
                final Color iconColor = isSelected ? primaryColor : Colors.grey;
                final Color textColor = isSelected ? primaryColor : Colors.black;

                return GestureDetector(
                  onTap: () => weatherProvider.fetchWeather(city),
                  child: Container(
                    width: 80,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: backgroundColor,
                          child: Icon(
                            _showSriLankaCities ? Icons.flag : Icons.public,
                            color: iconColor,
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          city.length > 8 ? '${city.substring(0, 7)}..' : city,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // WEATHER DASHBOARD
  Widget _buildWeatherDashboard(WeatherProvider weatherProvider) {
    final weather = weatherProvider.currentWeather;
    if (weather == null) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Weather Dashboard',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                childAspectRatio: 0.9,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children: [
                  _buildDashboardItem(
                    icon: Icons.thermostat,
                    label: 'Temp',
                    value: '${weather.main?.temp?.round() ?? 0}°C',
                    color: Colors.orange,
                  ),
                  _buildDashboardItem(
                    icon: Icons.water_drop,
                    label: 'Humidity',
                    value: '${weather.main?.humidity ?? 0}%',
                    color: Colors.blue,
                  ),
                  _buildDashboardItem(
                    icon: Icons.air,
                    label: 'Wind',
                    value: '${weather.wind?.speed?.toStringAsFixed(1) ?? 0} m/s',
                    color: Colors.green,
                  ),
                  _buildDashboardItem(
                    icon: Icons.compress,
                    label: 'Pressure',
                    value: '${weather.main?.pressure ?? 0} hPa',
                    color: Colors.purple,
                  ),
                  _buildDashboardItem(
                    icon: Icons.remove_red_eye,
                    label: 'Visibility',
                    value: '${(weather.visibility ?? 0) ~/ 1000} km',
                    color: Colors.teal,
                  ),
                  _buildDashboardItem(
                    icon: Icons.cloud,
                    label: 'Clouds',
                    value: '${weather.clouds?.all ?? 0}%',
                    color: Colors.grey,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}