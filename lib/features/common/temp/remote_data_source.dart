import 'package:android_popular_git_repos/core/network/api_service.dart';
import 'package:android_popular_git_repos/features/repository/data/models/repository_model.dart';

abstract class RemoteDataSource {
  Future<List<RepositoryModel>> getRepositories();
}

class RemoteDataSourceImpl implements RemoteDataSource{
   final ApiService apiService;
   RemoteDataSourceImpl(this.apiService);
  @override
  Future<List<RepositoryModel>> getRepositories() async {
    var response = await apiService.get('search/repositories?q=Android&sort=stars');
    final List<dynamic> items = response['items'];
    return items.map<RepositoryModel>((json) => RepositoryModel.fromJson(json)).toList();
  }
}