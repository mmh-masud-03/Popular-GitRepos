import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/theme_provider.dart';
import '../providers/repository_provider.dart';
import 'details_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repoAsyncValue = ref.watch(repositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.appName),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: () {
              final currentTheme = ref.read(themeProvider);
              ref.read(themeProvider.notifier).state =
              currentTheme == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
            },
          ),
        ],
      ),
      body: repoAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
        data: (repositories) {
          if (repositories.isEmpty) {
            return const Center(child: Text('No repositories found.'));
          }
          return ListView.builder(
            itemCount: repositories.length,
            itemBuilder: (context, index) {
              final repo = repositories[index];
              return ListTile(
                title: Text(repo.name),
                subtitle: Text(repo.description),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(repo.ownerAvatarUrl),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RepoDetailsPage(repository: repo),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}