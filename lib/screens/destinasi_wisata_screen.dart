import 'package:flutter/material.dart';
import 'detail_destinasi_screen.dart';

// Halaman Destinasi Wisata
class DestinasiWisataScreen extends StatelessWidget {
  const DestinasiWisataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Data dummy destinasi wisata
    final List<Map<String, dynamic>> destinasiList = [
      {
        'nama': 'Pantai Kuta',
        'lokasi': 'Bali',
        'harga': 'Rp 150.000',
        'rating': 4.5,
        'deskripsi':
            'Pantai terindah di Bali dengan pemandangan sunset yang menakjubkan.',
      },
      {
        'nama': 'Gunung Bromo',
        'lokasi': 'Jawa Timur',
        'harga': 'Rp 200.000',
        'rating': 4.8,
        'deskripsi':
            'Gunung berapi aktif dengan pemandangan sunrise yang spektakuler.',
      },
      {
        'nama': 'Raja Ampat',
        'lokasi': 'Papua',
        'harga': 'Rp 500.000',
        'rating': 4.9,
        'deskripsi':
            'Surga bawah laut dengan keanekaragaman hayati terbaik di dunia.',
      },
      {
        'nama': 'Candi Borobudur',
        'lokasi': 'Yogyakarta',
        'harga': 'Rp 100.000',
        'rating': 4.7,
        'deskripsi':
            'Candi Buddha terbesar di dunia yang megah dan bersejarah.',
      },
      {
        'nama': 'Danau Toba',
        'lokasi': 'Sumatera Utara',
        'harga': 'Rp 180.000',
        'rating': 4.6,
        'deskripsi':
            'Danau vulkanik terbesar di Indonesia dengan keindahan alam yang menawan.',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Destinasi Wisata'),
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
                hintText: 'Cari destinasi...',
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

          // List Destinasi
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: destinasiList.length,
              itemBuilder: (context, index) {
                final destinasi = destinasiList[index];
                return DestinasiItemCard(
                  nama: destinasi['nama'],
                  lokasi: destinasi['lokasi'],
                  harga: destinasi['harga'],
                  rating: destinasi['rating'],
                  deskripsi: destinasi['deskripsi'],
                  onTap: () {
                    // Navigasi ke detail destinasi
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailDestinasiScreen(
                          nama: destinasi['nama'],
                          lokasi: destinasi['lokasi'],
                          harga: destinasi['harga'],
                          rating: destinasi['rating'],
                          deskripsi: destinasi['deskripsi'],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Widget Card untuk Item Destinasi
class DestinasiItemCard extends StatelessWidget {
  final String nama;
  final String lokasi;
  final String harga;
  final double rating;
  final String deskripsi;
  final VoidCallback onTap;

  const DestinasiItemCard({
    super.key,
    required this.nama,
    required this.lokasi,
    required this.harga,
    required this.rating,
    required this.deskripsi,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Gambar placeholder
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.blue[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.image, size: 40, color: Colors.white),
              ),
              const SizedBox(width: 12),

              // Info Destinasi
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nama,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          lokasi,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      deskripsi,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          harga,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.amber[700],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              rating.toString(),
                              style: const TextStyle(
                                fontSize: 14,
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
      ),
    );
  }
}
