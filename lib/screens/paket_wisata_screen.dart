import 'package:flutter/material.dart';
import 'detail_paket_screen.dart';

// Halaman Paket Wisata
class PaketWisataScreen extends StatelessWidget {
  const PaketWisataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Data dummy paket wisata
    final List<Map<String, dynamic>> paketList = [
      {
        'nama': 'Paket Bali 3 Hari 2 Malam',
        'harga': 'Rp 2.500.000',
        'durasi': '3 Hari 2 Malam',
        'rating': 4.8,
        'deskripsi':
            'Explore keindahan Bali dengan paket lengkap termasuk hotel dan tour guide.',
      },
      {
        'nama': 'Paket Bromo Sunrise',
        'harga': 'Rp 1.200.000',
        'durasi': '2 Hari 1 Malam',
        'rating': 4.7,
        'deskripsi':
            'Nikmati sunrise spektakuler di Gunung Bromo dengan fasilitas lengkap.',
      },
      {
        'nama': 'Paket Raja Ampat Diving',
        'harga': 'Rp 8.000.000',
        'durasi': '5 Hari 4 Malam',
        'rating': 4.9,
        'deskripsi': 'Paket diving eksklusif di surga bawah laut Raja Ampat.',
      },
      {
        'nama': 'Paket Yogyakarta Heritage',
        'harga': 'Rp 1.500.000',
        'durasi': '3 Hari 2 Malam',
        'rating': 4.6,
        'deskripsi':
            'Jelajahi warisan budaya Yogyakarta dengan tour guide profesional.',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Paket Wisata'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari paket wisata...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // List Paket
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: paketList.length,
              itemBuilder: (context, index) {
                final paket = paketList[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPaketScreen(
                            nama: paket['nama'],
                            harga: paket['harga'],
                            durasi: paket['durasi'],
                            rating: paket['rating'],
                            deskripsi: paket['deskripsi'],
                          ),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Gambar paket
                        Container(
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.green[200],
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.card_travel,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        // Info paket
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                paket['nama'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    paket['durasi'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    paket['harga'],
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue[700],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        size: 18,
                                        color: Colors.amber[700],
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        paket['rating'].toString(),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
