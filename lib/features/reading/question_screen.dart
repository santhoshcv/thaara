import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router.dart';
import '../../core/theme.dart';
import '../../data/spreads.dart';
import '../../l10n/strings.dart';
import '../../state/providers.dart';
import '../../state/reading_draft.dart';
import '../../widgets/starfield.dart';

class QuestionScreen extends ConsumerStatefulWidget {
  const QuestionScreen({super.key});

  @override
  ConsumerState<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends ConsumerState<QuestionScreen> {
  final _question = TextEditingController();
  final _situation = TextEditingController();
  Spread _spread = spreads[1];

  @override
  void dispose() {
    _question.dispose();
    _situation.dispose();
    super.dispose();
  }

  void _draw() {
    final cards = ref.read(drawServiceProvider).draw(_spread.positions.length);
    ref.read(readingDraftProvider.notifier).start(ReadingDraft(
          spread: _spread,
          question: _question.text,
          situation: _situation.text,
          cards: cards,
        ));
    context.pushReplacement(Routes.draw);
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(),
      extendBodyBehindAppBar: true,
      body: Starfield(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              Text(s.chooseSpread, style: text.headlineSmall),
              const SizedBox(height: 14),
              for (final sp in spreads)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _SpreadTile(
                    spread: sp,
                    lang: lang,
                    selected: sp.id == _spread.id,
                    countLabel: s.cardsCount(sp.positions.length),
                    onTap: () => setState(() => _spread = sp),
                  ),
                ),
              const SizedBox(height: 18),
              Text(s.yourQuestion, style: text.titleMedium),
              const SizedBox(height: 8),
              TextField(
                controller: _question,
                maxLength: 300,
                minLines: 2,
                maxLines: 4,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(hintText: s.questionHint),
              ),
              Text(s.questionTip, style: text.bodySmall?.copyWith(color: ThaaraColors.mist)),
              const SizedBox(height: 20),
              Text(s.situationLabel, style: text.titleMedium),
              const SizedBox(height: 8),
              TextField(
                controller: _situation,
                maxLength: 600,
                minLines: 2,
                maxLines: 5,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(hintText: s.situationHint),
              ),
              const SizedBox(height: 16),
              FilledButton(onPressed: _draw, child: Text(s.shuffleAndDraw)),
            ],
          ),
        ),
      ),
    );
  }
}

class _SpreadTile extends StatelessWidget {
  const _SpreadTile({
    required this.spread,
    required this.lang,
    required this.selected,
    required this.countLabel,
    required this.onTap,
  });

  final Spread spread;
  final String lang;
  final bool selected;
  final String countLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Material(
      color: selected ? ThaaraColors.plum : ThaaraColors.dusk,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: selected ? ThaaraColors.gold : Colors.transparent),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(spread.title(lang), style: text.titleMedium),
                    const SizedBox(height: 4),
                    Text(spread.blurb(lang),
                        style: text.bodySmall?.copyWith(color: ThaaraColors.mist)),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(countLabel, style: text.labelMedium?.copyWith(color: ThaaraColors.gold)),
            ],
          ),
        ),
      ),
    );
  }
}
