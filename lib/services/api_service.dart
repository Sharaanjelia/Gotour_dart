import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Base URL default.
  // - Web: browser berjalan di mesin host, jadi pakai localhost.
  // - Android emulator: pakai 10.0.2.2 untuk akses localhost host.
  static const String _baseUrlAndroidEmulator = 'http://10.0.2.2:8000/api';
  // NOTE: pakai 127.0.0.1 untuk menghindari kasus `localhost` resolve ke IPv6 (::1)
  // sementara backend hanya listen di IPv4.
  static const String _baseUrlWeb = 'http://127.0.0.1:8000/api';
  static String get baseUrl => kIsWeb ? _baseUrlWeb : _baseUrlAndroidEmulator;

  Map<String, dynamic> _decodeJsonObject(String body) {
    final decoded = json.decode(body);
    if (decoded is Map<String, dynamic>) return decoded;
    return <String, dynamic>{'data': decoded};
  }

  dynamic _unwrapData(dynamic decoded) {
    if (decoded is Map && decoded.containsKey('data')) {
      return decoded['data'];
    }
    return decoded;
  }

  String _extractMessage(dynamic decoded, {String fallback = 'Terjadi kesalahan'}) {
    if (decoded is Map) {
      final msg = decoded['message'] ?? decoded['error'];
      if (msg is String && msg.trim().isNotEmpty) return msg;
      if (msg is List && msg.isNotEmpty) return msg.first.toString();
      if (msg is Map && msg.isNotEmpty) return msg.values.first.toString();

      final errors = decoded['errors'];
      if (errors is Map && errors.isNotEmpty) {
        final first = errors.values.first;
        if (first is List && first.isNotEmpty) return first.first.toString();
        return first.toString();
      }
    }
    return fallback;
  }

  Future<String> _requireToken() async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Anda belum login');
    }
    return token;
  }

  // Get token dari SharedPreferences
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Get headers dengan/tanpa authentication
  Future<Map<String, String>> getHeaders({bool withAuth = false}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (withAuth) {
      final token = await _requireToken();
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  // ========== GET METHODS ==========

  // GET /packages
  Future<List> getPackages() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/packages'),
        headers: await getHeaders(),
      );

      if (response.statusCode == 200) {
        final decoded = _decodeJsonObject(response.body);
        final data = _unwrapData(decoded);
        if (data is List) return data;
        return const [];
      } else {
        final decoded = _decodeJsonObject(response.body);
        throw Exception(_extractMessage(decoded, fallback: 'Gagal mengambil data paket'));
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // GET /packages/{id}
  Future<Map> getPackageDetail(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/packages/$id'),
        headers: await getHeaders(),
      );

      if (response.statusCode == 200) {
        final decoded = _decodeJsonObject(response.body);
        final data = _unwrapData(decoded);
        if (data is Map) return data;
        return <String, dynamic>{};
      } else {
        final decoded = _decodeJsonObject(response.body);
        throw Exception(_extractMessage(decoded, fallback: 'Gagal mengambil detail paket'));
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // GET /blogs
  Future<List> getBlogs() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/blogs'),
        headers: await getHeaders(),
      );

      if (response.statusCode == 200) {
        final decoded = _decodeJsonObject(response.body);
        final data = _unwrapData(decoded);
        if (data is List) return data;
        return const [];
      } else {
        final decoded = _decodeJsonObject(response.body);
        throw Exception(_extractMessage(decoded, fallback: 'Gagal mengambil data blog'));
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // GET /blog-posts/{id}
  Future<Map> getBlogDetail(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/blog-posts/$id'),
        headers: await getHeaders(),
      );

      if (response.statusCode == 200) {
        final decoded = _decodeJsonObject(response.body);
        final data = _unwrapData(decoded);
        if (data is Map) return data;
        return <String, dynamic>{};
      } else {
        final decoded = _decodeJsonObject(response.body);
        throw Exception(_extractMessage(decoded, fallback: 'Gagal mengambil detail blog'));
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // GET /services
  Future<List> getServices() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/services'),
        headers: await getHeaders(),
      );

      if (response.statusCode == 200) {
        final decoded = _decodeJsonObject(response.body);
        final data = _unwrapData(decoded);
        if (data is List) return data;
        return const [];
      } else {
        final decoded = _decodeJsonObject(response.body);
        throw Exception(_extractMessage(decoded, fallback: 'Gagal mengambil data layanan'));
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // GET /testimonials
  Future<List> getTestimonials() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/testimonials'),
        headers: await getHeaders(),
      );

      if (response.statusCode == 200) {
        final decoded = _decodeJsonObject(response.body);
        final data = _unwrapData(decoded);
        if (data is List) return data;
        return const [];
      } else {
        final decoded = _decodeJsonObject(response.body);
        throw Exception(_extractMessage(decoded, fallback: 'Gagal mengambil data testimoni'));
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // GET /discounts
  Future<List> getDiscounts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/discounts'),
        headers: await getHeaders(),
      );

      if (response.statusCode == 200) {
        final decoded = _decodeJsonObject(response.body);
        final data = _unwrapData(decoded);
        if (data is List) return data;
        return const [];
      } else {
        final decoded = _decodeJsonObject(response.body);
        throw Exception(_extractMessage(decoded, fallback: 'Gagal mengambil data diskon'));
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // GET /photo-recommendations
  Future<List> getPhotoRecommendations() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/photo-recommendations'),
        headers: await getHeaders(),
      );

      if (response.statusCode == 200) {
        final decoded = _decodeJsonObject(response.body);
        final data = _unwrapData(decoded);
        if (data is List) return data;
        return const [];
      } else {
        final decoded = _decodeJsonObject(response.body);
        throw Exception(_extractMessage(decoded, fallback: 'Gagal mengambil rekomendasi foto'));
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // GET /payments (dengan auth)
  Future<List> getPayments() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/payments'),
        headers: await getHeaders(withAuth: true),
      );

      if (response.statusCode == 200) {
        final decoded = _decodeJsonObject(response.body);
        final data = _unwrapData(decoded);
        if (data is List) return data;
        return const [];
      } else {
        final decoded = _decodeJsonObject(response.body);
        throw Exception(_extractMessage(decoded, fallback: 'Gagal mengambil data pembayaran'));
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // GET /user (dengan auth)
  Future<Map> getUser() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user'),
        headers: await getHeaders(withAuth: true),
      );

      if (response.statusCode == 200) {
        final decoded = _decodeJsonObject(response.body);
        final data = _unwrapData(decoded);
        if (data is Map) return data;
        return <String, dynamic>{};
      } else {
        final decoded = _decodeJsonObject(response.body);
        throw Exception(_extractMessage(decoded, fallback: 'Gagal mengambil data user'));
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // ========== POST METHODS ==========

  // POST /login
  Future<Map> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: await getHeaders(),
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = _decodeJsonObject(response.body);
        final data = _unwrapData(decoded);
        if (data is Map) return data;
        return decoded;
      } else {
        final decoded = _decodeJsonObject(response.body);
        throw Exception(_extractMessage(decoded, fallback: 'Login gagal'));
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // POST /register
  Future<Map> register(Map userData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: await getHeaders(),
        body: json.encode(userData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = _decodeJsonObject(response.body);
        final data = _unwrapData(decoded);
        if (data is Map) return data;
        return decoded;
      } else {
        final decoded = _decodeJsonObject(response.body);
        throw Exception(_extractMessage(decoded, fallback: 'Registrasi gagal'));
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // POST /packages (dengan auth)
  Future<Map> createPackage(Map packageData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/packages'),
        headers: await getHeaders(withAuth: true),
        body: json.encode(packageData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = _decodeJsonObject(response.body);
        final data = _unwrapData(decoded);
        if (data is Map) return data;
        return decoded;
      } else {
        final decoded = _decodeJsonObject(response.body);
        throw Exception(_extractMessage(decoded, fallback: 'Gagal membuat paket'));
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // POST /payments (dengan auth)
  Future<Map> createPayment(Map paymentData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/payments'),
        headers: await getHeaders(withAuth: true),
        body: json.encode(paymentData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = _decodeJsonObject(response.body);
        final data = _unwrapData(decoded);
        if (data is Map) return data;
        return decoded;
      } else {
        final decoded = _decodeJsonObject(response.body);
        throw Exception(_extractMessage(decoded, fallback: 'Gagal membuat pembayaran'));
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // POST /profile/photo (dengan auth, multipart)
  Future<Map> uploadProfilePhoto(File imageFile) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/profile/photo'),
      );

      final token = await _requireToken();
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      request.files.add(
        await http.MultipartFile.fromPath('photo', imageFile.path),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = _decodeJsonObject(response.body);
        final data = _unwrapData(decoded);
        if (data is Map) return data;
        return decoded;
      } else {
        final decoded = _decodeJsonObject(response.body);
        throw Exception(_extractMessage(decoded, fallback: 'Upload foto gagal'));
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // POST /testimonials (dengan auth)
  // Body contoh: {"user_id": 1, "rating": 5, "review": "..."}
  Future<Map> createTestimonial(Map testimonialData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/testimonials'),
        headers: await getHeaders(withAuth: true),
        body: json.encode(testimonialData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = _decodeJsonObject(response.body);
        final data = _unwrapData(decoded);
        if (data is Map) return data;
        return decoded;
      } else {
        final decoded = _decodeJsonObject(response.body);
        throw Exception(_extractMessage(decoded, fallback: 'Gagal mengirim testimoni'));
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // POST /payments/{paymentId}/pay (dengan auth)
  Future<Map> payPayment(int paymentId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/payments/$paymentId/pay'),
        headers: await getHeaders(withAuth: true),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = _decodeJsonObject(response.body);
        final data = _unwrapData(decoded);
        if (data is Map) return data;
        return decoded;
      } else {
        final decoded = _decodeJsonObject(response.body);
        throw Exception(_extractMessage(decoded, fallback: 'Pembayaran gagal'));
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // ========== PUT METHODS ==========

  // PUT /packages/{id} (dengan auth)
  Future<Map> updatePackage(int id, Map data) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/packages/$id'),
        headers: await getHeaders(withAuth: true),
        body: json.encode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = _decodeJsonObject(response.body);
        final unwrapped = _unwrapData(decoded);
        if (unwrapped is Map) return unwrapped;
        return decoded;
      } else {
        final decoded = _decodeJsonObject(response.body);
        throw Exception(_extractMessage(decoded, fallback: 'Gagal update paket'));
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // PUT /payments/{id} (dengan auth)
  Future<Map> updatePayment(int id, Map data) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/payments/$id'),
        headers: await getHeaders(withAuth: true),
        body: json.encode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = _decodeJsonObject(response.body);
        final unwrapped = _unwrapData(decoded);
        if (unwrapped is Map) return unwrapped;
        return decoded;
      } else {
        final decoded = _decodeJsonObject(response.body);
        throw Exception(_extractMessage(decoded, fallback: 'Gagal update pembayaran'));
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // ========== DELETE METHODS ==========

  // DELETE /packages/{id} (dengan auth)
  Future<bool> deletePackage(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/packages/$id'),
        headers: await getHeaders(withAuth: true),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        final decoded = _decodeJsonObject(response.body);
        throw Exception(_extractMessage(decoded, fallback: 'Gagal menghapus paket'));
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // DELETE /payments/{id} (dengan auth)
  Future<bool> deletePayment(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/payments/$id'),
        headers: await getHeaders(withAuth: true),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        final decoded = _decodeJsonObject(response.body);
        throw Exception(_extractMessage(decoded, fallback: 'Gagal menghapus pembayaran'));
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
