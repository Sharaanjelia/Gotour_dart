import 'package:flutter/material.dart';

// Halaman Promo
class PromoListScreen extends StatelessWidget {
  const PromoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Data dummy promo
    final List<Map<String, String>> promoList = [
      {
        'judul': 'Diskon 50% Paket Bali',
        'deskripsi': 'Dapatkan diskon hingga 50% untuk paket wisata Bali!',
        'kode': 'BALI50',
        'berlaku': '31 Des 2025',
      },
      {
        'judul': 'Gratis Hotel 1 Malam',
        'deskripsi': 'Bonus gratis menginap 1 malam di hotel berbintang',
        'kode': 'HOTEL1',
        'berlaku': '15 Jan 2026',
      },
      {
        'judul': 'Cashback 100K',
        'deskripsi': 'Cashback Rp 100.000 untuk transaksi minimal Rp 1 juta',
        'kode': 'CASH100',
        'berlaku': '28 Feb 2026',
      },
      {
        'judul': 'Promo Tahun Baru',
        'deskripsi': 'Diskon 30% untuk semua destinasi wisata',
        'kode': 'NEWYEAR30',
        'berlaku': '10 Jan 2026',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Promo Spesial'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: promoList.length,
        itemBuilder: (context, index) {
          final promo = promoList[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [Colors.blue[700]!, Colors.blue[400]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Judul Promo
                    Text(
                      promo['judul']!,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Deskripsi
                    Text(
                      promo['deskripsi']!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Kode dan Berlaku
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Kode Promo
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            promo['kode']!,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[700],
                              letterSpacing: 1,
                            ),
                          ),
                        ),

                        // Berlaku Sampai
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'Berlaku sampai',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                            Text(
                              promo['berlaku']!,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
