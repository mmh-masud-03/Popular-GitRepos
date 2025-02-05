import 'package:android_popular_git_repos/features/home/presentation/widgets/home/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/repositories_provider.dart';

class HomeAppBar extends StatelessWidget {
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onRefresh;

  const HomeAppBar({
    super.key,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      pinned: true,
      collapsedHeight: 60,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.white),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final bool isCollapsed = constraints.maxHeight <= 120;
          return FlexibleSpaceBar(
            titlePadding: EdgeInsets.only(
              left: 16,
              bottom: isCollapsed ? 16 : 76, // Adjust bottom padding based on collapse state
            ),
            centerTitle: true,
            title: Text(
              'Popular Git Repos',
              style: TextStyle(
                color: isCollapsed
                    ? Theme.of(context).textTheme.titleLarge?.color
                    : Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withOpacity(0.8),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SearchBarWidget(
          searchQuery: searchQuery,
          onSearchChanged: onSearchChanged,
        ),
      ),

      actions: [
        Consumer(
          builder: (context, ref, child) {
            return IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: () => ref.read(repositoriesProvider.notifier).refresh(),
              tooltip: 'Refresh repositories',
            );
          },
        ),
      ],
    );
  }
}