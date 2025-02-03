class ApiConstants {
  static const String baseUrl = 'https://api.github.com';
  static const String searchEndpoint = '/search/repositories';
  static const String queryParams = 'q=Android&sort=stars&order=desc';
  static const Duration cacheTimeout = Duration(hours: 2);
}
