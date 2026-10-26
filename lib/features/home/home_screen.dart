import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/router.dart';
import '../../core/theme.dart';
import '../../data/spreads.dart';
import '../../l10n/strings.dart';
import '../../state/providers.dart';
import '../../widgets/starfield.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final text = Theme.of(context).textTheme;
    final readings = ref.watch(recentReadingsProvider);

    return Starfield(
      child: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.refresh(recentReadingsProvider.future),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
            children: [
              Text('✶  ${s.appName}', style: text.titleLarge?.copyWith(color: ThaaraColors.gold)),
              const SizedBox(height: 28),
              Text(s.homeGreeting, style: text.headlineMedium),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () => context.push(Routes.newReading),
                icon: const Icon(Icons.style_outlined),
                label: Text(s.startReading),
              ),
              const SizedBox(height: 36),
              Text(s.recentReadings, style: text.titleMedium),
              const SizedBox(height: 12),
              readings.when(
                loading: () => const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (_, __) => _Message(
                  text: s.offline,
                  action: TextButton(
                    onPressed: () => ref.invalidate(recentReadingsProvider),
                    child: Text(s.retry),
                  ),
                ),
                data: (items) => items.isEmpty
                    ? _Message(text: s.noReadingsYet)
                    : Column(
                        children: [
                          for (final r in items)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Card(
                                child: ListTile(
                                  contentPadding:
                                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                  title: Text(
                                    r.question.isNotEmpty
                                        ? r.question
                                        : spreadById(r.spreadId).title(lang),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Text(
                                    DateFormat.yMMMd(lang).format(r.createdAt),
                                    style: text.bodySmall?.copyWith(color: ThaaraColors.mist),
                                  ),
                                  trailing: const Icon(Icons.chevron_right),
                                  onTap: () => context.push(Routes.pastReading(r.id)),
                                ),
                              ),
                            ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.text, this.action});

  final String text;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Text(text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: ThaaraColors.mist)),
          if (action != null) action!,
        ],
      ),
    );
  }
}
