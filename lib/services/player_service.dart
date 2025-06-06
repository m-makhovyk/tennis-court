import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../player_model.dart';
import 'configuration_service.dart';

enum RankingType {
  atp('atp'),
  wta('wta');

  const RankingType(this.rawValue);
  final String rawValue;
}

class PlayerService {
  final ConfigurationService _configurationService;

  PlayerService(this._configurationService);

  static String get _baseUrl {
    final url = dotenv.env['MATCHSTAT_API_URL'];
    if (url == null || url.isEmpty) {
      throw Exception('env is not configured');
    }
    return url;
  }

  Future<List<Player>> getPlayers(RankingType type, int page) async {
    final dateTime = _configurationService.lastUpdated;
    final date =
        '${dateTime.day.toString().padLeft(2, '0')}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.year}';

    final response = await http.get(
      Uri.parse(
        '$_baseUrl/ranking/${type.rawValue}/?date=$date&group=singles&page=$page&includeAll=true',
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('API Error: ${response.statusCode} - ${response.body}');
    }

    final List<dynamic> jsonData = json.decode(response.body);

    return jsonData.map((playerJson) => Player.fromJson(playerJson)).toList();
  }
}
