import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/weather_provider.dart';
import '../widgets/forecast_card.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/forecast_model.dart';

class DateForecastScreen extends StatefulWidget {
  const DateForecastScreen({super.key});

  @override
  State<DateForecastScreen> createState() => _DateForecastScreenState();
}

class _DateForecastScreenState extends State<DateForecastScreen> {
  DateTime? _selectedDate;
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set default to tomorrow
    _selectedDate = DateTime.now().add(const Duration(days: 1));
    _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate!);
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 15)),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  List<ForecastItem> _getForecastForDate(DateTime date, WeatherProvider provider) {
    if (provider.forecast?.list == null) return [];

    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    return provider.forecast!.list!
        .where((item) {
      if (item.dtTxt == null) return false;
      final itemDate = item.dtTxt!.split(' ')[0];
      return itemDate == dateStr;
    })
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final forecastItems = _selectedDate != null
        ? _getForecastForDate(_selectedDate!, weatherProvider)
        : [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Forecast by Date'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Selection Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Select Date for Forecast',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _dateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Select Date',
                        prefixIcon: const Icon(Icons.calendar_today),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_month),
                          onPressed: () => _selectDate(context),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onTap: () => _selectDate(context),
                    ),
                    const SizedBox(height: 16),
                    if (_selectedDate != null)
                      Column(
                        children: [
                          Text(
                            DateFormat('EEEE, MMMM d, yyyy').format(_selectedDate!),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${_selectedDate!.difference(DateTime.now()).inDays} days from now',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Forecast Results
            if (forecastItems.isEmpty && _selectedDate != null)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.cloud_off,
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No forecast data available',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'For ${DateFormat('MMM d, yyyy').format(_selectedDate!)}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => _selectDate(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConstants.primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Choose Another Date'),
                      ),
                    ],
                  ),
                ),
              )
            else if (forecastItems.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Weather Forecast for ${DateFormat('MMM d, yyyy').format(_selectedDate!)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${forecastItems.length} time slots available',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ...forecastItems.map((item) => ForecastCard(forecast: item)),
                ],
              ),

            // Quick Date Selection
            const SizedBox(height: 30),
            const Text(
              'Quick Date Selection',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildDateChip('Tomorrow', 1, context),
                _buildDateChip('In 2 Days', 2, context),
                _buildDateChip('In 3 Days', 3, context),
                _buildDateChip('In 5 Days', 5, context),
                _buildDateChip('Next Week', 7, context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateChip(String label, int daysFromNow, BuildContext context) {
    final date = DateTime.now().add(Duration(days: daysFromNow));
    return ChoiceChip(
      label: Text(label),
      selected: _selectedDate != null &&
          DateFormat('yyyy-MM-dd').format(_selectedDate!) ==
              DateFormat('yyyy-MM-dd').format(date),
      onSelected: (selected) {
        setState(() {
          _selectedDate = date;
          _dateController.text = DateFormat('yyyy-MM-dd').format(date);
        });
      },
      selectedColor: AppConstants.primaryColor.withOpacity(0.3),
      labelStyle: TextStyle(
        color: _selectedDate != null &&
            DateFormat('yyyy-MM-dd').format(_selectedDate!) ==
                DateFormat('yyyy-MM-dd').format(date)
            ? AppConstants.primaryColor
            : Colors.black,
      ),
    );
  }
}