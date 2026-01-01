import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Map<String, dynamic>>> fetchTestimonials() async {
  final response = await http.get(
    Uri.parse('http://localhost:8000/api/testimonials'),
    headers: {
      'Content-Type': 'application/json',
    },
  );
  if (response.statusCode == 200) {
    final List data = json.decode(response.body);
    return data.cast<Map<String, dynamic>>();
  } else {
    return [];
  }
}
