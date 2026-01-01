import 'dart:convert';
import 'package:http/http.dart' as http;

// Ganti baseUrl sesuai endpoint Laravel kamu
const String baseUrl = 'https://your-laravel-api-url.com/api';

Future<List<Map<String, dynamic>>> fetchPaketList() async {
  final response = await http.get(Uri.parse('$baseUrl/paket'));
  if (response.statusCode == 200) {
    final List data = json.decode(response.body);
    return data.cast<Map<String, dynamic>>();
  } else {
    throw Exception('Failed to load paket list');
  }
}
