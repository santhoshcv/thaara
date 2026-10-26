import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/strings.dart';

class HomeShell extends StatelessWidget {
  const HomeShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: (i) => shell.goBranch(i, initialLocation: i == shell.currentIndex),
        destinations: [
          NavigationDestination(icon: const Icon(Icons.auto_awesome_outlined), label: s.navHome),
          NavigationDestination(icon: const Icon(Icons.menu_book_outlined), label: s.navJournal),
          NavigationDestination(icon: const Icon(Icons.tune_outlined), label: s.navSettings),
        ],
      ),
    );
  }
}
