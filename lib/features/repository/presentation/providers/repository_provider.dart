import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../di/injector.dart';
import '../../domain/entities/repository_entity.dart';
import '../../domain/usecases/get_repositories.dart';

final repositoryProvider = FutureProvider<List<RepositoryEntity>>((ref) async {
  final getRepositories = ref.watch(getRepositoriesProvider);
  try {
    return await getRepositories.call();
  } catch (e, stackTrace) {
    // Log the error and stack trace for better debugging
    print('Error loading repositories: $e');
    print('Stack trace: $stackTrace');
    throw Exception("Failed to load repositories");
  }
});

final getRepositoriesProvider = Provider<GetRepositories>((ref) {
  // Assuming GetRepositories is registered in the DI container
  return sl<GetRepositories>();
});