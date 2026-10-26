import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/router.dart';
import '../../core/theme.dart';
import '../../l10n/strings.dart';
import '../../state/providers.dart';
import '../../widgets/starfield.dart';
import 'journal_editor_screen.dart';

class JournalScreen extends ConsumerWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final text = Theme.of(context).textTheme;
    final entries = ref.watch(journalProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(Routes.newEntry()),
        icon: const Icon(Icons.add),
        label: Text(s.newEntry),
      ),
      body: Starfield(
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () => ref.refresh(journalProvider.future),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 32, 20, 96),
              children: [
                Text(s.journalTitle, style: text.headlineMedium),
                const SizedBox(height: 20),
                entries.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (_, __) => Text(s.offline),
                  data: (items) => items.isEmpty
                      ? Text(s.journalEmpty,
                          style: text.bodyMedium?.copyWith(color: ThaaraColors.mist))
                      : Column(
                          children: [
                            for (final e in items)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(DateFormat.yMMMd(lang).add_jm().format(e.createdAt),
                                                style: text.labelSmall
                                                    ?.copyWith(color: ThaaraColors.mist)),
                                            const Spacer(),
                                            if (e.mood != null)
                                              Text(moods[e.mood!.clamp(0, moods.length - 1)]),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(e.body, style: text.bodyMedium?.copyWith(height: 1.55)),
                                        if (e.readingId != null)
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: IconButton(
                                              icon: const Icon(Icons.style_outlined,
                                                  color: ThaaraColors.gold),
                                              onPressed: () =>
                                                  context.push(Routes.pastReading(e.readingId!)),
                                            ),
                                          ),
                                      ],
                                    ),
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
      ),
    );
  }
}
