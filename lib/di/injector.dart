import 'package:get_it/get_it.dart';
import 'package:android_popular_git_repos/core/network/api_service.dart';
import 'package:android_popular_git_repos/core/network/network_info.dart';
import 'package:android_popular_git_repos/features/repository/data/datasources/local_data_source.dart';
import 'package:android_popular_git_repos/features/repository/data/datasources/remote_data_source.dart';
import 'package:android_popular_git_repos/features/repository/domain/repositories/repository_repository.dart';
import 'package:android_popular_git_repos/features/repository/domain/usecases/get_repositories.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Core
  sl.registerLazySingleton(() => ApiService());
  sl.registerLazySingleton(() => NetworkInfo(Connectivity()));

  // Data Sources
  sl.registerLazySingleton<RemoteDataSource>(() => RemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<LocalDataSource>(() => LocalDataSourceImpl());

  // Repository
  sl.registerLazySingleton<RepositoryRepository>(
        () => RepositoryRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetRepositories(sl()));
}