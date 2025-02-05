import 'package:flutter/material.dart';

import '../../../domain/entities/repository.dart';
import 'feature_item.dart';

class FeaturesTab extends StatelessWidget {
  final Repository repository;

  const FeaturesTab({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 2,
        child: Column(
          children: [
            FeatureItem(
              icon: Icons.bug_report,
              label: 'Issues',
              enabled: repository.hasIssues,
            ),
            const Divider(height: 1),
            FeatureItem(
              icon: Icons.book,
              label: 'Wiki',
              enabled: repository.hasWiki,
            ),
            const Divider(height: 1),
            FeatureItem(
              icon: Icons.view_kanban,
              label: 'Projects',
              enabled: repository.hasProjects,
            ),
            const Divider(height: 1),
            FeatureItem(
              icon: Icons.forum,
              label: 'Discussions',
              enabled: repository.hasDiscussions,
            ),
            const Divider(height: 1),
            FeatureItem(
              icon: Icons.download,
              label: 'Downloads',
              enabled: repository.hasDownloads,
            ),
          ],
        ),
      ),
    );
  }
}
