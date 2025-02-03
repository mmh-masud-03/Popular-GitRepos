class RepositoryEntity {
  final String name;
  final String description;
  final String ownerName;
  final String ownerAvatarUrl;
  final DateTime updatedAt;
  final int forksCount;
  final int stargazersCount;
  final String? language; // Nullable because not all repositories specify a language
  final String? licenseName; // Nullable because not all repositories have a license
  final int openIssuesCount;
  final String? homepage; // Nullable because not all repositories have a homepage

  RepositoryEntity({
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

  // Factory method to create a RepositoryEntity from JSON
  factory RepositoryEntity.fromJson(Map<String, dynamic> json) {
    return RepositoryEntity(
      name: json['name'] ?? 'Unknown',
      description: json['description'] ?? 'No description available.',
      ownerName: json['ownerName'] ?? 'Unknown',
      ownerAvatarUrl: json['ownerAvatarUrl'] ?? '',
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt'] ?? 0),
      forksCount: json['forksCount'] ?? 0,
      stargazersCount: json['stargazersCount'] ?? 0,
      language: json['language'],
      licenseName: json['licenseName'],
      openIssuesCount: json['openIssuesCount'] ?? 0,
      homepage: json['homepage'],
    );
  }

  // Convert RepositoryEntity to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'ownerName': ownerName,
      'ownerAvatarUrl': ownerAvatarUrl,
      'updatedAt': updatedAt.millisecondsSinceEpoch, // Store as integer
      'forksCount': forksCount,
      'stargazersCount': stargazersCount,
      'language': language,
      'licenseName': licenseName,
      'openIssuesCount': openIssuesCount,
      'homepage': homepage,
    };
  }
}