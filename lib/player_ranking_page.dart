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
    _loadPlayers();
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
                if (snapshot.hasError && snapshot.data == null) {
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Error: $error'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadPlayers,
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
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

  void _loadPlayers() {
    setState(() {
      _playersFuture = _playerService.getPlayers();
    });
  }

  Future<void> _refreshPlayers() async {
    setState(() {
      _isRefreshing = true;
      _playersFuture = _playerService.getPlayers();
    });
    try {
      await _playersFuture;
    } catch (e) {
      // Exception is already handled by FutureBuilder
      // Just ensure we reset the refreshing state
    } finally {
      setState(() {
        _isRefreshing = false;
      });
    }
  }
}
