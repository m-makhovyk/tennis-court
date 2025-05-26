import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'player_model.dart';

class PlayerService {
  static const String _baseUrl =
      'https://tennis-api-atp-wta-itf.p.rapidapi.com';
  static String get _apiKey => dotenv.env['RAPIDAPI_KEY'] ?? '';
  static const String _host = 'tennis-api-atp-wta-itf.p.rapidapi.com';

  Future<List<Player>> getPlayers() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/tennis/v2/atp/ranking/singles/'),
      headers: {'x-rapidapi-host': _host, 'x-rapidapi-key': _apiKey},
    );

    if (response.statusCode != 200) {
      throw Exception('API Error: ${response.statusCode} - ${response.body}');
    }

    final Map<String, dynamic> jsonData = json.decode(response.body);
    final List<dynamic> playersData = jsonData['data'];

    return playersData
        .map((playerJson) => Player.fromJson(playerJson))
        .toList();
  }
}
