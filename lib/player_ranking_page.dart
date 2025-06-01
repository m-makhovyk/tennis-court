import 'package:flutter/material.dart';
import 'package:tennis_court/player_model.dart';
import 'package:tennis_court/services/player_service.dart';
import 'package:tennis_court/services/country_flag_service.dart';

class PlayerRankingPage extends StatefulWidget {
  const PlayerRankingPage({super.key, required this.title});

  final String title;

  @override
  State<PlayerRankingPage> createState() => _PlayerRankingPageState();
}

class _PlayerRankingPageState extends State<PlayerRankingPage> {
  final List<Player> _players = [];
  final PlayerService _playerService = PlayerService();
  bool isLoading = false;
  bool _isRefreshing = false;
  int _page = 0;
  final int _maxPage = 9; // API limited to 9 pages

  bool get canLoadMore => _page < _maxPage;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadPlayers();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
            controller: _scrollController,
            itemCount:
                _players.length + (canLoadMore && players.isNotEmpty ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= _players.length) {
                return SizedBox(
                  height: 80,
                  child: const Center(
                    child: Text(
                      'Loading more...',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              }
              return _buildPlayerRow(_players[index]);
            },
          ),
        ),
        if (isLoading && !_isRefreshing && players.isEmpty)
          const Center(child: CircularProgressIndicator()),
      ],
    );
  }

  Widget _buildPlayerRow(Player player) {
    final flag = CountryFlagService().getFlagForCountry(player.countryAcr);

    return ListTile(
      title: Row(
        children: [
          // Rank column
          SizedBox(
            width: 70,
            child: Row(
              children: [
                Text(
                  player.rank.toString(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child:
                      _buildRankChangeWidget(player.weeklyPositionChange) ??
                      const SizedBox(),
                ),
              ],
            ),
          ),
          // Player info column
          Expanded(
            child: Row(
              children: [
                Text(flag, style: const TextStyle(fontSize: 28)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    player.name,
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          // Points column
          SizedBox(
            width: 80,
            child: Text(
              '${player.points}',
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget? _buildRankChangeWidget(int change) {
    if (change == 0) return null;

    final isPositive = change > 0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isPositive ? Icons.arrow_drop_up : Icons.arrow_drop_down,
          color: isPositive ? Colors.green : Colors.red,
          size: 24,
        ),
        Transform.translate(
          offset: const Offset(0, -8),
          child: Text(
            '${isPositive ? '+' : ''}$change',
            style: TextStyle(
              color: isPositive ? Colors.green : Colors.red,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _loadPlayers() async {
    setState(() {
      isLoading = true;
    });

    try {
      final players = await _playerService.getPlayers(_page);

      setState(() {
        _players.addAll(players);
        isLoading = false;
        _isRefreshing = false;
        _page++;
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
      _page = 0;
      _players.clear();
      _isRefreshing = true;
    });
    await _loadPlayers();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !isLoading &&
        canLoadMore) {
      _loadPlayers();
    }
  }
}
