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

  String get formattedName {
    final parts = name.trim().split(' ');
    if (parts.length == 1) return name;

    final surname = parts.last;
    final initials = parts
        .sublist(0, parts.length - 1)
        .map((part) => '${part[0].toUpperCase()}.')
        .join(' ');

    return '$initials $surname';
  }

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
