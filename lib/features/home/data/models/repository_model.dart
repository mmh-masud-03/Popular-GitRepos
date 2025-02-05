
import '../../domain/entities/repository.dart';

class RepositoryModel extends Repository {
  const RepositoryModel({
    required super.id,
    required super.name,
    required super.description,
    required super.owner,
    required super.starCount,
    required super.lastUpdated,
    required super.fork,
    required super.forksCount,
    required super.hasDownloads,
    required super.language,
    super.license,
    required super.visibility,
    required super.topics,
    required super.homepage,
    required super.openIssuesCount,
    required super.hasIssues,
    required super.hasProjects,
    required super.hasWiki,
    required super.hasDiscussions,
  });

  factory RepositoryModel.fromJson(Map<String, dynamic> json) {
    return RepositoryModel(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      owner: OwnerModel.fromJson(json['owner']),
      starCount: json['stargazers_count'],
      lastUpdated: DateTime.parse(json['updated_at']),
      fork: json['fork'] ?? false,
      forksCount: json['forks_count'] ?? 0,
      hasDownloads: json['has_downloads'] ?? false,
      language: json['language'] ?? '',
      license: json['license'] != null
          ? License(
        key: json['license']['key'],
        name: json['license']['name'],
      )
          : null,
      visibility: json['visibility'] ?? 'public',
      topics: List<String>.from(json['topics'] ?? []),
      homepage: json['homepage'] ?? '',
      openIssuesCount: json['open_issues_count'] ?? 0,
      hasIssues: json['has_issues'] ?? false,
      hasProjects: json['has_projects'] ?? false,
      hasWiki: json['has_wiki'] ?? false,
      hasDiscussions: json['has_discussions'] ?? false,
    );
  }

  factory RepositoryModel.fromDb(Map<String, dynamic> map) {
    return RepositoryModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      owner: OwnerModel(
        login: map['owner_login'],
        avatarUrl: map['owner_avatar_url'],
      ),
      starCount: map['star_count'],
      lastUpdated: DateTime.parse(map['last_updated']),
      fork: map['fork'] == 1,
      forksCount: map['forks_count'],
      hasDownloads: map['has_downloads'] == 1,
      language: map['language'],
      license: map['license_key'] != null
          ? License(
        key: map['license_key'],
        name: map['license_name'],
      )
          : null,
      visibility: map['visibility'],
      topics: (map['topics'] as String).split(',').where((t) => t.isNotEmpty).toList(),
      homepage: map['homepage'],
      openIssuesCount: map['open_issues_count'],
      hasIssues: map['has_issues'] == 1,
      hasProjects: map['has_projects'] == 1,
      hasWiki: map['has_wiki'] == 1,
      hasDiscussions: map['has_discussions'] == 1,
    );
  }

  Map<String, dynamic> toDb() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'owner_login': owner.login,
      'owner_avatar_url': owner.avatarUrl,
      'star_count': starCount,
      'last_updated': lastUpdated.toIso8601String(),
      'fork': fork ? 1 : 0,
      'forks_count': forksCount,
      'has_downloads': hasDownloads ? 1 : 0,
      'language': language,
      'license_key': license?.key,
      'license_name': license?.name,
      'visibility': visibility,
      'topics': topics.join(','),
      'homepage': homepage,
      'open_issues_count': openIssuesCount,
      'has_issues': hasIssues ? 1 : 0,
      'has_projects': hasProjects ? 1 : 0,
      'has_wiki': hasWiki ? 1 : 0,
      'has_discussions': hasDiscussions ? 1 : 0,
    };
  }
}
class OwnerModel extends Owner {
  const OwnerModel({
    required super.login,
    required super.avatarUrl,
  });

  factory OwnerModel.fromJson(Map<String, dynamic> json) {
    return OwnerModel(
      login: json['login'],
      avatarUrl: json['avatar_url'],
    );
  }
}