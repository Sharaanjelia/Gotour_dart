import 'package:flutter/material.dart';
import 'home.dart';
import 'itinerary.dart';
import 'e_tiket.dart';

// Halaman Konfirmasi Pembayaran
class KonfirmasiPembayaranScreen extends StatelessWidget {
  final String namaTempat;
  final String metodePembayaran;
  final int totalHarga;
  final String? tanggalLabel;
  final int? jumlahOrang;
  final int? paymentId;
  final String? bookingCode;
  final String? imageUrl;
  final int? jumlahHari;

  const KonfirmasiPembayaranScreen({
    super.key,
    required this.namaTempat,
    required this.metodePembayaran,
    required this.totalHarga,
    this.tanggalLabel,
    this.jumlahOrang,
    this.paymentId,
    this.bookingCode,
    this.imageUrl,
    this.jumlahHari,
  });

  // Fungsi untuk format rupiah
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                // Icon Success
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, size: 80, color: Colors.white),
                ),
                const SizedBox(height: 32),

                // Judul
                const Text(
                  'Pembayaran Berhasil!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                const Text(
                  'Terima kasih telah melakukan booking',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Detail Pembayaran
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Column(
                    children: [
                      DetailRow(label: 'Destinasi', value: namaTempat),
                      const Divider(height: 24),
                      DetailRow(
                        label: 'Metode Pembayaran',
                        value: metodePembayaran,
                      ),
                      const Divider(height: 24),
                      DetailRow(
                        label: 'Total Bayar',
                        value: formatRupiah(totalHarga),
                        isHighlight: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                const Text(
                  'Tiket dan detail booking telah dikirim ke email Anda',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Tombol E-Tiket
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ETiketScreen(
                            namaTempat: namaTempat,
                            totalHarga: totalHarga,
                            tanggalLabel: tanggalLabel,
                            jumlahOrang: jumlahOrang,
                            paymentId: paymentId,
                            bookingCode: bookingCode,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.confirmation_number),
                    label: const Text(
                      'Lihat E-Tiket',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Tombol Lihat Itinerary
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ItineraryScreen(
                            namaPaket: namaTempat,
                            tanggalLabel: tanggalLabel,
                            jumlahHari: jumlahHari,
                            imageUrl: imageUrl,
                          ),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue[700],
                      side: BorderSide(color: Colors.blue[700]!, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Lihat Itinerary',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Tombol Kembali ke Home
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // Kembali ke home dan hapus semua route sebelumnya
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Kembali ke Beranda',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Widget untuk row detail
class DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isHighlight;

  const DetailRow({
    super.key,
    required this.label,
    required this.value,
    this.isHighlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isHighlight ? 16 : 14,
            fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
            color: Colors.grey[700],
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: isHighlight ? 18 : 14,
              fontWeight: FontWeight.bold,
              color: isHighlight ? Colors.blue[700] : Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
