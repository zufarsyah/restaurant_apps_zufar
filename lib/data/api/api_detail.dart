import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restaurant_apps/data/model/restaurant_detail.dart';

class ApiDetail {
  static final String _apiKeyDetail =
      'https://restaurant-api.dicoding.dev/detail/';
  String idDetail;

  ApiDetail({required this.idDetail});

  Future<Detail> topDetaillines() async {
    final response = await http.get(Uri.parse(_apiKeyDetail + idDetail));
    if (response.statusCode == 200) {
      return Detail.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load top headlines');
    }
  }
}
