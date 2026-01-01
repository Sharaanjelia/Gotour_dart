import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl = 'https://your-laravel-api-url.com/api';

Future<List<Map<String, dynamic>>> fetchPhotoList() async {
  final response = await http.get(Uri.parse('$baseUrl/photo'));
  if (response.statusCode == 200) {
    final List data = json.decode(response.body);
    return data.cast<Map<String, dynamic>>();
  } else {
    throw Exception('Failed to load photo list');
  }
}
