import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/repository_entity.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Fetch favorite repositories from local storage
    //final favoritesFuture = ref.watch(favoriteRepositoriesProvider.future);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite Repositories"),
      ),
      body: FutureBuilder<List<RepositoryEntity>>(
        future: null,//favoritesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No favorite repositories found.'));
          } else {
            final favorites = snapshot.data!;
            return ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final repo = favorites[index];
               // return RepoListItem(repository: repo);
              },
            );
          }
        },
      ),
    );
  }
}