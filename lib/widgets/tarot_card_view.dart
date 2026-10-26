import 'dart:math';

import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../data/cards.dart';

/// Placeholder card art until the illustrated deck is ready: a framed card
/// with a suit glyph or Roman numeral and the card's name.
class TarotCardFace extends StatelessWidget {
  const TarotCardFace({super.key, required this.card, required this.reversed, required this.lang});

  final TarotCard card;
  final bool reversed;
  final String lang;

  static const _roman = [
    '0', 'I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX', 'X', 'XI',
    'XII', 'XIII', 'XIV', 'XV', 'XVI', 'XVII', 'XVIII', 'XIX', 'XX', 'XXI',
  ];

  String get _glyph {
    if (card.arcana == Arcana.major) return _roman[card.number];
    return switch (card.suit!) {
      Suit.wands => '✦',
      Suit.cups => '◡',
      Suit.swords => '†',
      Suit.pentacles => '✪',
    };
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final face = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [ThaaraColors.plum, ThaaraColors.dusk],
        ),
        border: Border.all(color: ThaaraColors.gold, width: 1.5),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(_glyph, style: text.headlineSmall?.copyWith(color: ThaaraColors.gold)),
          Text(
            card.name(lang),
            textAlign: TextAlign.center,
            style: text.labelLarge?.copyWith(color: ThaaraColors.goldSoft, height: 1.2),
          ),
          Container(height: 1, width: 24, color: ThaaraColors.gold.withValues(alpha: 0.6)),
        ],
      ),
    );
    return reversed ? Transform.rotate(angle: pi, child: face) : face;
  }
}

class TarotCardBack extends StatelessWidget {
  const TarotCardBack({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: ThaaraColors.dusk,
        border: Border.all(color: ThaaraColors.gold.withValues(alpha: 0.7), width: 1.5),
      ),
      child: Container(
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: ThaaraColors.plum, width: 1),
        ),
        child: const Center(
          child: Text('✶', style: TextStyle(fontSize: 34, color: ThaaraColors.gold)),
        ),
      ),
    );
  }
}

/// Card that turns over with a 3D flip when [revealed] becomes true.
class FlipCard extends StatelessWidget {
  const FlipCard({
    super.key,
    required this.revealed,
    required this.front,
    this.back = const TarotCardBack(),
  });

  final bool revealed;
  final Widget front;
  final Widget back;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: revealed ? 1 : 0),
      duration: const Duration(milliseconds: 550),
      curve: Curves.easeInOutCubic,
      builder: (context, t, _) {
        final angle = t * pi;
        final showFront = t >= 0.5;
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.0012)
            ..rotateY(angle),
          child: showFront
              ? Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..rotateY(pi),
                  child: front,
                )
              : back,
        );
      },
    );
  }
}
