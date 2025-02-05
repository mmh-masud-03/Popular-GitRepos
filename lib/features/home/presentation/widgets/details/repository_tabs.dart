import 'package:flutter/material.dart';
import 'sliver_app_bar_delegate.dart';

class RepositoryTabs extends StatelessWidget {
  final TabController tabController;

  const RepositoryTabs({
    super.key,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverPersistentHeader(
      delegate: MySliverAppBarDelegate(
        TabBar(
          controller: tabController,
          labelColor: theme.colorScheme.primary,
          unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
          indicatorColor: theme.colorScheme.primary,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Details'),
            Tab(text: 'Features'),
          ],
        ),
      ),
      pinned: true,
    );
  }
}