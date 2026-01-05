import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'e_tiket.dart';

// Halaman Pembayaran
class PembayaranScreen extends StatefulWidget {
  final String namaTempat;
  final int jumlahOrang;
  final int totalHarga;
  final int? paymentId;
  final String? tanggalLabel;
  final String? bookingCode;
  final String? imageUrl;
  final int? jumlahHari;
  final String? namaPemesan;
  final String? email;

  const PembayaranScreen({
    super.key,
    required this.namaTempat,
    required this.jumlahOrang,
    required this.totalHarga,
    this.paymentId,
    this.tanggalLabel,
    this.bookingCode,
    this.imageUrl,
    this.jumlahHari,
    this.namaPemesan,
    this.email,
  });

  @override
  State<PembayaranScreen> createState() => _PembayaranScreenState();
}

class _PembayaranScreenState extends State<PembayaranScreen> {
  // Metode pembayaran yang dipilih
  String metodePembayaran = '';

  final ApiService _apiService = ApiService();

  String _toApiPaymentMethod(String uiValue) {
    // Backend kamu memvalidasi `payment_method` dengan nilai tertentu (enum/slug).
    // UI menampilkan label seperti: "Transfer - Mandiri" / "E-Wallet - GoPay".
    // Kita ambil provider (bagian setelah '-') sebagai slug: mandiri/gopay/dana/visa/dll.
    final raw = uiValue.trim();
    if (raw.isEmpty) return '';

    final parts = raw.split('-').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    final provider = (parts.length >= 2 ? parts.last : parts.first).toLowerCase();

    // Normalisasi beberapa nama umum.
    if (provider.contains('go pay') || provider == 'go-pay') return 'gopay';
    if (provider.contains('gojek')) return 'gopay';
    if (provider.contains('ovo')) return 'ovo';
    if (provider.contains('dana')) return 'dana';
    if (provider.contains('mandiri')) return 'mandiri';
    if (provider.contains('bca')) return 'bca';
    if (provider.contains('bni')) return 'bni';
    if (provider.contains('visa')) return 'visa';
    if (provider.contains('mastercard')) return 'mastercard';
    if (provider.contains('jcb')) return 'jcb';

    // Fallback: slugify sederhana (hapus spasi)
    return provider.replaceAll(' ', '');
  }

  String _toApiCategoryMethod(String uiValue) {
    final raw = uiValue.trim();
    if (raw.isEmpty) return '';
    final parts = raw.split('-').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    final category = (parts.isNotEmpty ? parts.first : raw).toLowerCase();

    if (category.startsWith('transfer')) {
      // Nilai yang sering dipakai di backend: transfer / bank_transfer
      return 'bank_transfer';
    }
    if (category.startsWith('e-wallet') || category.startsWith('ewallet')) {
      return 'ewallet';
    }
    if (category.startsWith('kartu kredit') || category.startsWith('credit')) {
      return 'credit_card';
    }
    return '';
  }

  List<String> _paymentMethodCandidates(String uiValue) {
    final provider = _toApiPaymentMethod(uiValue);
    final category = _toApiCategoryMethod(uiValue);
    final candidates = <String>[
      provider,
      category,
      // alias umum
      if (category == 'bank_transfer') 'transfer',
      if (category == 'ewallet') 'e_wallet',
    ];

    // Uniq + non-empty
    final out = <String>[];
    for (final c in candidates) {
      final v = c.trim();
      if (v.isEmpty) continue;
      if (out.contains(v)) continue;
      out.add(v);
    }
    return out;
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
        final candidates = _paymentMethodCandidates(metodePembayaran);

        Exception? lastError;
        for (final method in candidates) {
          try {
            await _apiService.payPayment(
              widget.paymentId!,
              paymentMethod: method,
            );
            lastError = null;
            break;
          } catch (e) {
            lastError = e is Exception ? e : Exception(e.toString());
          }
        }

        if (lastError != null) throw lastError;
      } catch (e) {
        if (mounted) Navigator.pop(context); // tutup loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal bayar: $e')),
        );
        return;
      }

      if (mounted) Navigator.pop(context); // tutup loading
    }

    // Setelah bayar sukses, langsung ke E-Tiket (sesuai flow yang diminta).
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ETiketScreen(
          namaTempat: widget.namaTempat,
          totalHarga: widget.totalHarga,
          tanggalLabel: widget.tanggalLabel,
          jumlahOrang: widget.jumlahOrang,
          paymentId: widget.paymentId,
          bookingCode: widget.bookingCode,
          namaPemesan: widget.namaPemesan,
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
