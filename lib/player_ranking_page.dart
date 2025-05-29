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
  List<Player> _players = [];
  final PlayerService _playerService = PlayerService();
  bool isLoading = false;
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
      body: Column(children: [Expanded(child: _buildPlayersList(_players))]),
    );
  }

  Widget _buildPlayersList(List<Player> players) {
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
        if (isLoading && !_isRefreshing)
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

  Future<void> _loadPlayers() async {
    setState(() {
      isLoading = true;
    });

    try {
      final players = await _playerService.getPlayers();

      setState(() {
        _players = players;
        isLoading = false;
        _isRefreshing = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
        _isRefreshing = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $error'),
            backgroundColor: Colors.red,
            action: SnackBarAction(label: 'Retry', onPressed: _loadPlayers),
          ),
        );
      }
    }
  }

  Future<void> _refreshPlayers() async {
    setState(() {
      _isRefreshing = true;
    });
    await _loadPlayers();
  }
}
