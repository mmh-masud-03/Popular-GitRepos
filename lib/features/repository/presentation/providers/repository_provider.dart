import 'package:android_popular_git_repos/features/repository/data/models/repository_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../di/injector.dart';
import '../../domain/entities/repository_entity.dart';
import '../../domain/usecases/get_repositories.dart';

final repositoryProvider = FutureProvider<List<RepositoryEntity>>((ref) async {
  final getRepositories = ref.watch(getRepositoriesProvider);
  final localDataSource = ref.watch(localDataSourceProvider);
  final networkInfo = ref.watch(networkInfoProvider);

  final cachedRepositories = await localDataSource.getCachedRepositories();

  // Return local data if available
  if (cachedRepositories.isNotEmpty) {
    // Check if we should update the data
    if (await networkInfo.isConnected && await localDataSource.shouldUpdateData()) {
      print('Updating data...');
      try {
        final repositories = await getRepositories.call();
        final repositoryModels = repositories.map((e) => RepositoryModel.fromEntity(e)).toList();

        // Cache new data and update last update time
        await localDataSource.cacheRepositories(repositoryModels);
        //  Update last update time after successful API call
        await localDataSource.updateLastUpdateTime();
        return repositories;
      } catch (e, stackTrace) {
        print('Error loading repositories: $e');
        print('Stack trace: $stackTrace');
      }
    }
    print('Returning cached data...');
    return cachedRepositories.map((e) => e.toEntity()).toList();
  }

  // If no local data, fetch from API (only if connected)
  if (await networkInfo.isConnected) {
    print('Fetching data from API...');
    try {
      final repositories = await getRepositories.call();
      final repositoryModels = repositories.map((e) => RepositoryModel.fromEntity(e)).toList();
      await localDataSource.cacheRepositories(repositoryModels);
      // Update last update time after successful API call
      await localDataSource.updateLastUpdateTime();
      return repositories;
    } catch (e, stackTrace) {
      print('Error loading repositories: $e');
      print('Stack trace: $stackTrace');
    }
  }
print('Returning empty list...');
  return [];
});

final getRepositoriesProvider = Provider<GetRepositories>((ref) {
  // Assuming GetRepositories is registered in the DI container
  return sl<GetRepositories>();
});