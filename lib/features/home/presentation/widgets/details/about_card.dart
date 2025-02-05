import 'package:android_popular_git_repos/features/home/presentation/widgets/details/topics_list.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/repository.dart';

class AboutCard extends StatelessWidget {
  final Repository repository;

  const AboutCard({
    super.key,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              repository.description,
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
            if (repository.topics.isNotEmpty) ...[
              const SizedBox(height: 16),
              TopicsList(topics: repository.topics),
            ],
          ],
        ),
      ),
    );
  }
}

