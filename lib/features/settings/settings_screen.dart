import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/env.dart';
import '../../core/router.dart';
import '../../core/theme.dart';
import '../../l10n/strings.dart';
import '../../state/providers.dart';
import '../../widgets/starfield.dart';
import '../../widgets/support_card.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final s = S.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(s.deleteConfirmTitle),
        content: Text(s.deleteConfirmBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(s.cancel)),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: ThaaraColors.rose),
            child: Text(s.delete),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(repositoryProvider).deleteEverything();
      await ref.read(onboardingProvider.notifier).reset();
      if (context.mounted) context.go(Routes.intro);
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(s.errorGeneric)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    final text = Theme.of(context).textTheme;
    final locale = ref.watch(localeProvider);

    return Starfield(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 32, 20, 32),
          children: [
            Text(s.settingsTitle, style: text.headlineMedium),
            const SizedBox(height: 20),
            Text(s.language, style: text.titleMedium),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'ml', label: Text('മലയാളം')),
                ButtonSegment(value: 'en', label: Text('English')),
              ],
              selected: {locale?.languageCode ?? 'en'},
              onSelectionChanged: (v) =>
                  ref.read(localeProvider.notifier).set(Locale(v.first)),
            ),
            const SizedBox(height: 28),
            const SupportCard(),
            const SizedBox(height: 20),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: Text(s.about),
                    subtitle: Text(s.disclaimer),
                  ),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip_outlined),
                    title: Text(s.privacyPolicy),
                    trailing: const Icon(Icons.open_in_new, size: 18),
                    onTap: () => launchUrl(Uri.parse('${Env.siteUrl}/privacy'),
                        mode: LaunchMode.externalApplication),
                  ),
                  ListTile(
                    leading: const Icon(Icons.delete_outline, color: ThaaraColors.rose),
                    title: Text(s.deleteData, style: const TextStyle(color: ThaaraColors.rose)),
                    onTap: () => _confirmDelete(context, ref),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
