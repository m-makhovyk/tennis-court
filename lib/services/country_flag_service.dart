import 'package:flutter/services.dart';

class CountryFlagService {
  static final CountryFlagService _instance = CountryFlagService._internal();
  factory CountryFlagService() => _instance;
  CountryFlagService._internal();

  final Map<String, String> _countryFlags = {};
  bool _isLoaded = false;

  Future<void> loadCountryFlags() async {
    if (_isLoaded) return;

    try {
      final csvData = await rootBundle.loadString('assets/flags.csv');
      final lines = csvData.split('\n');

      for (final line in lines) {
        if (line.trim().isEmpty) continue;

        final parts = line.split(',');
        if (parts.length >= 2) {
          final countryCode = parts[1].trim().toUpperCase();
          final flag = parts[0].trim();
          _countryFlags[countryCode] = flag;
        }
      }

      _isLoaded = true;
    } catch (e) {
      throw Exception('Failed to load country flags: $e');
    }
  }

  String getFlagForCountry(String countryCode) {
    if (countryCode == 'RUS' || countryCode == 'BLR') {
      return '🏳️';
    }
    return _countryFlags[countryCode.toUpperCase()] ?? countryCode;
  }

  List<String> getAllCountryCodes() {
    return _countryFlags.keys.toList();
  }

  bool get isLoaded => _isLoaded;
}
