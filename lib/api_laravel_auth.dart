import 'package:http/http.dart' as http;
import 'dart:convert';

class LaravelAuthApi {
  String? token;

  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('http://localhost:8000/api/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      token = data['token'];
      return true;
    }
    return false;
  }

  Future<Map<String, dynamic>?> getUser() async {
    if (token == null) return null;
    final response = await http.get(
      Uri.parse('http://localhost:8000/api/user'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    return null;
  }
}
