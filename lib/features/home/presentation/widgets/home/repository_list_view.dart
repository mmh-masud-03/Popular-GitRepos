import 'package:android_popular_git_repos/features/home/presentation/widgets/home/repository_card.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/repository.dart';
import '../../pages/repository_details_page.dart';
import 'empty_repositories_view.dart';

class RepositoryListView extends StatelessWidget {
  final List<Repository> repositories;
  final Animation<double> fadeController;

  const RepositoryListView({
    Key? key,
    required this.repositories,
    required this.fadeController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (repositories.isEmpty) {
      return const EmptyRepositoriesView();
    }

    return FadeTransition(
      opacity: fadeController,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8),
        itemCount: repositories.length,
        itemBuilder: (context, index) {
          final repository = repositories[index];
          return RepositoryCard(
            repository: repository,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RepositoryDetailsPage(
                    repository: repository,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}