import 'package:flutter/material.dart';

import '../../../domain/entities/repository.dart';
import 'about_card.dart';
import 'animated_count.dart';

class OverviewTab extends StatelessWidget {
  final Repository repository;

  const OverviewTab({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AnimatedCount(
                    label: 'Stars',
                    value: repository.starCount,
                    icon: Icons.star,
                  ),
                  AnimatedCount(
                    label: 'Forks',
                    value: repository.forksCount,
                    icon: Icons.fork_right,
                  ),
                  AnimatedCount(
                    label: 'Issues',
                    value: repository.openIssuesCount,
                    icon: Icons.bug_report,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          AboutCard(repository: repository),
        ],
      ),
    );
  }
}


