import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/repository.dart';

class RepositoryHeaderBackground extends StatelessWidget {
  final Repository repository;

  const RepositoryHeaderBackground({
    super.key,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.primary.withOpacity(0.8),
              ],
            ),
          ),
        ),
        Positioned(
          left: 16,
          bottom: 60,
          child: Row(
            children: [
              Hero(
                tag: 'avatar-${repository.id}',
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: CachedNetworkImageProvider(repository.owner.avatarUrl)
                      ,
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: repository.owner.avatarUrl,
                      placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const Image(image: AssetImage('assets/images/avatar.png')),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    repository.owner.login,
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (repository.fork)
                    Row(
                      children: [
                        Icon(
                          Icons.fork_right,
                          color: theme.colorScheme.onPrimary.withOpacity(0.7),
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Forked home',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onPrimary.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
