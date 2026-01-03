
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
        title: Text('Blog Wisata'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchBlogList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Belum ada artikel blog.'));
          }
          final blogList = snapshot.data!;
          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: blogList.length,
            itemBuilder: (context, index) {
              final blog = blogList[index];
              return Card(
                margin: EdgeInsets.only(bottom: 16),
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
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Bagikan Artikel'),
                          content: Text('Bagikan "${blog['judul'] ?? blog['title']}" ke teman Anda?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Batal'),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Artikel berhasil dibagikan!'),
                                  ),
                                );
                              },
                              icon: Icon(Icons.share),
                              label: Text('Bagikan'),
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
                        borderRadius: BorderRadius.only(
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
                                    child: Center(
                                      child: Icon(Icons.image, size: 60, color: Colors.white),
                                    ),
                                  );
                                },
                              )
                            : Container(
                                color: Colors.green[200],
                                height: 180,
                                child: Center(
                                  child: Icon(Icons.image, size: 60, color: Colors.white),
                                ),
                              ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              blog['judul'] ?? blog['title'] ?? '-',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.person, size: 16, color: Colors.grey),
                                SizedBox(width: 4),
                                Text(blog['penulis'] ?? blog['author'] ?? '-', style: TextStyle(color: Colors.grey)),
                                SizedBox(width: 16),
                                Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                                SizedBox(width: 4),
                                Text(blog['tanggal'] ?? blog['date'] ?? '-', style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                            SizedBox(height: 12),
                            Text(
                              blog['ringkasan'] ?? blog['summary'] ?? '-',
                              style: TextStyle(fontSize: 15, color: Colors.black87),
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
  
