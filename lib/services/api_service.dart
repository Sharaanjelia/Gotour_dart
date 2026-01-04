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

  static String get _serverOrigin {
    // baseUrl selalu berakhiran /api
    return baseUrl.replaceFirst(RegExp(r'\/api\/?$'), '');
  }

  String _toAbsoluteUrl(String? maybeRelative) {
    final raw = (maybeRelative ?? '').trim();
    if (raw.isEmpty) return '';
    if (raw.startsWith('http://') || raw.startsWith('https://')) return raw;
    if (raw.startsWith('/')) return '$_serverOrigin$raw';
    // Kadang backend mengirim path seperti: packages/xxx.jpg (relative ke /storage)
    if (raw.startsWith('storage/')) return '$_serverOrigin/$raw';
    return '$_serverOrigin/storage/$raw';
  }

  Map<String, dynamic> _normalizePackage(Map<String, dynamic> src) {
    final out = Map<String, dynamic>.from(src);

    // Nama paket: backend sering pakai `title`
    out['name'] ??= out['title'];

    // Photo: backend pakai `cover_image_url` (biasanya /storage/..)
    final coverUrl = out['cover_image_url']?.toString();
    final coverImage = out['cover_image']?.toString();
    final candidate = coverUrl?.isNotEmpty == true ? coverUrl : coverImage;
    if ((out['photo'] == null || out['photo'].toString().trim().isEmpty) && (candidate ?? '').trim().isNotEmpty) {
      out['photo'] = _toAbsoluteUrl(candidate);
    } else if (out['photo'] != null) {
      out['photo'] = _toAbsoluteUrl(out['photo']?.toString());
    }

    // Konsistensi field image_url juga sering dipakai di beberapa layar
    if ((out['image_url'] == null || out['image_url'].toString().trim().isEmpty) && (out['photo']?.toString().trim().isNotEmpty ?? false)) {
      out['image_url'] = out['photo'];
    } else if (out['image_url'] != null) {
      out['image_url'] = _toAbsoluteUrl(out['image_url']?.toString());
    }

    // Description fallback: beberapa list API hanya punya excerpt
    out['description'] ??= out['excerpt'];
    return out;
  }

  String _bodySnippet(String body, {int max = 240}) {
    final trimmed = body.trim();
    if (trimmed.isEmpty) return '(empty body)';
    final singleLine = trimmed.replaceAll(RegExp(r'\s+'), ' ');
    if (singleLine.length <= max) return singleLine;
    return '${singleLine.substring(0, max)}…';
  }

  bool _looksLikeJson(String body) {
    final trimmed = body.trimLeft();
    return trimmed.startsWith('{') || trimmed.startsWith('[');
  }

  bool _isJsonResponse(http.Response response) {
    final contentType = (response.headers['content-type'] ?? '').toLowerCase();
    if (contentType.contains('application/json')) return true;
    return _looksLikeJson(response.body);
  }

  Map<String, dynamic> _decodeJsonObject(String body) {
    final trimmed = body.trim();
    if (trimmed.isEmpty) return <String, dynamic>{};

    // Banyak error backend (Laravel/PHP) balas HTML (<br><b>...) yang bikin jsonDecode gagal.
    // Kita kasih error yang lebih jelas.
    final lower = trimmed.toLowerCase();
    final looksHtml =
        lower.startsWith('<!doctype html') ||
        lower.startsWith('<html') ||
        lower.contains('<br') ||
        lower.contains('<b>') ||
        lower.contains('<body') ||
        lower.contains('<head');
    if (looksHtml && !_looksLikeJson(trimmed)) {
      throw const FormatException('Response bukan JSON (terdeteksi HTML).');
    }

    try {
      final decoded = json.decode(trimmed);
      if (decoded is Map<String, dynamic>) return decoded;
      return <String, dynamic>{'data': decoded};
    } on FormatException {
      throw FormatException('Response bukan JSON. Body: ${_bodySnippet(trimmed)}');
    }
  }

  dynamic _unwrapData(dynamic decoded) {
    // Banyak API (terutama Laravel + Resource/Pagination) membungkus payload di dalam
    // `data`, dan kadang bertingkat: { data: { data: [...] } }.
    // Kita unwrap beberapa level agar getter list (packages/blogs/dll) tidak terbaca kosong.
    dynamic current = decoded;
    for (var i = 0; i < 3; i++) {
      if (current is Map && current.containsKey('data')) {
        current = current['data'];
        continue;
      }
      break;
    }
    return current;
  }

  String _extractMessage(dynamic decoded, {String fallback = 'Terjadi kesalahan'}) {
    if (decoded is Map) {
      final msg = decoded['message'] ?? decoded['error'];
      if (msg is String && msg.trim().isNotEmpty) return msg;
      if (msg is List && msg.isNotEmpty) return msg.first.toString();
      if (msg is Map && msg.isNotEmpty) return msg.values.first.toString();

      final errors = decoded['errors'];
      if (errors is Map && errors.isNotEmpty) {
        // Gabungkan semua error validation agar lebih jelas di UI.
        final parts = <String>[];
        for (final entry in errors.entries) {
          final key = entry.key.toString();
          final val = entry.value;
          if (val is List) {
            final msgs = val.map((e) => e.toString()).where((s) => s.trim().isNotEmpty).toList();
            if (msgs.isNotEmpty) {
              parts.add('$key: ${msgs.join(' ')}');
            }
          } else if (val != null) {
            final s = val.toString();
            if (s.trim().isNotEmpty) {
              parts.add('$key: $s');
            }
          }
        }
        if (parts.isNotEmpty) return parts.join(' | ');

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

  // GET /favorites (dengan auth)
  // Beberapa backend memakai route singular: /favorite
  Future<List> getFavorites() async {
    try {
      final paths = <String>['favorites', 'favorite'];

      for (final path in paths) {
        final uri = Uri.parse('$baseUrl/$path');
        final response = await http.get(
          uri,
          headers: await getHeaders(withAuth: true),
        );

        // Hanya fallback jika endpoint benar-benar tidak ada.
        if (response.statusCode == 404) {
          continue;
        }

        if (!_isJsonResponse(response)) {
          throw Exception(
            'Endpoint ${uri.toString()} mengembalikan non-JSON (HTTP ${response.statusCode}). '
            'Body: ${_bodySnippet(response.body)}',
          );
        }

        if (response.statusCode == 200) {
          final decoded = _decodeJsonObject(response.body);
          final data = _unwrapData(decoded);
          if (data is List) return data;
          return const [];
        } else {
          final decoded = _decodeJsonObject(response.body);
          final message = _extractMessage(decoded, fallback: 'Gagal mengambil favorit');
          throw Exception('$message (HTTP ${response.statusCode})');
        }
      }

      throw Exception('Endpoint favorites tidak ditemukan (coba /favorites atau /favorite)');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // GET /packages
  Future<List> getPackages() async {
    try {
      final uri = Uri.parse('$baseUrl/packages');
      final response = await http.get(
        uri,
        headers: await getHeaders(),
      );

      if (!_isJsonResponse(response)) {
        throw Exception(
          'Endpoint ${uri.toString()} mengembalikan non-JSON (HTTP ${response.statusCode}). '
          'Kemungkinan URL salah, backend error, atau route mengarah ke halaman web. '
          'Body: ${_bodySnippet(response.body)}',
        );
      }

      if (response.statusCode == 200) {
        final decoded = _decodeJsonObject(response.body);
        final data = _unwrapData(decoded);
        if (data is List) {
          return data
              .map((e) => e is Map ? _normalizePackage(Map<String, dynamic>.from(e)) : e)
              .toList();
        }
        return const [];
      } else {
        final decoded = _decodeJsonObject(response.body);
        final message = _extractMessage(decoded, fallback: 'Gagal mengambil data paket');
        throw Exception('$message (HTTP ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // GET /packages/{id}
  Future<Map> getPackageDetail(int id) async {
    try {
      final uri = Uri.parse('$baseUrl/packages/$id');
      final response = await http.get(
        uri,
        headers: await getHeaders(),
      );

      if (!_isJsonResponse(response)) {
        throw Exception(
          'Endpoint ${uri.toString()} mengembalikan non-JSON (HTTP ${response.statusCode}). '
          'Body: ${_bodySnippet(response.body)}',
        );
      }

      if (response.statusCode == 200) {
        final decoded = _decodeJsonObject(response.body);
        final data = _unwrapData(decoded);
        if (data is Map) return _normalizePackage(Map<String, dynamic>.from(data));
        return <String, dynamic>{};
      } else {
        final decoded = _decodeJsonObject(response.body);
        final message = _extractMessage(decoded, fallback: 'Gagal mengambil detail paket');
        throw Exception('$message (HTTP ${response.statusCode})');
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

  // DELETE /favorites/{id} (dengan auth)
  // Beberapa backend memakai route singular: /favorite/{id}
  Future<bool> deleteFavorite(int id) async {
    try {
      final paths = <String>['favorites', 'favorite'];

      for (final path in paths) {
        final uri = Uri.parse('$baseUrl/$path/$id');
        final response = await http.delete(
          uri,
          headers: await getHeaders(withAuth: true),
        );

        if (response.statusCode == 404) {
          continue;
        }

        if (response.statusCode == 200 || response.statusCode == 204) {
          return true;
        }

        if (_isJsonResponse(response)) {
          final decoded = _decodeJsonObject(response.body);
          final message = _extractMessage(decoded, fallback: 'Gagal menghapus favorit');
          throw Exception('$message (HTTP ${response.statusCode})');
        }

        throw Exception(
          'Gagal menghapus favorit (HTTP ${response.statusCode}). Body: ${_bodySnippet(response.body)}',
        );
      }

      throw Exception('Endpoint favorites tidak ditemukan untuk delete');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

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
