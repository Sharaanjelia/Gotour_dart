import 'package:flutter/material.dart';
import 'api_laravel_blog.dart';

// Halaman Blog Wisata
class BlogWisataScreen extends StatelessWidget {
  const BlogWisataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Blog Wisata'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchBlogList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada artikel blog.'));
          }

          final blogList = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: blogList.length,
            itemBuilder: (context, index) {
              final blog = blogList[index];

              final judul = (blog['judul'] ?? blog['title'] ?? '-').toString();
              final penulis = (blog['penulis'] ?? blog['author'] ?? '-')
                  .toString();
              final tanggal = (blog['tanggal'] ?? blog['date'] ?? '-')
                  .toString();
              final ringkasan = (blog['ringkasan'] ?? blog['summary'] ?? '-')
                  .toString();
              final gambar = blog['gambar']?.toString();

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Membuka: $judul'),
                        action: SnackBarAction(label: 'OK', onPressed: () {}),
                      ),
                    );
                  },
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Bagikan Artikel'),
                          content: Text('Bagikan "$judul" ke teman Anda?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Batal'),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Artikel berhasil dibagikan!',
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.share),
                              label: const Text('Bagikan'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        child: (gambar != null && gambar.isNotEmpty)
                            ? Image.network(
                                gambar,
                                width: double.infinity,
                                height: 180,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.green[200],
                                    height: 180,
                                    child: const Center(
                                      child: Icon(
                                        Icons.image,
                                        size: 60,
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Container(
                                color: Colors.green[200],
                                height: 180,
                                child: const Center(
                                  child: Icon(
                                    Icons.image,
                                    size: 60,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              judul,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.person,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  penulis,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(width: 16),
                                const Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  tanggal,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              ringkasan,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black87,
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
          );
        },
      ),
    );
  }
}
