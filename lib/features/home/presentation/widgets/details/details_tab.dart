
// lib/features/repository_details/presentation/tabs/details_tab.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/repository.dart';

class DetailsTab extends StatelessWidget {
  final Repository repository;

  const DetailsTab({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy HH:mm');
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 2,
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.code, color: theme.colorScheme.onSurfaceVariant),
              title: Text('Language', style: TextStyle(color: theme.colorScheme.onSurface)),
              subtitle: Text(repository.language),
            ),
            const Divider(height: 1),
            ListTile(
              leading: Icon(Icons.gavel, color: theme.colorScheme.onSurfaceVariant),
              title: Text('License', style: TextStyle(color: theme.colorScheme.onSurface)),
              subtitle: Text(repository.license?.name ?? 'Not specified'),
            ),
            const Divider(height: 1),
            ListTile(
              leading: Icon(Icons.visibility, color: theme.colorScheme.onSurfaceVariant),
              title: Text('Visibility', style: TextStyle(color: theme.colorScheme.onSurface)),
              subtitle: Text(repository.visibility),
            ),
            const Divider(height: 1),
            ListTile(
              leading: Icon(Icons.update, color: theme.colorScheme.onSurfaceVariant),
              title: Text('Last Updated', style: TextStyle(color: theme.colorScheme.onSurface)),
              subtitle: Text(dateFormat.format(repository.lastUpdated)),
            ),
          ],
        ),
      ),
    );
  }
}
