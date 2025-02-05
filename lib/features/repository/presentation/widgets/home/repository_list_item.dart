// lib/features/home/presentation/widgets/repository_list_item.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:popular_git_repo/features/home/domain/entities/repository.dart';

class RepositoryListItem extends StatelessWidget {
  final Repository repository;
  final VoidCallback onTap;

  const RepositoryListItem({
    super.key,
    required this.repository,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: repository.owner.avatarUrl.isNotEmpty? CachedNetworkImageProvider(repository.owner.avatarUrl): null,
        // backgroundImage: NetworkImage(repository.owner.avatarUrl),
      ),
      title: Text(repository.name),
      subtitle: Text(
        repository.description,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, color: Colors.amber),
          const SizedBox(width: 4),
          Text(repository.starCount.toString()),
        ],
      ),
      onTap: onTap,
    );
  }
}
