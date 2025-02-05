// lib/features/home/domain/repositories/github_repository.dart
import 'package:dartz/dartz.dart';
import 'package:popular_git_repo/core/error/failures.dart';
import 'package:popular_git_repo/features/home/domain/entities/repository.dart';

abstract class GitHubRepository {
  Future<Either<Failure, List<Repository>>> getAndroidRepositories();
  Future<Either<Failure, List<Repository>>> forceRefresh();

}
