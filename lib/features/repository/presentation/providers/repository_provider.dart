
import 'package:android_popular_git_repos/features/repository/data/models/repository_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../di/injector.dart';
import '../../../common/temp/repository_entity.dart';
import '../../domain/usecases/get_repositories.dart';

final repositoryProvider = FutureProvider<List<RepositoryEntity>>((ref) async {
  final getRepositories = ref.watch(getRepositoriesProvider);
  final localDataSource = ref.watch(localDataSourceProvider);
  final networkInfo = ref.watch(networkInfoProvider);

  final cachedRepositories = await localDataSource.getCachedRepositories();

  // First, check network connection
  if (await networkInfo.isConnected) {
    // Check if we should update data
    if (cachedRepositories.isEmpty || await localDataSource.shouldUpdateData()) {
      try {
        // Fetch repositories from API
        final repositories = await getRepositories.call();

        // Convert to RepositoryModel before caching
        final repositoryModels = repositories.map((e) => RepositoryModel.fromEntity(e)).toList();

        // Clear existing and cache new repositories
        await localDataSource.cacheRepositories(repositoryModels);

        // Update last update time
        await localDataSource.updateLastUpdateTime();

        return repositories;
      } catch (e, stackTrace) {
        print('Error loading repositories: $e');
        print('Stack trace: $stackTrace');

        // Fallback to cached data if API call fails
        return cachedRepositories.map((e) => e.toEntity()).toList();
      }
    }
  }

  // If no network or no need to update, return cached repositories
  return cachedRepositories.map((e) => e.toEntity()).toList();
});
final getRepositoriesProvider = Provider<GetRepositories>((ref) {
  // Assuming GetRepositories is registered in the DI container
  return sl<GetRepositories>();
});