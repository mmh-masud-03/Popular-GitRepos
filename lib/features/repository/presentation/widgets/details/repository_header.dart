// lib/features/repository_details/presentation/widgets/repository_header.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:popular_git_repo/features/home/presentation/widgets/details/repository_header_background.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../domain/entities/repository.dart';

class RepositoryHeader extends StatelessWidget {
  final Repository repository;
  final bool isScrolled;

  const RepositoryHeader({
    super.key,
    required this.repository,
    required this.isScrolled,
  });

  Future<void> _launchUrl(String url) async {
    if (url.isEmpty) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _copyToClipboard(BuildContext context, String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Copied to clipboard'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      elevation: isScrolled ? 4 : 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: isScrolled
              ? theme.colorScheme.onSurface
              : theme.colorScheme.onPrimary,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          repository.name,
          style: TextStyle(
            color: isScrolled
                ? theme.colorScheme.onSurface
                : theme.colorScheme.onPrimary,
            fontSize: isScrolled?20:18,

          ),
          overflow: TextOverflow.ellipsis,
        ),
        background: RepositoryHeaderBackground(repository: repository),
      ),
      actions: [
        if (repository.homepage.isNotEmpty)
          IconButton(
            icon: Icon(Icons.language, color: isScrolled
                ? theme.colorScheme.onSurface
                : theme.colorScheme.onPrimary,),
            onPressed: () => _launchUrl(repository.homepage),
            tooltip: 'Visit website',
          ),
        IconButton(
          icon: Icon(Icons.share, color:isScrolled
              ? theme.colorScheme.onSurface
              : theme.colorScheme.onPrimary,),
          onPressed: () => _copyToClipboard(context, repository.homepage),
          tooltip: 'Share repository',
        ),
      ],
    );
  }
}