import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../di/injector.dart';
import '../../../common/presentation/widgets/custom_drawer.dart';
import '../providers/repository_provider.dart';
import 'details_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    _refreshDataIfNeeded();
  }

  Future<void> _refreshDataIfNeeded() async {
    final localDataSource = ref.read(localDataSourceProvider);
    final networkInfo = ref.read(networkInfoProvider);

    final isConnected = await networkInfo.isConnected;
    final shouldUpdate = await localDataSource.shouldUpdateData();

    if (isConnected && shouldUpdate) {
      ref.invalidate(repositoryProvider); // Refresh repository provider
    }
  }

  @override
  Widget build(BuildContext context) {
    final repoAsyncValue = ref.watch(repositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.appName),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: () {
              final currentTheme = ref.read(themeProvider);
              ref.read(themeProvider.notifier).state =
              currentTheme == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
            },
          ),
        ],
      ),
      drawer: CustomDrawer(
        onAllRepositoriesTap: () {},
        onFavoritesTap: () {},
      ),
      body: repoAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
        data: (repositories) {
          if (repositories.isEmpty) {
            return const Center(child: Text('No repositories found.'));
          }
          return ListView.builder(
            itemCount: repositories.length,
            itemBuilder: (context, index) {
              final repo = repositories[index];
              return ListTile(
                title: Text(repo.name),
                subtitle: Text(repo.description),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RepoDetailsPage(repository: repo),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
