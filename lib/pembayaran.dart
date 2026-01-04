import 'package:flutter/material.dart';
import 'konfirmasi_pembayaran.dart';
import 'services/api_service.dart';

// Halaman Pembayaran
class PembayaranScreen extends StatefulWidget {
  final String namaTempat;
  final int jumlahOrang;
  final int totalHarga;
  final int? paymentId;

  const PembayaranScreen({
    super.key,
    required this.namaTempat,
    required this.jumlahOrang,
    required this.totalHarga,
    this.paymentId,
  });

  @override
  State<PembayaranScreen> createState() => _PembayaranScreenState();
}

class _PembayaranScreenState extends State<PembayaranScreen> {
  // Metode pembayaran yang dipilih
  String metodePembayaran = '';

  final ApiService _apiService = ApiService();

  String _toApiPaymentMethod(String uiValue) {
    // Backend biasanya hanya menerima enum sederhana seperti: transfer
    // Sementara UI menampilkan label seperti: "Transfer - Mandiri".
    // Agar tidak gagal validasi, kita normalisasi ke nilai yang aman.
    final v = uiValue.trim().toLowerCase();
    if (v.isEmpty) return 'transfer';
    if (v.startsWith('transfer')) return 'transfer';

    // Jika backend kamu mendukung e-wallet/kartu kredit, kamu bisa sesuaikan di sini.
    // Untuk saat ini fallback ke 'transfer' agar tidak invalid.
    return 'transfer';
  }

  // Kategori metode pembayaran
  final Map<String, List<Map<String, dynamic>>> kategoriMetode = {
    'Transfer': [
      {'nama': 'BCA', 'icon': Icons.account_balance},
      {'nama': 'BNI', 'icon': Icons.account_balance},
      {'nama': 'Mandiri', 'icon': Icons.account_balance},
    ],
    'E-Wallet': [
      {'nama': 'OVO', 'icon': Icons.smartphone},
      {'nama': 'GoPay', 'icon': Icons.smartphone},
      {'nama': 'Dana', 'icon': Icons.smartphone},
    ],
    'Kartu Kredit': [
      {'nama': 'Visa', 'icon': Icons.credit_card},
      {'nama': 'Mastercard', 'icon': Icons.credit_card},
      {'nama': 'JCB', 'icon': Icons.credit_card},
    ],
  };

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

  // Fungsi untuk proses pembayaran
  Future<void> prosesPembayaran() async {
    if (metodePembayaran.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Pilih metode pembayaran!')));
      return;
    }

    // Jika paymentId tersedia, update status pembayaran di backend dulu.
    if (widget.paymentId != null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      try {
        final apiMethod = _toApiPaymentMethod(metodePembayaran);
        await _apiService.payPayment(
          widget.paymentId!,
          paymentMethod: apiMethod,
        );
      } catch (e) {
        if (mounted) Navigator.pop(context); // tutup loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal bayar: $e')),
        );
        return;
      }

      if (mounted) Navigator.pop(context); // tutup loading
    }

    // Navigasi ke konfirmasi pembayaran
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => KonfirmasiPembayaranScreen(
          namaTempat: widget.namaTempat,
          metodePembayaran: metodePembayaran,
          totalHarga: widget.totalHarga,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Pembayaran'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Ringkasan Pembayaran
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ringkasan Pembayaran',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Destinasi:'),
                    Flexible(
                      child: Text(
                        widget.namaTempat,
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Jumlah Orang:'),
                    Text(
                      '${widget.jumlahOrang} orang',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Pembayaran:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      formatRupiah(widget.totalHarga),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Pilih Metode Pembayaran
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pilih Metode Pembayaran',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),

          // List Metode Pembayaran
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: kategoriMetode.entries.map((entry) {
                final kategori = entry.key;
                final subMetode = entry.value;
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ExpansionTile(
                    title: Text(
                      kategori,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    children: subMetode.map((sub) {
                      final value = '$kategori - ${sub['nama']}';
                      return RadioListTile<String>(
                        value: value,
                        groupValue: metodePembayaran,
                        onChanged: (val) {
                          setState(() {
                            metodePembayaran = val!;
                          });
                        },
                        title: Text(sub['nama']),
                        secondary: Icon(sub['icon'], color: Colors.blue[700]),
                        activeColor: Colors.blue[700],
                      );
                    }).toList(),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      // Tombol Bayar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: () async {
              if (metodePembayaran.isEmpty) {
                // Tampilkan bottomsheet untuk pilih metode
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (BuildContext context) {
                    return Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Pilih Metode Pembayaran',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Silakan pilih metode pembayaran terlebih dahulu dari daftar di atas',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[700],
                              minimumSize: const Size(double.infinity, 45),
                            ),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              } else {
                await prosesPembayaran();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[700],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Bayar Sekarang', style: TextStyle(fontSize: 18)),
          ),
        ),
      ),
    );
  }
}
