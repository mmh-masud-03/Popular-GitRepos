import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/repository.dart';


abstract class GitHubRepository {
  Future<Either<Failure, List<Repository>>> getAndroidRepositories();
  Future<Either<Failure, List<Repository>>> forceRefresh();

}
