import 'dart:math';

import 'package:flutter/material.dart';

import '../core/theme.dart';

/// Quiet night-sky backdrop used behind every screen.
class Starfield extends StatelessWidget {
  const Starfield({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0, -1.2),
                radius: 1.6,
                colors: [ThaaraColors.plum, ThaaraColors.night],
              ),
            ),
          ),
        ),
        const Positioned.fill(child: RepaintBoundary(child: CustomPaint(painter: _StarPainter()))),
        child,
      ],
    );
  }
}

class _StarPainter extends CustomPainter {
  const _StarPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = Random(7); // fixed seed: same sky every time
    final paint = Paint();
    for (var i = 0; i < 70; i++) {
      final o = Offset(rnd.nextDouble() * size.width, rnd.nextDouble() * size.height);
      final r = rnd.nextDouble() * 1.2 + 0.3;
      paint.color = ThaaraColors.goldSoft.withValues(alpha: rnd.nextDouble() * 0.5 + 0.15);
      canvas.drawCircle(o, r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
