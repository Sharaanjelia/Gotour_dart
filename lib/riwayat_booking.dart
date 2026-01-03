
import 'package:flutter/material.dart';
import 'api_laravel_riwayat.dart';

// Halaman Riwayat Booking
class RiwayatBookingScreen extends StatelessWidget {
  final String token;
  const RiwayatBookingScreen({super.key, required this.token});

  @override
  Widget build(BuildContext context) {


    String formatRupiah(int angka) {
      String str = angka.toString();
      String result = '';
      int counter = 0;
      for (int i = str.length - 1; i >= 0; i--) {
        if (counter == 3) {
          result = '.$result';
          counter = 0;
        }
        result = str[i] + result;
        counter++;
      }
      return 'Rp $result';
    }

    Color getStatusColor(String status) {
      switch (status) {
        case 'Selesai':
          return Colors.green[200]!;
        case 'Dalam Proses':
          return Colors.orange[200]!;
        case 'Dibatalkan':
          return Colors.red[200]!;
        default:
          return Colors.grey[300]!;
      }
    }

    Color getStatusTextColor(String status) {
      switch (status) {
        case 'Selesai':
          return Colors.green[800]!;
        case 'Dalam Proses':
          return Colors.orange[800]!;
        case 'Dibatalkan':
          return Colors.red[800]!;
        default:
          return Colors.grey[800]!;
      }
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Riwayat Booking'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchRiwayatBooking(token: token),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada riwayat booking.'));
          }
          final riwayatBooking = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: riwayatBooking.length,
            itemBuilder: (context, index) {
              final item = riwayatBooking[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(18),
                        topRight: Radius.circular(18),
                      ),
                      child: item['gambar'] != null
                          ? Image.network(
                              item['gambar'],
                              height: 160,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              height: 160,
                              color: Colors.green[200],
                              child: const Center(
                                child: Icon(Icons.card_travel, size: 60, color: Colors.white),
                              ),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item['namaTempat'] ?? item['nama_tempat'] ?? '-',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: getStatusColor(item['status'] ?? ''),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  item['status'] ?? '-',
                                  style: TextStyle(
                                    color: getStatusTextColor(item['status'] ?? ''),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                              const SizedBox(width: 6),
                              Text(item['tanggal'] ?? '-', style: const TextStyle(color: Colors.grey)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.people, size: 18, color: Colors.grey),
                              const SizedBox(width: 6),
                              Text('${item['jumlahOrang'] ?? item['jumlah_orang'] ?? '-'} orang', style: const TextStyle(color: Colors.grey)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total Pembayaran:', style: TextStyle(fontWeight: FontWeight.w500)),
                              Text(
                                formatRupiah(item['harga'] is int ? item['harga'] : int.tryParse(item['harga'].toString()) ?? 0),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}