class Player {
  final int id;
  final String name;
  final int rank;
  final String countryAcr;
  final int points;
  final int weeklyPoints;
  final int weeklyPositionChange;

  Player({
    required this.id,
    required this.name,
    required this.rank,
    required this.countryAcr,
    required this.points,
    required this.weeklyPoints,
    required this.weeklyPositionChange,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['player']['id'],
      name: json['player']['name'],
      rank: json['position'],
      countryAcr: json['player']['countryAcr'],
      points: json['pts'],
      weeklyPoints: json['wkPts'],
      weeklyPositionChange: json['wk'],
    );
  }
}
