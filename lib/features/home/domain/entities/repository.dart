class Repository {
  final int id;
  final String name;
  final String description;
  final Owner owner;
  final int starCount;
  final DateTime lastUpdated;
  final bool fork;
  final int forksCount;
  final bool hasDownloads;
  final String language;
  final License? license;
  final String visibility;
  final List<String> topics;
  final String homepage;
  final int openIssuesCount;
  final bool hasIssues;
  final bool hasProjects;
  final bool hasWiki;
  final bool hasDiscussions;

  const Repository({
    required this.id,
    required this.name,
    required this.description,
    required this.owner,
    required this.starCount,
    required this.lastUpdated,
    required this.fork,
    required this.forksCount,
    required this.hasDownloads,
    required this.language,
    this.license,
    required this.visibility,
    required this.topics,
    required this.homepage,
    required this.openIssuesCount,
    required this.hasIssues,
    required this.hasProjects,
    required this.hasWiki,
    required this.hasDiscussions,
  });
}

// New License class
class License {
  final String key;
  final String name;

  const License({
    required this.key,
    required this.name,
  });
}


class Owner {
  final String login;
  final String avatarUrl;

  const Owner({
    required this.login,
    required this.avatarUrl,
  });
}
