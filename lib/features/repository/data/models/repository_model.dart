import '../../domain/entities/repository_entity.dart';

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

  // Convert JSON to RepositoryModel
  factory RepositoryModel.fromJson(Map<String, dynamic> json) {
    return RepositoryModel(
      name: json['name'] ?? 'Unknown', // Provide a default value if null
      description: json['description'] ?? 'No description available.',
      ownerName: json['ownerName'] ?? 'Unknown',
      ownerAvatarUrl: json['ownerAvatarUrl'] ?? '',
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
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
    );
  }
}