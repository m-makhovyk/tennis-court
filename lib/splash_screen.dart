import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tennis_court/player_ranking_page.dart';
import 'package:tennis_court/services/country_flag_service.dart';
import 'package:tennis_court/services/player_service.dart';
import 'package:tennis_court/services/configuration_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _status = 'Loading...';
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      await dotenv.load(fileName: ".env");

      final countryFlagService = CountryFlagService();
      await countryFlagService.loadCountryFlags();

      setState(() => _status = 'Fetching configuration...');
      await ConfigurationService.instance.fetchConfiguration();

      setState(() => _status = 'Initializing services...');
      final playerService = PlayerService(ConfigurationService.instance);

      // Small delay for smooth transition
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => PlayerRankingPage(
              title: 'Tennis Court',
              countryFlagService: countryFlagService,
              playerService: playerService,
            ),
          ),
        );
      }
    } catch (error) {
      setState(() {
        _hasError = true;
        _status = 'Failed to load: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sports_tennis,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'Tennis Court',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 48),
            if (!_hasError) ...[
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
            ],
            Text(
              _status,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: _hasError ? Colors.red : null,
              ),
              textAlign: TextAlign.center,
            ),
            if (_hasError) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() => _hasError = false);
                  _initializeApp();
                },
                child: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
