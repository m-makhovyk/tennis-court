import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tennis_court/player_ranking_page.dart';
import 'package:tennis_court/services/country_flag_service.dart';
import 'package:tennis_court/services/player_service.dart';
import 'package:tennis_court/services/configuration_service.dart';
import 'package:tennis_court/l10n/app_localizations.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? _status;
  bool _hasError = false;
  String? _errorMessage;
  bool _hasInitialized = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasInitialized) {
      _hasInitialized = true;
      _initializeApp();
    }
  }

  Future<void> _initializeApp() async {
    try {
      setState(() {
        _status = AppLocalizations.of(context)!.splashFetchingConfiguration;
        _hasError = false;
        _errorMessage = null;
      });

      await dotenv.load(fileName: ".env");

      final countryFlagService = CountryFlagService();
      await countryFlagService.loadCountryFlags();

      final configurationService = ConfigurationService.instance;
      await configurationService.fetchConfiguration();

      setState(
        () =>
            _status = AppLocalizations.of(context)!.splashInitializingServices,
      );
      final playerService = PlayerService(configurationService);

      // Small delay for smooth transition
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => PlayerRankingPage(
              title: AppLocalizations.of(context)!.appTitle,
              countryFlagService: countryFlagService,
              playerService: playerService,
            ),
          ),
        );
      }
    } catch (error) {
      setState(() {
        _hasError = true;
        _errorMessage = error.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

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
              localizations.appTitle,
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
              _hasError
                  ? localizations.generalSomethingWentWrong
                  : (_status ?? localizations.generalLoading),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: _hasError ? Colors.red : null,
              ),
              textAlign: TextAlign.center,
            ),
            if (_hasError) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _initializeApp,
                child: Text(localizations.generalRetry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
