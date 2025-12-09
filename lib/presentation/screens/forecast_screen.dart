import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/forecast_card.dart';
import '../../core/constants/app_constants.dart';

class ForecastScreen extends StatelessWidget {
  const ForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final forecastItems = weatherProvider.forecast?.list ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('5-Day Forecast'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: forecastItems.isEmpty
          ? const Center(child: Text('No forecast data available'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: forecastItems.length,
        itemBuilder: (context, index) {
          return ForecastCard(forecast: forecastItems[index]);
        },
      ),
    );
  }
}