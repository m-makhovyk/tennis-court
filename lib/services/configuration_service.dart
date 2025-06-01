import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ConfigurationService {
  static final ConfigurationService _instance =
      ConfigurationService._internal();
  static ConfigurationService get instance => _instance;

  ConfigurationService._internal();

  String get _baseUrl {
    final url = dotenv.env['MATCHSTAT_API_URL'];
    if (url == null || url.isEmpty) {
      throw Exception('MATCHSTAT_API_URL env is not configured');
    }
    return url;
  }

  DateTime? _lastUpdated;

  DateTime get lastUpdated => _lastUpdated ?? DateTime.now();

  Future<void> fetchConfiguration() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/ranking/atp/filters?includeAll=true'),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Configuration API Error: ${response.statusCode} - ${response.body}',
      );
    }

    final Map<String, dynamic> jsonData = json.decode(response.body);
    final dates = (jsonData['date'] as List<dynamic>)
        .map((date) => date.toString())
        .toList();

    if (dates.isEmpty) {
      throw Exception('Configuration date is invalid');
    }

    final dateString = dates.first;
    final parsedDate = DateTime.tryParse(dateString);
    if (parsedDate == null) {
      throw Exception('Unable to parse date format: $dateString');
    }

    _lastUpdated = parsedDate;
  }
}
