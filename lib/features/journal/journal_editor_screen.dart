import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme.dart';
import '../../l10n/strings.dart';
import '../../state/providers.dart';
import '../../widgets/starfield.dart';

/// Mood scale stored as 0–4.
const moods = ['😢', '😟', '😐', '🙂', '😊'];

class JournalEditorScreen extends ConsumerStatefulWidget {
  const JournalEditorScreen({super.key, this.readingId});

  final String? readingId;

  @override
  ConsumerState<JournalEditorScreen> createState() => _JournalEditorScreenState();
}

class _JournalEditorScreenState extends ConsumerState<JournalEditorScreen> {
  final _body = TextEditingController();
  int? _mood;
  bool _saving = false;

  @override
  void dispose() {
    _body.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final s = S.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _saving = true);
    try {
      await ref.read(repositoryProvider).addJournalEntry(
            body: _body.text,
            mood: _mood,
            readingId: widget.readingId,
          );
      ref.invalidate(journalProvider);
      messenger.showSnackBar(SnackBar(content: Text(s.saved)));
      if (mounted) context.pop();
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(s.errorGeneric)));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(s.newEntry)),
      extendBodyBehindAppBar: true,
      body: Starfield(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              Text(s.moodPrompt, style: text.titleMedium),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (var i = 0; i < moods.length; i++)
                    GestureDetector(
                      onTap: () => setState(() => _mood = i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _mood == i ? ThaaraColors.plum : Colors.transparent,
                          border: Border.all(
                              color: _mood == i ? ThaaraColors.gold : Colors.transparent),
                        ),
                        child: Text(moods[i], style: const TextStyle(fontSize: 30)),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _body,
                minLines: 8,
                maxLines: 20,
                maxLength: 5000,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(hintText: s.entryHint),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: _body.text.trim().isEmpty || _saving ? null : _save,
                child: Text(s.save),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
