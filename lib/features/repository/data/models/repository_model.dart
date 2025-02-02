class RepositoryModel {
  final String name;
  final String description;
  final String ownerName;
  final String ownerAvatarUrl;
  final DateTime updatedAt;

  RepositoryModel({
    required this.name,
    required this.description,
    required this.ownerName,
    required this.ownerAvatarUrl,
    required this.updatedAt,
  });

  factory RepositoryModel.fromJson(Map<String, dynamic> json) {
    return RepositoryModel(
      name: json['name'],
      description: json['description'] ?? '',
      ownerName: json['owner']['login'],
      ownerAvatarUrl: json['owner']['avatar_url'],
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}