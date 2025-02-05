import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiClient {
  final http.Client client;
  final String baseUrl;

  ApiClient({
    required this.client,
    this.baseUrl = 'https://api.github.com',
  });

  Future<Map<String, dynamic>> get(String endpoint) async {
    final response = await client.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Accept': 'application/vnd.github.v3+json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
}