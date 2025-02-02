import '../entities/repository_entity.dart';
import '../repositories/repository_repository.dart';

class GetRepositories {
  final RepositoryRepository repository;

  GetRepositories(this.repository);

  Future<List<RepositoryEntity>> call() async {
    return await repository.getRepositories();
  }
}