/// Build-time configuration, passed with --dart-define (see README).
class Env {
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  /// Public pages hosted on Vercel (privacy policy, terms, account deletion).
  static const siteUrl =
      String.fromEnvironment('SITE_URL', defaultValue: 'https://thaara.app');

  static void assertConfigured() {
    if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
      throw StateError(
        'Missing SUPABASE_URL / SUPABASE_ANON_KEY. Run with '
        '--dart-define-from-file=env.json (see README).',
      );
    }
  }
}
