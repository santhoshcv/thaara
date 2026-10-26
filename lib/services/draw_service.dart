import 'dart:math';

import '../data/cards.dart';
import '../models/reading.dart';

/// Draws cards with a cryptographically secure shuffle, so every reading
/// is genuinely random and never chosen by the app or the AI.
class DrawService {
  DrawService({Random? random}) : _random = random ?? Random.secure();

  final Random _random;

  /// Roughly one card in three comes up reversed.
  static const reversedChance = 1 / 3;

  List<DrawnCard> draw(int count) {
    final shuffled = [...deck]..shuffle(_random);
    return [
      for (var i = 0; i < count; i++)
        DrawnCard(
          card: shuffled[i],
          reversed: _random.nextDouble() < reversedChance,
          position: i,
        ),
    ];
  }
}
