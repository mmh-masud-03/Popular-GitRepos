// lib/features/home/presentation/widgets/repository_card.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../domain/entities/repository.dart';

class RepositoryCard extends StatelessWidget {
  final Repository repository;
  final VoidCallback onTap;

  const RepositoryCard({
    Key? key,
    required this.repository,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildAvatar(),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildRepositoryInfo(theme),
                  ),
                  _buildStatsColumn(theme),
                ],
              ),
              if (repository.description.isNotEmpty) ...[
                const SizedBox(height: 12),
                _buildDescription(theme),
              ],
              const SizedBox(height: 12),
              _buildBottomRow(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Hero(
      tag: 'avatar-${repository.id}',
      child: CircleAvatar(
        radius: 24,
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
    );
  }

  Widget _buildRepositoryInfo(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          repository.name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          repository.owner.login,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsColumn(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 20),
            const SizedBox(width: 4),
            Text(
              _formatNumber(repository.starCount),
              style: theme.textTheme.titleMedium,
            ),
          ],
        ),
        if (repository.language.isNotEmpty)
          Text(
            repository.language,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
      ],
    );
  }

  Widget _buildDescription(ThemeData theme) {
    return Text(
      repository.description,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: theme.textTheme.bodyMedium,
    );
  }

  Widget _buildBottomRow(ThemeData theme) {
    return Row(
      children: [
        _buildStat(Icons.fork_right, _formatNumber(repository.forksCount)),
        const SizedBox(width: 16),
        _buildStat(Icons.bug_report, _formatNumber(repository.openIssuesCount)),
        const Spacer(),
        if (repository.topics.isNotEmpty)
          Expanded(
            child: _buildTopics(theme),
          ),
      ],
    );
  }

  Widget _buildStat(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildTopics(ThemeData theme) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: repository.topics.take(3).map((topic) {
          return Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              topic,
              style: TextStyle(
                fontSize: 12,
                color: theme.primaryColor,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    }
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}