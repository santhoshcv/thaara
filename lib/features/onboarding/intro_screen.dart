import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router.dart';
import '../../core/theme.dart';
import '../../l10n/strings.dart';
import '../../state/providers.dart';
import '../../widgets/starfield.dart';

class IntroScreen extends ConsumerStatefulWidget {
  const IntroScreen({super.key});

  @override
  ConsumerState<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends ConsumerState<IntroScreen> {
  bool _confirmed = false;
  bool _busy = false;
  String? _error;

  Future<void> _begin() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref.read(onboardingProvider.notifier).complete();
      if (mounted) context.go(Routes.home);
    } catch (_) {
      if (mounted) setState(() => _error = S.of(context).offline);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final text = Theme.of(context).textTheme;

    return Scaffold(
      body: Starfield(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
            children: [
              const Text('✶', textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 44, color: ThaaraColors.gold)),
              const SizedBox(height: 16),
              Text(s.introTitle, textAlign: TextAlign.center, style: text.headlineMedium),
              const SizedBox(height: 20),
              Text(s.introBody, style: text.bodyLarge?.copyWith(height: 1.6)),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(Icons.lock_outline, color: ThaaraColors.gold, size: 20),
                  const SizedBox(width: 10),
                  Expanded(child: Text(s.introPrivacy, style: text.bodyMedium)),
                ],
              ),
              const SizedBox(height: 28),
              CheckboxListTile(
                value: _confirmed,
                onChanged: (v) => setState(() => _confirmed = v ?? false),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                title: Text(s.ageConfirm, style: text.bodyMedium),
              ),
              const SizedBox(height: 20),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(_error!, style: const TextStyle(color: ThaaraColors.rose)),
                ),
              FilledButton(
                onPressed: _confirmed && !_busy ? _begin : null,
                child: _busy
                    ? const SizedBox(
                        height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(s.begin),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
