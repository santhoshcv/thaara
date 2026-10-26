import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router.dart';
import '../../core/theme.dart';
import '../../l10n/strings.dart';
import '../../models/reading.dart';
import '../../state/providers.dart';
import '../../state/reading_draft.dart';
import '../../widgets/starfield.dart';
import '../../widgets/support_card.dart';

/// The reading that was just made.
class ResultScreen extends ConsumerWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(readingDraftProvider);
    final result = draft?.result;
    if (result == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => context.go(Routes.home));
      return const SizedBox.shrink();
    }
    return ReadingView(result: result, question: draft!.question, onClose: () {
      ref.read(readingDraftProvider.notifier).clear();
      context.go(Routes.home);
    });
  }
}

/// A reading opened from history.
class PastReadingScreen extends ConsumerWidget {
  const PastReadingScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    return ref.watch(readingByIdProvider(id)).when(
          loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
          error: (_, __) => Scaffold(appBar: AppBar(), body: Center(child: Text(s.errorGeneric))),
          data: (r) => r == null
              ? Scaffold(appBar: AppBar(), body: Center(child: Text(s.errorGeneric)))
              : ReadingView(result: r.result, question: r.question, onClose: () => context.pop()),
        );
  }
}

class ReadingView extends StatelessWidget {
  const ReadingView({super.key, required this.result, required this.question, required this.onClose});

  final ReadingResult result;
  final String question;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(leading: IconButton(icon: const Icon(Icons.close), onPressed: onClose)),
      extendBodyBehindAppBar: true,
      body: Starfield(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              if (result.safetyFlag) ...[
                const SupportCard(emphasised: true),
                const SizedBox(height: 20),
              ],
              if (question.isNotEmpty) ...[
                Text('“$question”',
                    style: text.titleMedium?.copyWith(
                        color: ThaaraColors.mist, fontStyle: FontStyle.italic)),
                const SizedBox(height: 16),
              ],
              Text(result.summary, style: text.bodyLarge?.copyWith(height: 1.65)),
              const SizedBox(height: 24),
              for (final c in result.cards) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(c.position.toUpperCase(),
                            style: text.labelSmall
                                ?.copyWith(color: ThaaraColors.gold, letterSpacing: 1.2)),
                        const SizedBox(height: 4),
                        Text(c.card, style: text.titleLarge),
                        const SizedBox(height: 8),
                        Text(c.insight, style: text.bodyMedium?.copyWith(height: 1.6)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              if (result.reflectionQuestion.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: ThaaraColors.gold),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.reflectionQuestion,
                          style: text.labelLarge?.copyWith(color: ThaaraColors.gold)),
                      const SizedBox(height: 8),
                      Text(result.reflectionQuestion, style: text.titleMedium),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () => context.push(Routes.newEntry(readingId: result.id)),
                icon: const Icon(Icons.edit_outlined),
                label: Text(s.writeReflection),
              ),
              const SizedBox(height: 20),
              Text(s.disclaimer,
                  textAlign: TextAlign.center,
                  style: text.bodySmall?.copyWith(color: ThaaraColors.mist)),
            ],
          ),
        ),
      ),
    );
  }
}
