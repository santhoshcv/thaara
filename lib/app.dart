import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router.dart';
import 'core/theme.dart';
import 'l10n/strings.dart';
import 'state/providers.dart';

class ThaaraApp extends ConsumerWidget {
  const ThaaraApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider) ?? const Locale('en');
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Thaara',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(locale),
      locale: locale,
      supportedLocales: S.supportedLocales,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: router,
    );
  }
}
