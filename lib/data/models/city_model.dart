class CityModel {
  final String name;     // City name
  final String country;  // Country code
  final double? lat;     // Latitude
  final double? lon;     // Longitude
  final String? state;   // State/region
  final bool isFavorite; // favourite option

  CityModel({
    required this.name,
    required this.country,
    this.lat,
    this.lon,
    this.state,
    this.isFavorite = false,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      name: json['name'] ?? '',
      country: json['country'] ?? '',
      lat: json['lat']?.toDouble(),
      lon: json['lon']?.toDouble(),
      state: json['state'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'country': country,
      'lat': lat,
      'lon': lon,
      'state': state,
      'isFavorite': isFavorite,
    };
  }

  CityModel copyWith({
    String? name,
    String? country,
    double? lat,
    double? lon,
    String? state,
    bool? isFavorite,
  }) {
    return CityModel(
      name: name ?? this.name,
      country: country ?? this.country,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      state: state ?? this.state,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  String toString() {
    return 'CityModel(name: $name, country: $country, lat: $lat, lon: $lon, isFavorite: $isFavorite)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CityModel &&
        other.name == name &&
        other.country == country &&
        other.lat == lat &&
        other.lon == lon;
  }

  @override
  int get hashCode {
    return name.hashCode ^ country.hashCode ^ lat.hashCode ^ lon.hashCode;
  }
}

// For storing city suggestions
class CitySuggestion {
  final String name;
  final String country;
  final double? lat;
  final double? lon;

  CitySuggestion({
    required this.name,
    required this.country,
    this.lat,
    this.lon,
  });

  factory CitySuggestion.fromJson(Map<String, dynamic> json) {
    return CitySuggestion(
      name: json['name'] ?? '',
      country: json['country'] ?? '',
      lat: json['lat']?.toDouble(),
      lon: json['lon']?.toDouble(),
    );
  }

  String get fullName => '$name, $country';

  @override
  String toString() {
    return 'CitySuggestion(name: $name, country: $country)';
  }
}