import 'package:flutter/material.dart';
import 'package:tennis_court/player_model.dart';
import 'package:tennis_court/services/player_service.dart';
import 'package:tennis_court/services/country_flag_service.dart';
import 'package:tennis_court/widgets/ranking_type_toggle.dart';
import 'l10n/app_localizations.dart';

class PlayerRankingPage extends StatefulWidget {
  const PlayerRankingPage({
    super.key,
    required this.title,
    required this.countryFlagService,
    required this.playerService,
  });

  final String title;
  final CountryFlagService countryFlagService;
  final PlayerService playerService;

  @override
  State<PlayerRankingPage> createState() => _PlayerRankingPageState();
}

class _PlayerRankingPageState extends State<PlayerRankingPage> {
  static const double _rankColumnWidth = 70;
  static const double _weeklyColumnWidth = 70;
  static const double _pointsColumnWidth = 80;

  final List<Player> _players = [];

  bool isLoading = false;
  bool _isRefreshing = false;
  int _page = 0;
  final int _maxPage = 9; // API limited to 9 pages
  RankingType _selectedRankingType = RankingType.atp;

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
        title: RankingTypeToggle(
          selectedType: _selectedRankingType,
          onChanged: (RankingType newType) {
            setState(() {
              _selectedRankingType = newType;
              _page = 0;
              _players.clear();
            });
            _loadPlayers();
          },
        ),
        centerTitle: true,
      ),
      body: Column(children: [Expanded(child: _buildPlayersList(_players))]),
    );
  }

  Widget _buildPlayersList(List<Player> players) {
    return Column(
      children: [
        // Sticky header
        _buildTableHeader(),
        // Scrollable content
        Expanded(
          child: Stack(
            children: [
              RefreshIndicator(
                onRefresh: _refreshPlayers,
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: _scrollController,
                  itemCount:
                      _players.length +
                      (canLoadMore && _players.isNotEmpty ? 1 : 0),
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    thickness: 0.5,
                    color: Theme.of(
                      context,
                    ).dividerColor.withValues(alpha: 0.3),
                  ),
                  itemBuilder: (context, index) {
                    if (index >= _players.length) {
                      return _buildLoadingMoreWidget();
                    }
                    return _buildPlayerRow(_players[index]);
                  },
                ),
              ),
              if (isLoading && !_isRefreshing && players.isEmpty)
                const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Rank column header
          SizedBox(
            width: _rankColumnWidth,
            child: Text(
              AppLocalizations.of(context)!.rankingHeaderRank,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          // Player column header
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.rankingHeaderPlayer,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          // Weekly points column header
          SizedBox(
            width: _weeklyColumnWidth,
            child: Text(
              AppLocalizations.of(context)!.rankingHeaderWeekly,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          // Points column header
          SizedBox(
            width: _pointsColumnWidth,
            child: Text(
              AppLocalizations.of(context)!.rankingHeaderPoints,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingMoreWidget() {
    return SizedBox(
      height: 80,
      child: Center(
        child: Text(
          AppLocalizations.of(context)!.generalLoadingMore,
          style: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildPlayerRow(Player player) {
    final flag = widget.countryFlagService.getFlagForCountry(player.countryAcr);
    final points = _selectedRankingType == RankingType.atp
        ? player.points.toInt()
        : (player.points / 100).toInt();

    final int weeklyPoints = _selectedRankingType == RankingType.atp
        ? player.weeklyPoints.toInt()
        : (player.weeklyPoints / 100).toInt();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Row(
        children: [
          // Rank column
          SizedBox(
            width: _rankColumnWidth,
            child: Row(
              children: [
                Text(
                  player.rank.toString(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
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
                    _formatPlayerName(player.name),
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          // Weekly points column
          SizedBox(
            width: _weeklyColumnWidth,
            child: Text(
              weeklyPoints == 0
                  ? ''
                  : (weeklyPoints > 0
                        ? '+$weeklyPoints'
                        : weeklyPoints.toString()),
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 14,
                color: weeklyPoints >= 0 ? Colors.green : Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Points column
          SizedBox(
            width: _pointsColumnWidth,
            child: Text(
              points.toString(),
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

  String _formatPlayerName(String fullName) {
    final parts = fullName.trim().split(' ');
    if (parts.length == 1) return fullName;

    final surname = parts.last;
    final initials = parts
        .sublist(0, parts.length - 1)
        .map((part) => '${part[0].toUpperCase()}.')
        .join(' ');

    return '$initials $surname';
  }

  Future<void> _loadPlayers({bool clearList = false}) async {
    setState(() {
      isLoading = true;
    });

    try {
      final players = await widget.playerService.getPlayers(
        _selectedRankingType,
        _page,
      );

      setState(() {
        if (clearList) {
          _players.clear();
        }
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
            content: Text(
              AppLocalizations.of(context)!.generalError(error.toString()),
            ),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: AppLocalizations.of(context)!.generalRetry,
              onPressed: _loadPlayers,
            ),
          ),
        );
      }
    }
  }

  Future<void> _refreshPlayers() async {
    setState(() {
      _page = 0;
      _isRefreshing = true;
    });
    await _loadPlayers(clearList: true);
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
