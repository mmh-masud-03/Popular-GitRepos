import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/repository_entity.dart';

class RepoDetailsPage extends StatelessWidget {
  final RepositoryEntity repository;

  const RepoDetailsPage({Key? key, required this.repository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(repository.name),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Owner's Avatar
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(repository.ownerAvatarUrl),
              ),
            ),
            const SizedBox(height: 16),

            // Owner's Name
            Text(
              "Owner: ${repository.ownerName}",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),

            // Repository Description
            Text(
              repository.description.isNotEmpty
                  ? repository.description
                  : "No description available.",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),

            // Last Updated Date
            Text(
              "Last Updated: ${_formatDateTime(repository.updatedAt)}",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // Helper method to format the date
  String _formatDateTime(DateTime dateTime) {
    final formatter = DateFormat('MM-dd-yyyy HH:mm');
    return formatter.format(dateTime);
  }
}