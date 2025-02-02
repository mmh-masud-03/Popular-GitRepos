import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/app_constants.dart';

class ApiService {
  Future<dynamic> get(String endpoint) async {
    final response = await http.get(Uri.parse("${AppConstants.gitHubApiBaseUrl}$endpoint"));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
}