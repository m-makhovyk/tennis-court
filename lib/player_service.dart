import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'player_model.dart';

class PlayerService {
  static const String _baseUrl = 'https://matchstat.com/tennis/api2';

  Future<List<Player>> getPlayers() async {
    final response = await http.get(
      Uri.parse(
        '$_baseUrl/ranking/atp/?date=26.05.2025&group=singles&page=0&includeAll=true',
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('API Error: ${response.statusCode} - ${response.body}');
    }

    final List<dynamic> jsonData = json.decode(response.body);

    return jsonData.map((playerJson) => Player.fromJson(playerJson)).toList();
  }
}
