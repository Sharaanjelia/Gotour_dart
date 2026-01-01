import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl = 'https://your-laravel-api-url.com/api';

Future<List<Map<String, dynamic>>> fetchPaymentList() async {
  final response = await http.get(Uri.parse('$baseUrl/payment'));
  if (response.statusCode == 200) {
    final List data = json.decode(response.body);
    return data.cast<Map<String, dynamic>>();
  } else {
    throw Exception('Failed to load payment list');
  }
}

Future<bool> addPayment(Map<String, dynamic> data) async {
  final response = await http.post(
    Uri.parse('$baseUrl/payment'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(data),
  );
  return response.statusCode == 201 || response.statusCode == 200;
}
