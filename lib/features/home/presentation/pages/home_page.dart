import 'package:android_popular_git_repos/features/home/presentation/widgets/common/custom_loader.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/repository.dart';
import '../providers/repositories_provider.dart';
import '../widgets/common/custom_drawer.dart';
import '../widgets/home/error_view.dart';
import '../widgets/home/home_app_bar.dart';
import '../widgets/home/repository_list_view.dart';
import '../widgets/home/scroll_to_top_button.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTop = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scrollController.addListener(_onScroll);
    _fadeController.forward();
  }

  void _onScroll() {
    final showScrollToTop = _scrollController.offset > 300;
    if (showScrollToTop != _showScrollToTop) {
      setState(() => _showScrollToTop = showScrollToTop);
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _updateSearchQuery(String query) {
    setState(() => _searchQuery = query);
  }

  List<Repository> _filterRepositories(List<Repository> repositories) {
    if (_searchQuery.isEmpty) return repositories;
    return repositories.where((repo) {
      return repo.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          repo.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          repo.owner.login.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final repositoriesState = ref.watch(repositoriesProvider);
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        drawer: const CustomDrawer(),

        drawerDragStartBehavior: DragStartBehavior.down,
        drawerScrimColor: Colors.black.withOpacity(0.5),
        body: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              HomeAppBar(
                searchQuery: _searchQuery,
                onSearchChanged: _updateSearchQuery,
                onRefresh: () => ref.read(repositoriesProvider.notifier).refresh(),
              ),
            ];
          },
          body: repositoriesState.when(
            data: (repositories) => RepositoryListView(
              repositories: _filterRepositories(repositories),
              fadeController: _fadeController,
            ),
            loading: () => const Center(child: CustomLoader(size: 50,)),
            error: (error, stack) => ErrorView(
              onRetry: () => ref.read(repositoriesProvider.notifier).refresh(),
            ),
          ),
        ),
        floatingActionButton: _showScrollToTop
            ? ScrollToTopButton(scrollController: _scrollController)
            : null,
      ),
    );
  }
}