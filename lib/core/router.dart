import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/home/home_screen.dart';
import '../features/home/shell.dart';
import '../features/journal/journal_editor_screen.dart';
import '../features/journal/journal_screen.dart';
import '../features/onboarding/intro_screen.dart';
import '../features/onboarding/language_screen.dart';
import '../features/reading/draw_screen.dart';
import '../features/reading/question_screen.dart';
import '../features/reading/result_screen.dart';
import '../features/settings/settings_screen.dart';
import '../state/providers.dart';

class Routes {
  static const language = '/language';
  static const intro = '/intro';
  static const home = '/home';
  static const journal = '/journal';
  static const settings = '/settings';
  static const newReading = '/reading/new';
  static const draw = '/reading/draw';
  static const result = '/reading/result';
  static String pastReading(String id) => '/reading/view/$id';
  static String newEntry({String? readingId}) =>
      readingId == null ? '/journal/new' : '/journal/new?reading=$readingId';
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: Routes.home,
    redirect: (context, state) {
      final hasLocale = ref.read(localeProvider) != null;
      final onboarded = ref.read(onboardingProvider);
      final loc = state.matchedLocation;
      final inOnboarding = loc == Routes.language || loc == Routes.intro;

      if (!hasLocale && loc != Routes.language) return Routes.language;
      if (hasLocale && !onboarded && !inOnboarding) return Routes.intro;
      if (onboarded && inOnboarding) return Routes.home;
      return null;
    },
    routes: [
      GoRoute(path: Routes.language, builder: (_, __) => const LanguageScreen()),
      GoRoute(path: Routes.intro, builder: (_, __) => const IntroScreen()),
      StatefulShellRoute.indexedStack(
        builder: (_, __, shell) => HomeShell(shell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: Routes.home, builder: (_, __) => const HomeScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: Routes.journal, builder: (_, __) => const JournalScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: Routes.settings, builder: (_, __) => const SettingsScreen()),
          ]),
        ],
      ),
      GoRoute(path: Routes.newReading, builder: (_, __) => const QuestionScreen()),
      GoRoute(path: Routes.draw, builder: (_, __) => const DrawScreen()),
      GoRoute(path: Routes.result, builder: (_, __) => const ResultScreen()),
      GoRoute(
        path: '/reading/view/:id',
        builder: (_, s) => PastReadingScreen(id: s.pathParameters['id']!),
      ),
      GoRoute(
        path: '/journal/new',
        builder: (_, s) => JournalEditorScreen(readingId: s.uri.queryParameters['reading']),
      ),
    ],
  );
});
