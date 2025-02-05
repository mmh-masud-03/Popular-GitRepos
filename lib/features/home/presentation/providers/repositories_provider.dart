import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../../core/network/api_client.dart';
import '../../data/datasources/local/database_helper.dart';
import '../../data/repositories/github_repository_impl.dart';
import '../../domain/entities/repository.dart';
import '../../domain/repositories/github_repository.dart';


// Provider for http.Client
final httpClientProvider = Provider<http.Client>((ref) => http.Client());

// Provider for ApiClient
final apiClientProvider = Provider<ApiClient>((ref) {
  final client = ref.watch(httpClientProvider);
  return ApiClient(client: client);
});

// Provider for DatabaseHelper
final databaseHelperProvider = Provider<DatabaseHelper>((ref) {
  return DatabaseHelper();
});

// Provider for GitHubRepository
final githubRepositoryProvider = Provider<GitHubRepository>((ref) {
  return GitHubRepositoryImpl(
    apiClient: ref.watch(apiClientProvider),
    databaseHelper: ref.watch(databaseHelperProvider),
  );
});

// StateNotifier provider for repositories
final repositoriesProvider =
StateNotifierProvider<RepositoriesNotifier, AsyncValue<List<Repository>>>(
      (ref) => RepositoriesNotifier(
    repository: ref.watch(githubRepositoryProvider),
  ),
);

class RepositoriesNotifier extends StateNotifier<AsyncValue<List<Repository>>> {
  final GitHubRepository repository;

  RepositoriesNotifier({required this.repository})
      : super(const AsyncValue.loading()) {
    fetchRepositories();
  }

  Future<void> fetchRepositories() async {
    state = const AsyncValue.loading();
    final result = await repository.getAndroidRepositories();
    state = result.fold(
          (failure) => AsyncValue.error(failure, StackTrace.current),
          (repositories) => AsyncValue.data(repositories),
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    final result = await repository.forceRefresh();
    state = result.fold(
          (failure) => AsyncValue.error(failure, StackTrace.current),
          (repositories) => AsyncValue.data(repositories),
    );
  }
}
