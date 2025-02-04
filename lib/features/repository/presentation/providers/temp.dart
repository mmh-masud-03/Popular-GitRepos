// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:android_popular_git_repos/core/network/api_service.dart'; // Import the existing ApiService
// import 'package:android_popular_git_repos/core/network/network_info.dart'; // Import existing NetworkInfo
// import '../../data/datasources/local_data_source.dart';
// import '../../data/datasources/remote_data_source.dart';
// import '../../data/models/repository_model.dart';
// import '../../domain/entities/repository_entity.dart';
// import '../../domain/repositories/repository_repository.dart';
// import '../../domain/usecases/get_repositories.dart';
//
//
// // Providers for dependencies
// final apiServiceProvider = Provider<ApiService>((ref) => ApiService());
//
// final networkInfoProvider = Provider<NetworkInfo>((ref) {
//   return NetworkInfo(Connectivity());
// });
//
// // Remote Data Source Provider
// final remoteDataSourceProvider = Provider<RemoteDataSource>((ref) {
//   final apiService = ref.watch(apiServiceProvider);
//   return RemoteDataSourceImpl(apiService);
// });
//
// // Local Data Source Provider
// final localDataSourceProvider = Provider<LocalDataSource>((ref) {
//   return LocalDataSourceImpl();
// });
//
// // Repository Provider
// final repositoryRepositoryProvider = Provider<RepositoryRepository>((ref) {
//   final remoteDataSource = ref.watch(remoteDataSourceProvider);
//   final localDataSource = ref.watch(localDataSourceProvider);
//   final networkInfo = ref.watch(networkInfoProvider);
//
//   return RepositoryRepositoryImpl(
//     remoteDataSource: remoteDataSource,
//     localDataSource: localDataSource,
//     networkInfo: networkInfo,
//   );
// });
//
// // Get Repositories Use Case Provider
// final getRepositoriesProvider = Provider<GetRepositories>((ref) {
//   final repository = ref.watch(repositoryRepositoryProvider);
//   return GetRepositories(repository);
// });
//
// // Main Repository Provider
// final repositoryProvider = FutureProvider<List<RepositoryEntity>>((ref) async {
//   final getRepositories = ref.watch(getRepositoriesProvider);
//   final localDataSource = ref.watch(localDataSourceProvider);
//   final networkInfo = ref.watch(networkInfoProvider);
//
//   try {
//     final cachedRepositories = await localDataSource.getCachedRepositories();
//     print('Cached repositories count: ${cachedRepositories.length}');
//
//     // Check network connection
//     if (await networkInfo.isConnected) {
//       // Determine if data needs updating
//       final shouldUpdate = await localDataSource.shouldUpdateData();
//       print('Should update data: $shouldUpdate');
//
//       if (shouldUpdate || cachedRepositories.isEmpty) {
//         try {
//           // Fetch and cache new repositories
//           final repositories = await getRepositories();
//
//           print('Fetched repositories count: ${repositories.length}');
//
//           if (repositories.isNotEmpty) {
//             // Convert to models and cache
//             final repositoryModels = repositories
//                 .map((e) => RepositoryModel.fromEntity(e))
//                 .toList();
//
//             await localDataSource.cacheRepositories(repositoryModels);
//             await localDataSource.updateLastUpdateTime();
//
//             return repositories;
//           }
//         } catch (e, stackTrace) {
//           print('Error fetching repositories: $e');
//           print('Stacktrace: $stackTrace');
//
//           // Fallback to cached data if fetch fails
//           return cachedRepositories.map((e) => e.toEntity()).toList();
//         }
//       }
//     }
//
//     // Return cached repositories if no update needed
//     return cachedRepositories.map((e) => e.toEntity()).toList();
//   } catch (e) {
//     print('Unexpected error in repository provider: $e');
//     return [];
//   }
// });
//
