import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'core/env.dart';
import 'state/providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Env.assertConfigured();
  await Supabase.initialize(url: Env.supabaseUrl, anonKey: Env.supabaseAnonKey);

  final prefs = await SharedPreferences.getInstance();

  // Returning users who finished onboarding but lost their session
  // (reinstall, cleared data) get a fresh private session silently.
  final onboarded = prefs.getBool(PrefKeys.onboarded) ?? false;
  if (onboarded && Supabase.instance.client.auth.currentSession == null) {
    try {
      await Supabase.instance.client.auth.signInAnonymously();
    } catch (_) {
      // Offline at launch: the home screen shows a retry state.
    }
  }

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const ThaaraApp(),
    ),
  );
}
