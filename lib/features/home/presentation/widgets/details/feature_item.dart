import 'package:flutter/material.dart';

class FeatureItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool enabled;

  const FeatureItem({
    super.key,
    required this.icon,
    required this.label,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(
        icon,
        color: enabled ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: enabled ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: Icon(
        enabled ? Icons.check_circle : Icons.cancel,
        color: enabled ? Colors.green : theme.colorScheme.onSurfaceVariant,
        size: 20,
      ),
    );
  }
}
