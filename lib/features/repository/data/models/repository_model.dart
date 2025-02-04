import '../../domain/entities/repository_entity.dart';

class RepositoryModel {
  final String name;
  final String description;
  final String ownerName;
  final String ownerAvatarUrl;
  final DateTime updatedAt;
  final int forksCount;
  final int stargazersCount;
  final String? language;
  final String? licenseName;
  final int openIssuesCount;
  final String? homepage;

  RepositoryModel({
    required this.name,
    required this.description,
    required this.ownerName,
    required this.ownerAvatarUrl,
    required this.updatedAt,
    required this.forksCount,
    required this.stargazersCount,
    this.language,
    this.licenseName,
    required this.openIssuesCount,
    this.homepage,
  });

  // Convert JSON to RepositoryModel
  factory RepositoryModel.fromJson(Map<String, dynamic> json) {
    return RepositoryModel(
      name: json['name'] ?? 'Unknown',
      description: json['description'] ?? 'No description available.',
      ownerName: json['owner']?['login'] ?? 'Unknown',
      ownerAvatarUrl: json['owner']?['avatar_url'] ?? 'https://raw.githubusercontent.com/gist/johan/1007813/raw/a25829510f049194b6404a8f98d22978e8744a6f/octocat.svg',
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : DateTime.now(),
      forksCount: json['forks_count'] ?? 0,
      stargazersCount: json['stargazers_count'] ?? 0,
      language: json['language'],
      licenseName: json['license']?['name'],
      openIssuesCount: json['open_issues_count'] ?? 0,
      homepage: json['homepage'],
    );
  }

  // Convert RepositoryModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'ownerName': ownerName,
      'ownerAvatarUrl': ownerAvatarUrl,
      'updatedAt': updatedAt.toIso8601String(),
      'forksCount': forksCount,
      'stargazersCount': stargazersCount,
      'language': language,
      'licenseName': licenseName,
      'openIssuesCount': openIssuesCount,
      'homepage': homepage,
    };
  }

  // Convert RepositoryModel to RepositoryEntity
  RepositoryEntity toEntity() {
    return RepositoryEntity(
      name: name,
      description: description,
      ownerName: ownerName,
      ownerAvatarUrl: ownerAvatarUrl,
      updatedAt: updatedAt,
      forksCount: forksCount,
      stargazersCount: stargazersCount,
      language: language,
      licenseName: licenseName,
      openIssuesCount: openIssuesCount,
      homepage: homepage,
    );
  }

  // Convert RepositoryEntity to RepositoryModel
  factory RepositoryModel.fromEntity(RepositoryEntity entity) {
    return RepositoryModel(
      name: entity.name,
      description: entity.description,
      ownerName: entity.ownerName,
      ownerAvatarUrl: entity.ownerAvatarUrl,
      updatedAt: entity.updatedAt,
      forksCount: entity.forksCount,
      stargazersCount: entity.stargazersCount,
      language: entity.language,
      licenseName: entity.licenseName,
      openIssuesCount: entity.openIssuesCount,
      homepage: entity.homepage,
    );
  }
}