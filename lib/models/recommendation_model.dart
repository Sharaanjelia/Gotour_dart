import 'dart:convert';

class RecommendationModel {
  final int? id;
  final String nama;
  final String kategori;
  final String? gambar;
  final String deskripsi;
  final List<String> tips;
  final bool? isActive;
  final String? createdAt;
  final String? updatedAt;

  RecommendationModel({
    this.id,
    required this.nama,
    required this.kategori,
    this.gambar,
    required this.deskripsi,
    required this.tips,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  /// Factory constructor untuk parsing JSON dari API
  factory RecommendationModel.fromJson(Map<String, dynamic> json) {
    // Parse tips - bisa berupa List atau String JSON
    List<String> parsedTips = [];
    final tipsData = json['tips'];
    
    if (tipsData is List) {
      parsedTips = tipsData.map((e) => e.toString()).toList();
    } else if (tipsData is String && tipsData.isNotEmpty) {
      try {
        // Jika tips berupa JSON string, parse dulu
        final decoded = jsonDecode(tipsData);
        if (decoded is List) {
          parsedTips = decoded.map((e) => e.toString()).toList();
        }
      } catch (_) {
        // Jika gagal parse, anggap sebagai single tip
        parsedTips = [tipsData];
      }
    }

    return RecommendationModel(
      id: json['id'],
      nama: json['title'] ?? json['nama'] ?? json['name'] ?? '',
      kategori: json['category'] ?? json['kategori'] ?? '',
      gambar: json['image'] ?? json['gambar'] ?? json['image_url'],
      deskripsi: json['description'] ?? json['deskripsi'] ?? '',
      tips: parsedTips,
      isActive: json['is_active'] ?? json['isActive'] ?? true,
      createdAt: json['created_at'] ?? json['createdAt'],
      updatedAt: json['updated_at'] ?? json['updatedAt'],
    );
  }

  /// Convert ke JSON (untuk POST/PUT jika diperlukan)
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nama': nama,
      'kategori': kategori,
      if (gambar != null) 'gambar': gambar,
      'deskripsi': deskripsi,
      'tips': tips,
      if (isActive != null) 'is_active': isActive,
    };
  }

  /// Helper untuk mendapatkan URL gambar lengkap
  String? getImageUrl(String baseUrl) {
    if (gambar == null || gambar!.isEmpty) return null;
    
    // Jika sudah full URL
    if (gambar!.startsWith('http://') || gambar!.startsWith('https://')) {
      return gambar;
    }
    
    // Jika relative path
    if (gambar!.startsWith('/')) {
      return '$baseUrl$gambar';
    }
    
    // Default: anggap ada di /storage
    return '$baseUrl/storage/$gambar';
  }
}
