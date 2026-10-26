import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router.dart';
import '../../core/theme.dart';
import '../../l10n/strings.dart';
import '../../services/reading_service.dart';
import '../../state/providers.dart';
import '../../state/reading_draft.dart';
import '../../widgets/starfield.dart';
import '../../widgets/tarot_card_view.dart';

class DrawScreen extends ConsumerStatefulWidget {
  const DrawScreen({super.key});

  @override
  ConsumerState<DrawScreen> createState() => _DrawScreenState();
}

class _DrawScreenState extends ConsumerState<DrawScreen> {
  final Set<int> _revealed = {};
  bool _loading = false;
  String? _error;

  Future<void> _read() async {
    final draft = ref.read(readingDraftProvider);
    if (draft == null) return;
    final s = S.of(context);
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await ref.read(readingServiceProvider).requestReading(
            spread: draft.spread,
            cards: draft.cards,
            question: draft.question,
            situation: draft.situation,
            languageCode: Localizations.localeOf(context).languageCode,
          );
      ref.read(readingDraftProvider.notifier).setResult(result);
      ref.invalidate(recentReadingsProvider);
      if (mounted) context.pushReplacement(Routes.result);
    } on ReadingException catch (e) {
      if (!mounted) return;
      setState(() => _error = switch (e.kind) {
            ReadingErrorKind.dailyLimit => s.errorLimit,
            ReadingErrorKind.sameQuestion => s.errorSameQuestion,
            ReadingErrorKind.offline => s.offline,
            ReadingErrorKind.unknown => s.errorGeneric,
          });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final text = Theme.of(context).textTheme;
    final draft = ref.watch(readingDraftProvider);

    if (draft == null) {
      // Opened without a draft (e.g. app restored): go back home.
      WidgetsBinding.instance.addPostFrameCallback((_) => context.go(Routes.home));
      return const SizedBox.shrink();
    }

    final allRevealed = _revealed.length == draft.cards.length;
    final width = MediaQuery.sizeOf(context).width;
    final cardWidth = draft.cards.length <= 3 ? (width - 72) / 3 : (width - 64) / 2.4;

    return Scaffold(
      appBar: AppBar(title: Text(draft.spread.title(lang))),
      extendBodyBehindAppBar: true,
      body: Starfield(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Text(s.tapToReveal, style: text.bodyMedium?.copyWith(color: ThaaraColors.mist)),
                const Spacer(),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  runSpacing: 18,
                  children: [
                    for (final c in draft.cards)
                      SizedBox(
                        width: cardWidth,
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () => setState(() => _revealed.add(c.position)),
                              child: AspectRatio(
                                aspectRatio: 0.58,
                                child: FlipCard(
                                  revealed: _revealed.contains(c.position),
                                  front: TarotCardFace(
                                      card: c.card, reversed: c.reversed, lang: lang),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              draft.spread.positions[c.position].label(lang),
                              textAlign: TextAlign.center,
                              style: text.labelMedium?.copyWith(color: ThaaraColors.mist),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const Spacer(),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(_error!,
                        textAlign: TextAlign.center,
                        style: text.bodyMedium?.copyWith(color: ThaaraColors.rose)),
                  ),
                if (_loading)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 12),
                        Text(s.readingLoading),
                      ],
                    ),
                  )
                else
                  FilledButton(
                    onPressed: allRevealed ? _read : null,
                    child: Text(s.readMyCards),
                  ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
