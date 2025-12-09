import 'package:flutter/material.dart';
import '../../data/models/forecast_model.dart';
import 'package:intl/intl.dart';

class ForecastCard extends StatelessWidget {
  final ForecastItem forecast;
  final bool showDate;
  final bool showTime;

  const ForecastCard({
    super.key,
    required this.forecast,
    this.showDate = true,
    this.showTime = true,
  });

  @override
  Widget build(BuildContext context) {
    final date = forecast.dtTxt != null
        ? DateFormat('EEEE, MMM d').format(DateTime.parse(forecast.dtTxt!))
        : '';
    final time = forecast.dtTxt != null
        ? DateFormat('h:mm a').format(DateTime.parse(forecast.dtTxt!))
        : '';
    final temp = forecast.main?.temp?.round();
    final icon = forecast.weather?.first.icon;
    final condition = forecast.weather?.first.description;

    // Determine time of day for icon color
    final hour = forecast.dtTxt != null
        ? DateTime.parse(forecast.dtTxt!).hour
        : 12;
    final isDaytime = hour >= 6 && hour < 18;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Time/Date Column
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showDate)
                    Text(
                      date,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  if (showTime)
                    Text(
                      time,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  if (condition != null)
                    Text(
                      condition.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
            ),

            // Weather Icon
            if (icon != null)
              Expanded(
                child: Column(
                  children: [
                    Image.network(
                      'https://openweathermap.org/img/wn/$icon.png',
                      width: 50,
                      height: 50,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          isDaytime ? Icons.wb_sunny : Icons.nightlight,
                          size: 40,
                          color: isDaytime ? Colors.orange : Colors.blue,
                        );
                      },
                    ),
                    if (forecast.pop != null && forecast.pop! > 0)
                      Text(
                        '${(forecast.pop! * 100).round()}%',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),

            // Temperature Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$temp°C',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Additional info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(Icons.water_drop, size: 14, color: Colors.blue),
                      const SizedBox(width: 4),
                      Text(
                        '${forecast.main?.humidity ?? 0}%',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(Icons.air, size: 14, color: Colors.green),
                      const SizedBox(width: 4),
                      Text(
                        '${forecast.wind?.speed?.toStringAsFixed(1) ?? 0} m/s',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}