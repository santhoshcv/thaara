import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/spreads.dart';
import '../models/reading.dart';

enum ReadingErrorKind { dailyLimit, sameQuestion, offline, unknown }

class ReadingException implements Exception {
  final ReadingErrorKind kind;
  const ReadingException(this.kind);
}

class ReadingService {
  ReadingService(this._client);

  final SupabaseClient _client;

  Future<ReadingResult> requestReading({
    required Spread spread,
    required List<DrawnCard> cards,
    required String question,
    required String situation,
    required String languageCode,
  }) async {
    try {
      final res = await _client.functions.invoke('reading', body: {
        'spread_id': spread.id,
        'spread_title': spread.titleEn,
        'question': question.trim(),
        'situation': situation.trim(),
        'locale': languageCode,
        'cards': [for (final c in cards) c.toRequestJson(spread)],
      });
      return ReadingResult.fromJson(Map<String, dynamic>.from(res.data as Map));
    } on FunctionException catch (e) {
      final details = e.details;
      final code = details is Map ? details['error'] : null;
      if (code == 'daily_limit') throw const ReadingException(ReadingErrorKind.dailyLimit);
      if (code == 'same_question') throw const ReadingException(ReadingErrorKind.sameQuestion);
      throw const ReadingException(ReadingErrorKind.unknown);
    } on AuthException {
      throw const ReadingException(ReadingErrorKind.unknown);
    } catch (e) {
      final text = e.toString();
      if (text.contains('SocketException') || text.contains('ClientException')) {
        throw const ReadingException(ReadingErrorKind.offline);
      }
      throw const ReadingException(ReadingErrorKind.unknown);
    }
  }
}
