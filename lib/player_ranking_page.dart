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
  bool _isRefreshing = false;

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
                if (snapshot.hasError) {
                  return _buildErrorView(snapshot.error.toString());
                } else {
                  return _buildPlayersList(snapshot);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(String error) {
    return Center(child: Text('Error: $error'));
  }

  Widget _buildPlayersList(AsyncSnapshot<List<Player>> snapshot) {
    final players = snapshot.data ?? [];
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: _refreshPlayers,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: players.length,
            itemBuilder: (context, index) {
              return _buildPlayerRow(players[index]);
            },
          ),
        ),
        if (!_isRefreshing &&
            snapshot.connectionState == ConnectionState.waiting)
          const Center(child: CircularProgressIndicator()),
      ],
    );
  }

  Widget _buildPlayerRow(Player player) {
    return ListTile(
      leading: Text(
        player.rank.toString(),
        style: Theme.of(context).textTheme.titleMedium,
      ),
      title: Text(player.name),
      subtitle: Text('Points: ${player.points}'),
      trailing: Text(player.countryAcr, style: const TextStyle(fontSize: 24)),
    );
  }

  Future<void> _refreshPlayers() async {
    setState(() {
      _isRefreshing = true;
      _playersFuture = _playerService.getPlayers();
    });
    await _playersFuture;
    setState(() {
      _isRefreshing = false;
    });
  }
}
