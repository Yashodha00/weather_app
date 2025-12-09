import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../../core/constants/app_constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Weather Alerts'),
            trailing: Switch(
              value: weatherProvider.alertsEnabled,
              onChanged: (value) => weatherProvider.toggleAlerts(),
              activeColor: AppConstants.primaryColor,
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.thermostat),
            title: const Text('Temperature Unit'),
            subtitle: const Text('Celsius'),
            onTap: () {
              // Show temperature unit dialog
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: AppConstants.appName,
                applicationVersion: AppConstants.appVersion,
                applicationLegalese: AppConstants.appDescription,
              );
            },
          ),
        ],
      ),
    );
  }
}