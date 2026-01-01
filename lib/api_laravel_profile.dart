import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>?> fetchProfile({required String token}) async {
  final response = await http.get(
    Uri.parse('http://localhost:8000/api/user'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    return null;
  }
}
