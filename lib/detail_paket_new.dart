import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'pembayaran.dart';
import 'services/api_service.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Detail Paket'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Bagikan paket')),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<Map>(
          future: _apiService.getPackageDetail(widget.packageId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {});
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final package = snapshot.data!;
            final currencyFormat = NumberFormat.currency(
              locale: 'id_ID',
              symbol: 'Rp ',
              decimalDigits: 0,
            );

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Foto paket
                        package['photo'] != null
                            ? Image.network(
                                package['photo'],
                                height: 300,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 300,
                                    color: Colors.grey[300],
                                    child: const Icon(
                                      Icons.broken_image,
                                      size: 80,
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                              )
                            : Container(
                                height: 300,
                                color: Colors.grey[300],
                                child: const Icon(
                                  Icons.image,
                                  size: 80,
                                  color: Colors.grey,
                                ),
                              ),

                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Nama paket
                              Text(
                                package['name'] ?? 'Nama Paket',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Lokasi
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: 20,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      package['location'] ??
                                          'Lokasi tidak tersedia',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Harga
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Harga',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      currencyFormat.format(package['price'] ?? 0),
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Deskripsi
                              const Text(
                                'Deskripsi',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                package['description'] ?? 'Tidak ada deskripsi',
                                style: TextStyle(
                                  fontSize: 15,
                                  height: 1.6,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Book Now button
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () => _showBookingConfirmation(
                      context,
                      package,
                      currencyFormat,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Book Now',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showBookingConfirmation(
    BuildContext context,
    Map package,
    NumberFormat currencyFormat,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Booking'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Booking paket ${package['name']}?'),
            const SizedBox(height: 12),
            Text(
              'Harga: ${currencyFormat.format(package['price'])}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => _processBooking(context, package),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Ya, Book'),
          ),
        ],
      ),
    );
  }

  Future<void> _processBooking(BuildContext context, Map package) async {
    Navigator.pop(context); // Tutup dialog

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final created = await _apiService.createPayment({
        'package_id': package['id'],
        'amount': package['price'],
        'payment_method': 'transfer',
      });

      final idRaw = created['id'] ?? created['payment_id'];
      final paymentId = int.tryParse(idRaw?.toString() ?? '');

      Navigator.pop(context); // Tutup loading

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Booking berhasil!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate ke halaman pembayaran
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => PembayaranScreen(
              namaTempat: (package['name'] ?? package['title'] ?? '-').toString(),
              jumlahOrang: 1,
              totalHarga: int.tryParse((package['price'] ?? 0).toString()) ?? 0,
              paymentId: paymentId,
            ),
        ),
      );
    } catch (e) {
      Navigator.pop(context); // Tutup loading

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Booking gagal: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
