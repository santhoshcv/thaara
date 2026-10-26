import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:thaara/data/cards.dart';
import 'package:thaara/data/spreads.dart';
import 'package:thaara/services/draw_service.dart';

void main() {
  test('deck has 78 unique cards', () {
    expect(deck.length, 78);
    expect(deck.map((c) => c.id).toSet().length, 78);
    expect(deck.where((c) => c.arcana == Arcana.major).length, 22);
  });

  test('every card has names and keywords in both orientations', () {
    for (final c in deck) {
      expect(c.nameEn, isNotEmpty);
      expect(c.nameMl, isNotEmpty);
      expect(c.upright, isNotEmpty, reason: c.id);
      expect(c.reversed, isNotEmpty, reason: c.id);
    }
  });

  test('a draw never repeats a card', () {
    final service = DrawService(random: Random(42));
    for (var i = 0; i < 200; i++) {
      final cards = service.draw(4);
      expect(cards.map((c) => c.card.id).toSet().length, 4);
    }
  });

  test('every spread has labels in both languages', () {
    for (final s in spreads) {
      expect(s.positions, isNotEmpty);
      for (final p in s.positions) {
        expect(p.en, isNotEmpty);
        expect(p.ml, isNotEmpty);
      }
    }
  });
}
