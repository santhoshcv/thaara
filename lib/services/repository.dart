import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/reading.dart';

/// Reads and writes the user's own rows. Row-level security on the server
/// guarantees a user can only ever see their own data.
class Repository {
  Repository(this._client);

  final SupabaseClient _client;

  String get _uid {
    final id = _client.auth.currentUser?.id;
    if (id == null) throw const AuthException('Not signed in');
    return id;
  }

  Future<List<ReadingSummary>> recentReadings({int limit = 20}) async {
    final rows = await _client
        .from('readings')
        .select('id, question, spread_id, result, safety_flag, created_at')
        .order('created_at', ascending: false)
        .limit(limit);
    return rows.map(ReadingSummary.fromRow).toList();
  }

  Future<ReadingSummary?> reading(String id) async {
    final row = await _client
        .from('readings')
        .select('id, question, spread_id, result, safety_flag, created_at')
        .eq('id', id)
        .maybeSingle();
    return row == null ? null : ReadingSummary.fromRow(row);
  }

  Future<List<JournalEntry>> journal({int limit = 100}) async {
    final rows = await _client
        .from('journal_entries')
        .select()
        .order('created_at', ascending: false)
        .limit(limit);
    return rows.map(JournalEntry.fromRow).toList();
  }

  Future<void> addJournalEntry({required String body, int? mood, String? readingId}) async {
    await _client.from('journal_entries').insert({
      'user_id': _uid,
      'body': body.trim(),
      'mood': mood,
      'reading_id': readingId,
    });
  }

  Future<void> updateLocale(String languageCode) async {
    if (_client.auth.currentUser == null) return;
    await _client.from('profiles').update({'locale': languageCode}).eq('id', _uid);
  }

  /// Deletes the auth user server-side; all rows cascade.
  Future<void> deleteEverything() async {
    await _client.functions.invoke('delete-account');
    await _client.auth.signOut();
  }
}
