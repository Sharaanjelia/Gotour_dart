import 'package:http/http.dart' as http;
import 'dart:convert';

Future<bool> postBooking({
  required String nama,
  required String email,
  required String telepon,
  required String tanggal,
  required int jumlahOrang,
  required int paketId,
  required String token,
}) async {
  final response = await http.post(
    Uri.parse('http://localhost:8000/api/payments'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({
      'nama': nama,
      'email': email,
      'telepon': telepon,
      'tanggal': tanggal,
      'jumlah_orang': jumlahOrang,
      'paket_id': paketId,
    }),
  );
  return response.statusCode == 201 || response.statusCode == 200;
}
