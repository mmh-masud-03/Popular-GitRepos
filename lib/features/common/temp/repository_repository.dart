import 'package:android_popular_git_repos/features/repository/domain/entities/repository_entity.dart';
import '../../../core/network/network_info.dart';
import 'local_data_source.dart';
import 'remote_data_source.dart';

abstract class RepositoryRepository {
  Future<List<RepositoryEntity>> getRepositories();
}


class RepositoryRepositoryImpl implements RepositoryRepository {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  RepositoryRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<List<RepositoryEntity>> getRepositories() async {
    if (await networkInfo.isConnected) {
      // Fetch data from the remote API
      final remoteRepositories = await remoteDataSource.getRepositories();

      // Cache the data locally
      await localDataSource.cacheRepositories(remoteRepositories);

      // Map RepositoryModel to RepositoryEntity
      return remoteRepositories.map((model) => model.toEntity()).toList();
    } else {
      // Fetch data from the local database
      final cachedRepositories = await localDataSource.getCachedRepositories();

      // Map RepositoryModel to RepositoryEntity
      return cachedRepositories.map((model) => model.toEntity()).toList();
    }
  }
}