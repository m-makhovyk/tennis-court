import 'dart:async';
import 'player_model.dart';

class PlayerService {
  Future<List<Player>> getPlayers() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    return [
      Player(
        id: "1",
        name: 'Jannik Sinner',
        rank: 1,
        flag: '🇮🇹',
        points: 10380,
      ),
      Player(
        id: "2",
        name: 'Carlos Alcaraz',
        rank: 2,
        flag: '🇪🇸',
        points: 8850,
      ),
      Player(
        id: "3",
        name: 'Alexander Zverev',
        rank: 3,
        flag: '🇩🇪',
        points: 7285,
      ),
      Player(
        id: "4",
        name: 'Taylor Fritz',
        rank: 4,
        flag: '🇺🇸',
        points: 4675,
      ),
      Player(id: "5", name: 'Jack Draper', rank: 5, flag: '🇬🇧', points: 4610),
      Player(
        id: "6",
        name: 'Novak Djokovic',
        rank: 6,
        flag: '🇷🇸',
        points: 4230,
      ),
      Player(
        id: "7",
        name: 'Lorenzo Musetti',
        rank: 7,
        flag: '🇮🇹',
        points: 3860,
      ),
      Player(id: "8", name: 'Casper Ruud', rank: 8, flag: '🇳🇴', points: 3655),
      Player(
        id: "9",
        name: 'Alex de Minaur',
        rank: 9,
        flag: '🇦🇺',
        points: 3635,
      ),
      Player(
        id: "10",
        name: 'Holger Rune',
        rank: 10,
        flag: '🇩🇰',
        points: 3440,
      ),
    ];
  }
}
