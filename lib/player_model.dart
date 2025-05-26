class Player {
  final String id;
  final String name;
  final int rank;
  final String countryAcr;
  final int points;

  Player({
    required this.id,
    required this.name,
    required this.rank,
    required this.countryAcr,
    required this.points,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['player']['id'].toString(),
      name: json['player']['name'],
      rank: json['position'],
      countryAcr: json['player']['countryAcr'],
      points: json['point'],
    );
  }
}
