import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/spreads.dart';
import '../models/reading.dart';

/// The reading currently in progress, shared across the
/// question → draw → result screens.
class ReadingDraft {
  final Spread spread;
  final String question;
  final String situation;
  final List<DrawnCard> cards;
  final ReadingResult? result;

  const ReadingDraft({
    required this.spread,
    this.question = '',
    this.situation = '',
    this.cards = const [],
    this.result,
  });

  ReadingDraft copyWith({List<DrawnCard>? cards, ReadingResult? result}) => ReadingDraft(
        spread: spread,
        question: question,
        situation: situation,
        cards: cards ?? this.cards,
        result: result ?? this.result,
      );
}

class ReadingDraftNotifier extends Notifier<ReadingDraft?> {
  @override
  ReadingDraft? build() => null;

  void start(ReadingDraft draft) => state = draft;
  void setCards(List<DrawnCard> cards) => state = state?.copyWith(cards: cards);
  void setResult(ReadingResult result) => state = state?.copyWith(result: result);
  void clear() => state = null;
}

final readingDraftProvider =
    NotifierProvider<ReadingDraftNotifier, ReadingDraft?>(ReadingDraftNotifier.new);
