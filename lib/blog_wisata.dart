import 'package:flutter/material.dart';

// Halaman Blog Wisata
class BlogWisataScreen extends StatelessWidget {
  const BlogWisataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Data dummy artikel blog
    final List<Map<String, String>> blogList = [
      {
        'judul': '10 Tempat Wisata Terbaik di Indonesia',
        'penulis': 'Admin GoTour',
        'tanggal': '5 Des 2025',
        'ringkasan':
            'Temukan 10 destinasi wisata paling menakjubkan di Indonesia yang wajib dikunjungi.',
      },
      {
        'judul': 'Tips Traveling Hemat untuk Backpacker',
        'penulis': 'Traveler Pro',
        'tanggal': '3 Des 2025',
        'ringkasan':
            'Panduan lengkap traveling hemat dengan budget minimal untuk para backpacker.',
      },
      {
        'judul': 'Kuliner Khas yang Wajib Dicoba di Bali',
        'penulis': 'Food Hunter',
        'tanggal': '1 Des 2025',
        'ringkasan':
            'Jelajahi kelezatan kuliner khas Bali yang akan memanjakan lidah Anda.',
      },
      {
        'judul': 'Panduan Lengkap Mendaki Gunung Rinjani',
        'penulis': 'Mountain Guide',
        'tanggal': '28 Nov 2025',
        'ringkasan':
            'Persiapan dan tips mendaki Gunung Rinjani untuk pendaki pemula.',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Blog Wisata'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: blogList.length,
        itemBuilder: (context, index) {
          final blog = blogList[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Membuka: ${blog['judul']}')),
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gambar artikel (placeholder)
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.purple[200],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: const Center(
                      child: Icon(Icons.article, size: 60, color: Colors.white),
                    ),
                  ),

                  // Konten artikel
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Judul
                        Text(
                          blog['judul']!,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Penulis dan Tanggal
                        Row(
                          children: [
                            Icon(
                              Icons.person,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              blog['penulis']!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              blog['tanggal']!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Ringkasan
                        Text(
                          blog['ringkasan']!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),

                        // Tombol Baca Selengkapnya
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Membuka: ${blog['judul']}'),
                                ),
                              );
                            },
                            child: const Text('Baca Selengkapnya >'),
                          ),
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
    );
  }
}
