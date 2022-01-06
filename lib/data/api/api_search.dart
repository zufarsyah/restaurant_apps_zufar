import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restaurant_apps/data/model/restaurant_search.dart';

class ApiSearch {
  static final String _apiKeySearch =
      'https://restaurant-api.dicoding.dev/search?q=';
  String query;

  ApiSearch({required this.query});

  Future<Search> topSearchlines() async {
    final response = await http.get(Uri.parse(_apiKeySearch + query));
    if (response.statusCode == 200) {
      return Search.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load top headlines');
    }
  }
}
