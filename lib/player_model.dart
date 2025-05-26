class Player {
  final String id;
  final String name;
  final int rank;
  final String flag;
  final int points;
  final String? avatarUrl;

  Player({
    required this.id,
    required this.name,
    required this.rank,
    required this.flag,
    required this.points,
    this.avatarUrl,
  });
}
