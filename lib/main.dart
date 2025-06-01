import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tennis_court/player_ranking_page.dart';
import 'package:tennis_court/services/country_flag_service.dart';
import 'l10n/app_localizations.dart';

class MacOSScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
  };
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  final countryFlagService = CountryFlagService();
  await countryFlagService.loadCountryFlags();

  runApp(MyApp(countryFlagService: countryFlagService));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.countryFlagService});

  final CountryFlagService countryFlagService;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      scrollBehavior: MacOSScrollBehavior(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', '')],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: PlayerRankingPage(
        title: 'Tennis Court',
        countryFlagService: countryFlagService,
      ),
    );
  }
}
