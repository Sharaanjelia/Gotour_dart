import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'booking.dart';
import 'services/api_service.dart';

// Halaman Detail Paket Wisata (API)
class DetailPaketScreen extends StatefulWidget {
  final int packageId;

  const DetailPaketScreen({
    super.key,
    required this.packageId,
  });

  @override
  State<DetailPaketScreen> createState() => _DetailPaketScreenState();
}

class _DetailPaketScreenState extends State<DetailPaketScreen> {
  final ApiService _apiService = ApiService();
  late Future<Map> _future;

  @override
  void initState() {
    super.initState();
    _future = _apiService.getPackageDetail(widget.packageId);
  }

  int _asInt(dynamic v) {
    if (v is int) return v;
    if (v is double) return v.round();
    return int.tryParse(v?.toString() ?? '') ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final rupiah = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Detail Paket'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: FutureBuilder<Map>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 12),
                    Text('Error: ${snapshot.error}', textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => setState(() => _future = _apiService.getPackageDetail(widget.packageId)),
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              );
            }

            final paket = snapshot.data ?? {};
            final name = (paket['name'] ?? paket['nama'] ?? '-').toString();
            final location = (paket['location'] ?? paket['lokasi'] ?? '').toString();
            final description = (paket['description'] ?? paket['deskripsi'] ?? '').toString();
            final imageUrl = (paket['image'] ?? paket['image_url'] ?? paket['gambar'] ?? paket['photo'] ?? paket['thumbnail'] ?? '').toString();
            final price = _asInt(paket['price'] ?? paket['harga'] ?? paket['amount'] ?? 0);

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 260,
                          width: double.infinity,
                          child: imageUrl.isNotEmpty
                              ? Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[300],
                                      child: const Center(child: Icon(Icons.broken_image, size: 64, color: Colors.grey)),
                                    );
                                  },
                                )
                              : Container(
                                  color: Colors.grey[300],
                                  child: const Center(child: Icon(Icons.image, size: 64, color: Colors.grey)),
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              if (location.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.location_on, size: 18, color: Colors.grey[700]),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(location, style: TextStyle(color: Colors.grey[700])),
                                    ),
                                  ],
                                ),
                              ],
                              const SizedBox(height: 16),
                              Text(
                                rupiah.format(price),
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text('Deskripsi Paket', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Text(
                                description.isNotEmpty ? description : '-',
                                style: TextStyle(fontSize: 15, color: Colors.grey[800], height: 1.5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: () async {
                final snapshot = await _future;
                final paket = snapshot;
                final price = _asInt(paket['price'] ?? paket['harga'] ?? paket['amount'] ?? 0);
                final name = (paket['name'] ?? paket['nama'] ?? '-').toString();

                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Konfirmasi Booking'),
                    content: Text('Booking paket $name?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
                      ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Ya')),
                    ],
                  ),
                );

                if (confirm != true) return;

                // Setelah konfirmasi, masuk ke halaman form booking dulu.
                final paketMap = Map<String, dynamic>.from(paket);
                paketMap['id'] ??= widget.packageId;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BookingScreen(paket: paketMap),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Book Now', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ),
    );
  }
}

// Widget untuk item yang termasuk dalam paket
class IncludeItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const IncludeItem({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.green, size: 20),
          const SizedBox(width: 12),
          Text(text, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
        ],
      ),
    );
  }
}

// Widget untuk itinerary
class ItineraryItem extends StatelessWidget {
  final String hari;
  final String kegiatan;

  const ItineraryItem({super.key, required this.hari, required this.kegiatan});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              hari,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              kegiatan,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}
