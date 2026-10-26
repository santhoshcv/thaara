import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/reading.dart';
import '../services/draw_service.dart';
import '../services/reading_service.dart';
import '../services/repository.dart';

class PrefKeys {
  static const locale = 'locale';
  static const onboarded = 'onboarded';
}

/// Overridden in main() with the loaded instance.
final sharedPreferencesProvider =
    Provider<SharedPreferences>((ref) => throw UnimplementedError());

final supabaseProvider = Provider<SupabaseClient>((ref) => Supabase.instance.client);

final drawServiceProvider = Provider((ref) => DrawService());
final readingServiceProvider =
    Provider((ref) => ReadingService(ref.watch(supabaseProvider)));
final repositoryProvider = Provider((ref) => Repository(ref.watch(supabaseProvider)));

/// Selected language, persisted on the device. Null until chosen.
class LocaleNotifier extends Notifier<Locale?> {
  @override
  Locale? build() {
    final code = ref.read(sharedPreferencesProvider).getString(PrefKeys.locale);
    return code == null ? null : Locale(code);
  }

  Future<void> set(Locale locale) async {
    state = locale;
    await ref.read(sharedPreferencesProvider).setString(PrefKeys.locale, locale.languageCode);
    try {
      await ref.read(repositoryProvider).updateLocale(locale.languageCode);
    } catch (_) {
      // Profile sync is best-effort; the device setting is what matters.
    }
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale?>(LocaleNotifier.new);

class OnboardingNotifier extends Notifier<bool> {
  @override
  bool build() => ref.read(sharedPreferencesProvider).getBool(PrefKeys.onboarded) ?? false;

  Future<void> complete() async {
    final auth = ref.read(supabaseProvider).auth;
    if (auth.currentSession == null) {
      await auth.signInAnonymously();
    }
    await ref.read(sharedPreferencesProvider).setBool(PrefKeys.onboarded, true);
    state = true;
  }

  Future<void> reset() async {
    await ref.read(sharedPreferencesProvider).setBool(PrefKeys.onboarded, false);
    state = false;
  }
}

final onboardingProvider = NotifierProvider<OnboardingNotifier, bool>(OnboardingNotifier.new);

final recentReadingsProvider = FutureProvider.autoDispose<List<ReadingSummary>>(
  (ref) => ref.watch(repositoryProvider).recentReadings(),
);

final readingByIdProvider = FutureProvider.autoDispose.family<ReadingSummary?, String>(
  (ref, id) => ref.watch(repositoryProvider).reading(id),
);

final journalProvider = FutureProvider.autoDispose<List<JournalEntry>>(
  (ref) => ref.watch(repositoryProvider).journal(),
);
