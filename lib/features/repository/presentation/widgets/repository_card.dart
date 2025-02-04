//create the repository card widget

import 'package:flutter/material.dart';
import 'package:android_popular_git_repos/features/repository/domain/entities/repository_entity.dart';

import '../pages/details_page.dart';

class RepositoryCard extends StatelessWidget {
  final RepositoryEntity repository;

  const RepositoryCard({Key? key, required this.repository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(repository.ownerAvatarUrl),
        ),
        title: Text(repository.name),
        subtitle: Text(repository.description),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.star, color: Colors.amber),
            Text('${repository.stargazersCount}'),
          ],
        ),
        onTap: () {
          // Navigate to repository details page
          MaterialPageRoute(
            builder: (context) => RepoDetailsPage(repository: repository),
          );
        },
      ),
    );
  }
}