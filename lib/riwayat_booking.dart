import 'package:flutter/material.dart';

// Halaman Riwayat Booking
class RiwayatBookingScreen extends StatelessWidget {
  const RiwayatBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Data dummy untuk riwayat booking
    final List<Map<String, dynamic>> riwayatBooking = [
      {
        'namaTempat': 'Gunung Bromo',
        'tanggal': '15 Desember 2025',
        'status': 'Selesai',
        'harga': 500000,
        'jumlahOrang': 2,
      },
      {
        'namaTempat': 'Pantai Kuta Bali',
        'tanggal': '20 Desember 2025',
        'status': 'Dalam Proses',
        'harga': 750000,
        'jumlahOrang': 3,
      },
      {
        'namaTempat': 'Borobudur Magelang',
        'tanggal': '10 November 2025',
        'status': 'Selesai',
        'harga': 300000,
        'jumlahOrang': 1,
      },
      {
        'namaTempat': 'Danau Toba',
        'tanggal': '5 Januari 2026',
        'status': 'Dibatalkan',
        'harga': 600000,
        'jumlahOrang': 4,
      },
    ];

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
          return Colors.green;
        case 'Dalam Proses':
          return Colors.orange;
        case 'Dibatalkan':
          return Colors.red;
        default:
          return Colors.grey;
      }
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Riwayat Booking'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: riwayatBooking.isEmpty
          ? const Center(
              child: Text(
                'Belum ada riwayat booking',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: riwayatBooking.length,
              itemBuilder: (context, index) {
                final booking = riwayatBooking[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                booking['namaTempat'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: getStatusColor(booking['status']).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                booking['status'],
                                style: TextStyle(
                                  color: getStatusColor(booking['status']),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                            const SizedBox(width: 5),
                            Text(
                              booking['tanggal'],
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(Icons.people, size: 16, color: Colors.grey),
                            const SizedBox(width: 5),
                            Text(
                              '${booking['jumlahOrang']} orang',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Pembayaran:',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              formatRupiah(booking['harga']),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[700],
                              ),
                            ),
                          ],
                        ),
                        if (booking['status'] == 'Selesai') ...[
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                // Navigasi ke detail booking atau e-tiket
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Lihat detail booking ${booking['namaTempat']}'),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[700],
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('Lihat Detail'),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}