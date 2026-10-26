import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/theme.dart';
import '../data/helplines.dart';
import '../l10n/strings.dart';

/// Shown at the top of a reading when it touches on danger or crisis,
/// and always available from Settings.
class SupportCard extends StatelessWidget {
  const SupportCard({super.key, this.emphasised = false});

  final bool emphasised;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final text = Theme.of(context).textTheme;

    return Card(
      color: emphasised ? ThaaraColors.plum : null,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(s.supportTitle, style: text.titleLarge),
            const SizedBox(height: 8),
            Text(s.supportBody, style: text.bodyMedium),
            const SizedBox(height: 12),
            for (final h in helplines)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.call_outlined, color: ThaaraColors.gold),
                title: Text('${lang == 'ml' ? h.nameMl : h.nameEn} · ${h.number}'),
                subtitle: Text(lang == 'ml' ? h.forMl : h.forEn),
                onTap: () => launchUrl(Uri(scheme: 'tel', path: h.number)),
              ),
          ],
        ),
      ),
    );
  }
}
