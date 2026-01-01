
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
        backgroundColor: Colors.blue[700],
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
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Membuka: ${blog['judul'] ?? blog['title']}'),
                        action: SnackBarAction(
                          label: 'OK',
                          onPressed: () {},
                        ),
                      ),
                    );
                  },
                  onLongPress: () {
                    // Tampilkan dialog opsi share
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Bagikan Artikel'),
                          content: Text('Bagikan "${blog['judul'] ?? blog['title']}" ke teman Anda?'),
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
                                    content: Text('Artikel berhasil dibagikan!'),
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
                        child: blog['gambar'] != null
                            ? Image.network(
                                blog['gambar'],
                                width: double.infinity,
                                height: 180,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.green[200],
                                    height: 180,
                                    child: const Center(
                                      child: Icon(Icons.image, size: 60, color: Colors.white),
                                    ),
                                  );
                                },
                              )
                            : Container(
                                color: Colors.green[200],
                                height: 180,
                                child: const Center(
                                  child: Icon(Icons.image, size: 60, color: Colors.white),
                                ),
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              blog['judul'] ?? blog['title'] ?? '-',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.person, size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(blog['penulis'] ?? blog['author'] ?? '-', style: const TextStyle(color: Colors.grey)),
                                const SizedBox(width: 16),
                                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(blog['tanggal'] ?? blog['date'] ?? '-', style: const TextStyle(color: Colors.grey)),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              blog['ringkasan'] ?? blog['summary'] ?? '-',
                              style: const TextStyle(fontSize: 15, color: Colors.black87),
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
