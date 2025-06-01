// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Tennis Court';

  @override
  String get generalLoadingMore => 'Loading more...';

  @override
  String generalError(String message) {
    return 'Error: $message';
  }

  @override
  String get generalRetry => 'Retry';

  @override
  String get rankingHeaderRank => 'Rank';

  @override
  String get rankingHeaderPlayer => 'Player';

  @override
  String get rankingHeaderWeekly => 'Weekly';

  @override
  String get rankingHeaderPoints => 'Points';
}
