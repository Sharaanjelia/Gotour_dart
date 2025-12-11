import 'package:flutter/material.dart';

// Halaman Blog Wisata
class BlogWisataScreen extends StatelessWidget {
  const BlogWisataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Data artikel blog
    final List<Map<String, String>> blogList = [
      {
        'judul': '32 Destinasi Wisata Terbaik di Bandung',
        'penulis': 'Admin GoTour',
        'tanggal': '10 Des 2025',
        'ringkasan': 'Temukan destinasi wisata terbaik yang wajib Anda kunjungi saat berada di Bandung.',
        'gambar': 'assets/images/Barusen Hills Ciwidey.jpg',
        'link': 'https://www.klook.com/id/blog/tempat-wisata-di-bandung/?msockid=2e22a4680a5d69d02b50b0f40b016851',
      },
      {
        'judul': '5 Tips Berwisata Hemat',
        'penulis': 'Travel Expert',
        'tanggal': '8 Des 2025',
        'ringkasan': 'Ikuti tips ini untuk berwisata dengan budget yang lebih hemat dan tetap menyenangkan.',
        'gambar': 'assets/images/Ciwidey Valley Hot Spring Waterpark Resort.jpg',
        'link': 'https://www.idntimes.com/travel/tips/zaffy-febryan/tips-wisata-hemat-c1c2',
      },
      {
        'judul': 'Pose Foto yang Menarik',
        'penulis': 'Photography Pro',
        'tanggal': '5 Des 2025',
        'ringkasan': 'Bagi Anda yang senang mengunggah berbagai pose foto, tentu akan sebisa mungkin membuat pose foto yang menarik dan bagus',
        'gambar': 'assets/images/gya fto 2.avif',
        'link': 'https://tekno.kompas.com/read/2022/05/26/11150067/10-ide-pose-foto-untuk-instagram-agar-lebih-menarik#google_vignette',
      },
      {
        'judul': 'Review Makanan',
        'penulis': 'Food Hunter',
        'tanggal': '3 Des 2025',
        'ringkasan': 'Jangan lewatkan untuk mempir ke sederet tempat makanan enak di Bandung dari yang legendaris hingga yang kekinian.',
        'gambar': 'assets/images/tafsor barn.jpg',
        'link': 'https://www.kompas.com/food/read/2023/09/02/131700875/35-tempat-makan-enak-di-bandung-dari-legendaris-hingga-kekinian',
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
                  SnackBar(
                    content: Text('Membuka: ${blog['judul']}'),
                    action: SnackBarAction(
                      label: 'OK',
                      onPressed: () {},
                    ),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gambar artikel
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    child: Image.asset(
                      blog['gambar']!,
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 180,
                          decoration: BoxDecoration(
                            color: Colors.blue[200],
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                          ),
                          child: const Center(
                            child: Icon(Icons.article, size: 60, color: Colors.white),
                          ),
                        );
                      },
                    ),
                  ),                  // Konten artikel
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
                          child: ElevatedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Link: ${blog['link']}'),
                                  duration: const Duration(seconds: 3),
                                ),
                              );
                            },
                            icon: const Icon(Icons.arrow_forward, size: 16),
                            label: const Text('Baca Selengkapnya'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[700],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
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
