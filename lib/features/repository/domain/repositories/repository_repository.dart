import 'package:android_popular_git_repos/features/repository/domain/entities/repository_entity.dart';

abstract class RepositoryRepository {
  Future<List<RepositoryEntity>> getRepositories();
}