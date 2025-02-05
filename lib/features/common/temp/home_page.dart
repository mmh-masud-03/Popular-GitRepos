import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:popular_git_repo/features/home/presentation/pages/repository_details_page.dart';
import 'package:popular_git_repo/features/home/presentation/providers/repositories_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:popular_git_repo/features/home/domain/entities/repository.dart';
import 'package:popular_git_repo/features/home/presentation/widgets/custom_drawer.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
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
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
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

    return Scaffold(
      drawer: CustomDrawer(),
      drawerDragStartBehavior: DragStartBehavior.down,
      drawerScrimColor: Colors.black.withOpacity(0.5),
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 120,
              floating: true,
              pinned: true,
              collapsedHeight:
              60, // Added to ensure minimum height when collapsed
              elevation: innerBoxIsScrolled ? 4 : 0,
              flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final bool isCollapsed = constraints.maxHeight <= 120;
                  return FlexibleSpaceBar(
                    titlePadding: EdgeInsets.only(
                      left: 16,
                      bottom: isCollapsed
                          ? 16
                          : 76, // Adjust bottom padding based on collapse state
                    ),
                    centerTitle: true,
                    title: Text(
                      'Popular Git Repos',
                      style: TextStyle(
                        color: isCollapsed
                            ? theme.textTheme.titleLarge?.color
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
                            theme.primaryColor,
                            theme.primaryColor.withOpacity(0.8),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: Container(
                  height: 60,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    onChanged: (value) => setState(() => _searchQuery = value),
                    decoration: InputDecoration(
                      hintText: 'Search repositories...',
                      filled: true,
                      fillColor: theme.scaffoldBackgroundColor,
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: (){
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                          _searchFocusNode.unfocus();
                        },
                      )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () =>
                      ref.read(repositoriesProvider.notifier).refresh(),
                  tooltip: 'Refresh repositories',
                ),
              ],
            )
          ];
        },
        body: repositoriesState.when(
          data: (repositories) {
            final filteredRepos = _filterRepositories(repositories);
            return filteredRepos.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off,
                      size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No repositories found',
                    style: theme.textTheme.titleLarge
                        ?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            )
                : FadeTransition(
              opacity: _fadeController,
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 8),
                itemCount: filteredRepos.length,
                itemBuilder: (context, index) {
                  final repository = filteredRepos[index];
                  return _RepositoryCard(
                    repository: repository,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RepositoryDetailsPage(
                              repository: repository),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline,
                    size: 64, color: theme.colorScheme.error),
                const SizedBox(height: 16),
                Text(
                  'Something went wrong',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 3),
                Text("Check your internet connection"),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () =>
                      ref.read(repositoriesProvider.notifier).refresh(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try again'),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _showScrollToTop
          ? FloatingActionButton(
        onPressed: () {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        },
        child: const Icon(Icons.arrow_upward),
      )
          : null,
    );
  }
}

class _RepositoryCard extends StatelessWidget {
  final Repository repository;
  final VoidCallback onTap;

  const _RepositoryCard({
    required this.repository,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Hero(
                    tag: 'avatar-${repository.id}',
                    child: CircleAvatar(
                      radius: 24,
                      backgroundImage: repository.owner.avatarUrl.isNotEmpty
                          ? CachedNetworkImageProvider(
                          repository.owner.avatarUrl)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          repository.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          repository.owner.login,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            _formatNumber(repository.starCount),
                            style: theme.textTheme.titleMedium,
                          ),
                        ],
                      ),
                      if (repository.language.isNotEmpty)
                        Text(
                          repository.language,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              if (repository.description.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  repository.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildStat(
                      Icons.fork_right, _formatNumber(repository.forksCount)),
                  const SizedBox(width: 16),
                  _buildStat(Icons.bug_report,
                      _formatNumber(repository.openIssuesCount)),
                  const Spacer(),
                  if (repository.topics.isNotEmpty)
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: repository.topics.take(3).map((topic) {
                            return Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: theme.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                topic,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: theme.primaryColor,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(value, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    }
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}