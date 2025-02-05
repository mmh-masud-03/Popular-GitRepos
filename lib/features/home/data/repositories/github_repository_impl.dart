import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/repository.dart';
import '../../domain/repositories/github_repository.dart';
import '../datasources/local/database_helper.dart';
import '../models/repository_model.dart';

class GitHubRepositoryImpl implements GitHubRepository {
  final ApiClient apiClient;
  final DatabaseHelper databaseHelper;

  GitHubRepositoryImpl({
    required this.apiClient,
    required this.databaseHelper,
  });

  @override
  Future<Either<Failure, List<Repository>>> getAndroidRepositories() async {
    try {
      // Check if we need to fetch from API
      final shouldFetch = await databaseHelper.shouldFetchFromApi();

      if (!shouldFetch) {
        // Return cached data if within 2-hour window
        print('Returning cached data');
        final localData = await databaseHelper.getRepositories();
        if (localData.isNotEmpty) {
          final repositories = localData
              .map((item) => RepositoryModel.fromDb(item))
              .toList();
          return Right(repositories);
        }
      }

      // Fetch from API if needed or if cache is empty
      final response = await apiClient.get(
        '/search/repositories?q=Android&sort=stars&order=desc',
      );

      final List<RepositoryModel> repositories = (response['items'] as List)
          .map((item) => RepositoryModel.fromJson(item))
          .toList();

      // Update cache and sync time
      await databaseHelper.clearRepositories();
      for (var repo in repositories) {
        await databaseHelper.insertRepository(repo.toDb());
      }
      await databaseHelper.updateLastSyncTime();
      print('Returning data from API');
      return Right(repositories);
    } catch (e) {
      try {
        // Fallback to cached data in case of error
        final localData = await databaseHelper.getRepositories();
        if (localData.isEmpty) {
          return const Left(CacheFailure('No cached data available'));
        }
        final repositories = localData
            .map((item) => RepositoryModel.fromDb(item))
            .toList();
        return Right(repositories);
      } catch (e) {
        return const Left(CacheFailure('Failed to get repositories'));
      }
    }
  }
  @override
  Future<Either<Failure, List<Repository>>> forceRefresh() async {
    try {
      // Clear last sync time
      final db = await databaseHelper.database;
      await db.delete(
        'metadata',
        where: 'key = ?',
        whereArgs: ['last_sync_time'],
      );

      // Fetch fresh data from API
      final response = await apiClient.get(
        '/search/repositories?q=Android&sort=stars&order=desc',
      );

      final List<RepositoryModel> repositories = (response['items'] as List)
          .map((item) => RepositoryModel.fromJson(item))
          .toList();

      // Update cache and sync time
      await databaseHelper.clearRepositories();
      for (var repo in repositories) {
        await databaseHelper.insertRepository(repo.toDb());
      }
      await databaseHelper.updateLastSyncTime();

      return Right(repositories);
    } catch (e) {
      return Left(ServerFailure('Failed to refresh repositories'));
    }
  }
}
