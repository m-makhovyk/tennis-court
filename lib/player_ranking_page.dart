import 'package:flutter/material.dart';
import 'package:tennis_court/player_model.dart';
import 'package:tennis_court/player_service.dart';

class PlayerRankingPage extends StatefulWidget {
  const PlayerRankingPage({super.key, required this.title});

  final String title;

  @override
  State<PlayerRankingPage> createState() => _PlayerRankingPageState();
}

class _PlayerRankingPageState extends State<PlayerRankingPage> {
  late Future<List<Player>> _playersFuture;
  final PlayerService _playerService = PlayerService();

  @override
  void initState() {
    super.initState();
    _playersFuture = _playerService.getPlayers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Player>>(
              future: _playersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No players found.'));
                } else {
                  final players = snapshot.data!;
                  return ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: players.length,
                    itemBuilder: (context, index) {
                      return _PlayerRow(player: players[index]);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayerRow extends StatelessWidget {
  final Player player;

  const _PlayerRow({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        player.rank.toString(),
        style: Theme.of(context).textTheme.titleMedium,
      ),
      title: Text(player.name),
      subtitle: Text('Points: ${player.points}'),
      trailing: Text(player.flag, style: const TextStyle(fontSize: 24)),
    );
  }
}
