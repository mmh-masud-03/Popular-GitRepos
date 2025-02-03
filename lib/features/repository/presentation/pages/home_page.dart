import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
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
  bool _showNoInternetMessage = false;
  late Connectivity _connectivity;
  late Stream<ConnectivityResult> _connectivityStream;

  @override
  void initState() {
    super.initState();
    _connectivity = Connectivity();
    _connectivityStream = _connectivity.onConnectivityChanged.expand((results) => results);
    _listenToInternetChanges();
    _refreshDataIfNeeded();
  }

  /// **Listen for internet changes and refresh data automatically**
  void _listenToInternetChanges() {
    _connectivityStream.listen((ConnectivityResult result) async {
      if (result != ConnectivityResult.none) {
        _refreshDataIfNeeded();
      }
    });
  }

  /// **Refresh Data Logic**
  Future<void> _refreshDataIfNeeded() async {
    final localDataSource = ref.read(localDataSourceProvider);
    final networkInfo = ref.read(networkInfoProvider);

    final isConnected = await networkInfo.isConnected;
    final localData = await localDataSource.getCachedRepositories();

    if (localData.isEmpty && !isConnected) {
      // No local data and no internet -> Show error message
      setState(() {
        _showNoInternetMessage = true;
      });
      return;
    }

    if (isConnected ) {
      final shouldUpdate = await localDataSource.shouldUpdateData();
      if (shouldUpdate) {
        ref.invalidate(repositoryProvider); // Refresh repositories
        setState(() {
          _showNoInternetMessage = false; // Hide error message
        });
      }
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
      body: _showNoInternetMessage
          ? const Center(child: Text('Please check your internet connection.'))
          : repoAsyncValue.when(
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

                leading: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(repo.ownerAvatarUrl),
                ),
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

  @override
  void dispose() {
    super.dispose();
  }
}