
// lib/features/repository_details/presentation/widgets/topics_list.dart
import 'package:flutter/material.dart';

class TopicsList extends StatelessWidget {
  final List<String> topics;

  const TopicsList({
    super.key,
    required this.topics,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Wrap(
      spacing: 5,
      runSpacing: 0,
      children: topics.map((topic) {
        return Chip(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          label: Text(
            topic,

            style: TextStyle(color: theme.colorScheme.primary,
            fontSize: theme.textTheme.bodySmall!.fontSize
            ),
          ),
          backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
        );
      }).toList(),
    );
  }
}