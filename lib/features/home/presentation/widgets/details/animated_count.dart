import 'package:flutter/material.dart';

class AnimatedCount extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;

  const AnimatedCount({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value.toDouble()),
      duration: const Duration(seconds: 2),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Column(
          children: [
            Icon(icon, size: 24, color: theme.colorScheme.primary),
            const SizedBox(height: 8),
            Text(
              value.toInt().toString(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
          ],
        );
      },
    );
  }
}
