import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router.dart';
import '../../core/theme.dart';
import '../../state/providers.dart';
import '../../widgets/starfield.dart';

class LanguageScreen extends ConsumerWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;

    Future<void> choose(String code) async {
      await ref.read(localeProvider.notifier).set(Locale(code));
      if (context.mounted) context.go(Routes.intro);
    }

    return Scaffold(
      body: Starfield(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const Spacer(flex: 2),
                const Text('✶', style: TextStyle(fontSize: 56, color: ThaaraColors.gold)),
                const SizedBox(height: 8),
                Text('Thaara', style: text.displaySmall),
                Text('താര', style: text.headlineSmall?.copyWith(color: ThaaraColors.mist)),
                const Spacer(flex: 2),
                // Shown in both languages: the user has not chosen one yet.
                Text('Choose your language · ഭാഷ തിരഞ്ഞെടുക്കുക',
                    textAlign: TextAlign.center, style: text.bodyLarge),
                const SizedBox(height: 20),
                FilledButton(onPressed: () => choose('ml'), child: const Text('മലയാളം')),
                const SizedBox(height: 12),
                OutlinedButton(onPressed: () => choose('en'), child: const Text('English')),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
