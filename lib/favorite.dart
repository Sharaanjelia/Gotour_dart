import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'detail_paket.dart';
import 'services/api_service.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final ApiService _apiService = ApiService();
  late Future<List> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _favoritesFuture = _apiService.getFavorites();
  }

  Future<void> _refresh() async {
    setState(() {
      _favoritesFuture = _apiService.getFavorites();
    });
    await _favoritesFuture;
  }

  int _asInt(dynamic v) {
    if (v is int) return v;
    if (v is double) return v.round();
    return int.tryParse(v?.toString() ?? '') ?? 0;
  }

  Map<String, dynamic> _asMap(dynamic v) {
    if (v is Map<String, dynamic>) return v;
    if (v is Map) return Map<String, dynamic>.from(v);
    return <String, dynamic>{};
  }

  Map<String, dynamic> _extractPackage(Map<String, dynamic> raw) {
    final package = raw['package'];
    if (package is Map) return Map<String, dynamic>.from(package);
    final paket = raw['paket'];
    if (paket is Map) return Map<String, dynamic>.from(paket);
    final tourPackage = raw['tour_package'];
    if (tourPackage is Map) return Map<String, dynamic>.from(tourPackage);
    return raw;
  }

  int _extractFavoriteId(Map<String, dynamic> raw) {
    // Jika response berbentuk wrapper { id: favoriteId, package: {...} }
    if (raw['package'] is Map || raw['paket'] is Map || raw['tour_package'] is Map) {
      return _asInt(raw['id']);
    }
    // Jika backend mengirim favorite_id
    if (raw.containsKey('favorite_id')) return _asInt(raw['favorite_id']);
    return 0;
  }

  int _extractPackageId(Map<String, dynamic> raw, Map<String, dynamic> package) {
    return _asInt(
      package['id'] ??
          raw['package_id'] ??
          raw['tour_package_id'] ??
          raw['paket_id'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Paket Favorit'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: FutureBuilder<List>(
          future: _favoritesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 60, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _favoritesFuture = _apiService.getFavorites();
                        });
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final favorites = snapshot.data ?? const [];
            if (favorites.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite_border, size: 80, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'Belum ada paket favorit',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final raw = _asMap(favorites[index]);
                  final package = _extractPackage(raw);
                  final favoriteId = _extractFavoriteId(raw);
                  final packageId = _extractPackageId(raw, package);
                  return _buildFavoriteCard(
                    context,
                    raw: raw,
                    package: package,
                    favoriteId: favoriteId,
                    packageId: packageId,
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFavoriteCard(
    BuildContext context, {
    required Map<String, dynamic> raw,
    required Map<String, dynamic> package,
    required int favoriteId,
    required int packageId,
  }) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    final name = (package['name'] ?? package['nama'] ?? raw['name'] ?? raw['nama'] ?? 'Paket').toString();
    final location = (package['location'] ?? package['lokasi'] ?? raw['location'] ?? raw['lokasi'] ?? 'Lokasi tidak tersedia').toString();
    final priceValue = package['price'] ?? package['harga'] ?? raw['price'] ?? raw['harga'] ?? 0;
    final price = currencyFormat.format(_asInt(priceValue));

    final photo = (package['photo'] ??
            package['image'] ??
            package['image_url'] ??
            package['thumbnail'] ??
            raw['photo'] ??
            raw['image'] ??
            raw['image_url'] ??
            raw['thumbnail'])
        ?.toString();

    final isNetwork = (photo ?? '').startsWith('http://') || (photo ?? '').startsWith('https://');

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: packageId > 0
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPaketScreen(packageId: packageId),
                  ),
                );
              }
            : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: (photo != null && photo.trim().isNotEmpty)
                  ? (isNetwork
                      ? Image.network(
                          photo,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 180,
                              color: Colors.grey[300],
                              child: const Icon(Icons.broken_image, size: 60, color: Colors.grey),
                            );
                          },
                        )
                      : Image.asset(
                          photo,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 180,
                              color: Colors.grey[300],
                              child: const Icon(Icons.image, size: 60, color: Colors.grey),
                            );
                          },
                        ))
                  : Container(
                      height: 180,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image, size: 60, color: Colors.grey),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (favoriteId > 0)
                        IconButton(
                          tooltip: 'Hapus dari favorit',
                          onPressed: () => _confirmDeleteFavorite(context, favoriteId),
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location,
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    price,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDeleteFavorite(BuildContext context, int favoriteId) async {
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Hapus Favorit'),
            content: const Text('Yakin ingin menghapus paket ini dari favorit?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Hapus'),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirmed) return;

    try {
      final ok = await _apiService.deleteFavorite(favoriteId);
      if (!mounted) return;
      if (ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Favorit berhasil dihapus')),
        );
        await _refresh();
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus favorit: $e')),
      );
    }
  }
}
