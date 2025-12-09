import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

class CitySelectionDialog extends StatefulWidget {
  final String currentCity;
  final Function(String) onCitySelected;
  final bool showSriLankaCities;

  const CitySelectionDialog({
    super.key,
    required this.currentCity,
    required this.onCitySelected,
    this.showSriLankaCities = true,
  });

  @override
  State<CitySelectionDialog> createState() => _CitySelectionDialogState();
}

class _CitySelectionDialogState extends State<CitySelectionDialog> {
  late List<String> filteredCities;
  final TextEditingController _searchController = TextEditingController();
  bool _showSriLanka = true;

  @override
  void initState() {
    super.initState();
    _showSriLanka = widget.showSriLankaCities;
    _filterCities();
    _searchController.addListener(_filterCities);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCities() {
    final query = _searchController.text.toLowerCase();
    final sourceCities = _showSriLanka
        ? AppConstants.sriLankaCities
        : AppConstants.internationalCities;

    setState(() {
      if (query.isEmpty) {
        filteredCities = List.from(sourceCities);
      } else {
        filteredCities = sourceCities
            .where((city) => city.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  void _toggleCityType(bool showSriLanka) {
    setState(() {
      _showSriLanka = showSriLanka;
      _filterCities();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppConstants.primaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _showSriLanka ? Icons.flag : Icons.public,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _showSriLanka ? 'Select Sri Lanka City' : 'Select International City',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Toggle buttons
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilterChip(
                    label: const Text('Sri Lanka'),
                    selected: _showSriLanka,
                    onSelected: (selected) => _toggleCityType(true),
                    selectedColor: AppConstants.primaryColor,
                    checkmarkColor: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('International'),
                    selected: !_showSriLanka,
                    onSelected: (selected) => _toggleCityType(false),
                    selectedColor: Colors.blue,
                    checkmarkColor: Colors.white,
                  ),
                ],
              ),
            ),
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search cities...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                    },
                  )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
              ),
            ),
            // City List
            Container(
              constraints: const BoxConstraints(
                maxHeight: 300,
              ),
              child: filteredCities.isEmpty
                  ? const Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 48,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No cities found',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      'Try a different search term',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                shrinkWrap: true,
                itemCount: filteredCities.length,
                itemBuilder: (context, index) {
                  final city = filteredCities[index];
                  final isSelected = city == widget.currentCity;
                  return ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (_showSriLanka
                            ? AppConstants.primaryColor.withOpacity(0.2)
                            : Colors.blue.withOpacity(0.2))
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _showSriLanka ? Icons.flag : Icons.public,
                        color: isSelected
                            ? (_showSriLanka
                            ? AppConstants.primaryColor
                            : Colors.blue)
                            : Colors.grey,
                      ),
                    ),
                    title: Text(
                      city,
                      style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected
                            ? (_showSriLanka
                            ? AppConstants.primaryColor
                            : Colors.blue)
                            : Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      _showSriLanka ? 'Sri Lanka' : 'International',
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: isSelected
                        ? Icon(
                      Icons.check_circle,
                      color: _showSriLanka
                          ? AppConstants.primaryColor
                          : Colors.blue,
                    )
                        : null,
                    onTap: () {
                      widget.onCitySelected(city);
                      Navigator.pop(context);
                    },
                    tileColor: isSelected
                        ? (_showSriLanka
                        ? AppConstants.primaryColor.withOpacity(0.1)
                        : Colors.blue.withOpacity(0.1))
                        : Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                },
              ),
            ),
            // Footer
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
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