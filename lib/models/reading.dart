import '../data/cards.dart';
import '../data/spreads.dart';

class DrawnCard {
  final TarotCard card;
  final bool reversed;
  final int position;

  const DrawnCard({required this.card, required this.reversed, required this.position});

  Map<String, dynamic> toRequestJson(Spread spread) => {
        'card_id': card.id,
        'name': card.nameEn,
        'name_ml': card.nameMl,
        'reversed': reversed,
        'position': spread.positions[position].en,
        'position_ml': spread.positions[position].ml,
        'keywords': reversed ? card.reversed : card.upright,
      };
}

class CardInsight {
  final String position;
  final String card;
  final String insight;

  const CardInsight({required this.position, required this.card, required this.insight});

  factory CardInsight.fromJson(Map<String, dynamic> j) => CardInsight(
        position: j['position'] as String? ?? '',
        card: j['card'] as String? ?? '',
        insight: j['insight'] as String? ?? '',
      );
}

class ReadingResult {
  final String? id;
  final String summary;
  final List<CardInsight> cards;
  final String reflectionQuestion;
  final bool safetyFlag;

  const ReadingResult({
    this.id,
    required this.summary,
    required this.cards,
    required this.reflectionQuestion,
    required this.safetyFlag,
  });

  factory ReadingResult.fromJson(Map<String, dynamic> j) => ReadingResult(
        id: j['id'] as String?,
        summary: j['summary'] as String? ?? '',
        cards: ((j['cards'] as List?) ?? const [])
            .map((e) => CardInsight.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
        reflectionQuestion: j['reflection_question'] as String? ?? '',
        safetyFlag: j['safety_flag'] as bool? ?? false,
      );
}

/// A past reading as listed on the home screen.
class ReadingSummary {
  final String id;
  final String question;
  final String spreadId;
  final DateTime createdAt;
  final ReadingResult result;

  const ReadingSummary({
    required this.id,
    required this.question,
    required this.spreadId,
    required this.createdAt,
    required this.result,
  });

  factory ReadingSummary.fromRow(Map<String, dynamic> row) => ReadingSummary(
        id: row['id'] as String,
        question: row['question'] as String? ?? '',
        spreadId: row['spread_id'] as String,
        createdAt: DateTime.parse(row['created_at'] as String).toLocal(),
        result: ReadingResult.fromJson({
          ...Map<String, dynamic>.from(row['result'] as Map? ?? const {}),
          'id': row['id'],
          'safety_flag': row['safety_flag'] ?? false,
        }),
      );
}

class JournalEntry {
  final String id;
  final String body;
  final int? mood;
  final String? readingId;
  final DateTime createdAt;

  const JournalEntry({
    required this.id,
    required this.body,
    this.mood,
    this.readingId,
    required this.createdAt,
  });

  factory JournalEntry.fromRow(Map<String, dynamic> row) => JournalEntry(
        id: row['id'] as String,
        body: row['body'] as String? ?? '',
        mood: row['mood'] as int?,
        readingId: row['reading_id'] as String?,
        createdAt: DateTime.parse(row['created_at'] as String).toLocal(),
      );
}
