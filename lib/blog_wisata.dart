import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'services/api_service.dart';

// Halaman Blog Wisata (API + search)
class BlogWisataScreen extends StatefulWidget {
  const BlogWisataScreen({super.key});

  @override
  State<BlogWisataScreen> createState() => _BlogWisataScreenState();
}

class _BlogWisataScreenState extends State<BlogWisataScreen> {
  final ApiService _apiService = ApiService();
  late Future<List> _future;
  List _cache = const [];

  String _resolveMediaUrl(String input) {
    final raw = input.trim();
    if (raw.isEmpty) return '';

    final normalized = raw.replaceAll('\\', '/');
    if (normalized.startsWith('http://') || normalized.startsWith('https://')) {
      return normalized.contains('%') ? normalized.replaceAll(' ', '%20') : Uri.encodeFull(normalized);
    }

    final origin = ApiService.baseUrl.replaceFirst(RegExp(r'\/api\/?$'), '');
    String absolute;
    if (normalized.startsWith('/')) {
      absolute = '$origin$normalized';
    } else if (normalized.startsWith('storage/')) {
      absolute = '$origin/$normalized';
    } else if (normalized.startsWith('public/storage/')) {
      absolute = '$origin/${normalized.replaceFirst('public/', '')}';
    } else {
      absolute = '$origin/storage/$normalized';
    }

    return absolute.contains('%') ? absolute.replaceAll(' ', '%20') : Uri.encodeFull(absolute);
  }

  @override
  void initState() {
    super.initState();
    _future = _apiService.getBlogs();
  }

  Future<void> _refresh() async {
    setState(() {
      _future = _apiService.getBlogs();
    });
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Blog Wisata'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              if (_cache.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Data blog belum siap. Coba refresh dulu.')),
                );
                return;
              }
              showSearch(
                context: context,
                delegate: BlogSearchDelegate(
                  blogs: _cache,
                  onTap: (blogId) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => BlogDetailScreen(blogId: blogId)),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: FutureBuilder<List>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return ListView(
                  children: [
                    const SizedBox(height: 120),
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text('Error: ${snapshot.error}', textAlign: TextAlign.center),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: ElevatedButton(
                        onPressed: _refresh,
                        child: const Text('Coba Lagi'),
                      ),
                    ),
                  ],
                );
              }

              final blogs = snapshot.data ?? const [];
              _cache = blogs;

              if (blogs.isEmpty) {
                return ListView(
                  children: const [
                    SizedBox(height: 120),
                    Icon(Icons.article_outlined, size: 80, color: Colors.grey),
                    SizedBox(height: 12),
                    Center(child: Text('Belum ada artikel blog.')),
                  ],
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: blogs.length,
                itemBuilder: (context, index) {
                  final blog = blogs[index];
                  final id = (blog['id'] ?? blog['blog_id'] ?? 0) as dynamic;
                  final blogId = int.tryParse(id.toString()) ?? 0;
                  final title = (blog['title'] ?? blog['judul'] ?? '-').toString();
                  final excerpt = (blog['excerpt'] ?? blog['ringkasan'] ?? blog['content'] ?? '').toString();
                  final thumbRaw = (blog['thumbnail'] ?? blog['image'] ?? blog['image_url'] ?? blog['gambar'] ?? '').toString();
                  final thumb = _resolveMediaUrl(thumbRaw);

                  DateTime date = DateTime.now();
                  final rawDate = blog['created_at'] ?? blog['date'] ?? blog['tanggal'];
                  if (rawDate != null) {
                    try {
                      date = DateTime.parse(rawDate.toString());
                    } catch (_) {}
                  }

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      onTap: blogId == 0
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => BlogDetailScreen(blogId: blogId)),
                              );
                            },
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          width: 80,
                          height: 80,
                          child: thumb.isNotEmpty
                              ? Image.network(
                                  thumb,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.broken_image, color: Colors.grey),
                                  ),
                                )
                              : Container(
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image, color: Colors.grey),
                                ),
                        ),
                      ),
                      title: Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(excerpt, maxLines: 2, overflow: TextOverflow.ellipsis),
                      trailing: Text(dateFormat.format(date), style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class BlogDetailScreen extends StatefulWidget {
  final int blogId;
  const BlogDetailScreen({super.key, required this.blogId});

  @override
  State<BlogDetailScreen> createState() => _BlogDetailScreenState();
}

class _BlogDetailScreenState extends State<BlogDetailScreen> {
  final ApiService _apiService = ApiService();
  late Future<Map> _future;

  String _resolveMediaUrl(String input) {
    final raw = input.trim();
    if (raw.isEmpty) return '';

    final normalized = raw.replaceAll('\\', '/');
    if (normalized.startsWith('http://') || normalized.startsWith('https://')) {
      return normalized.contains('%') ? normalized.replaceAll(' ', '%20') : Uri.encodeFull(normalized);
    }

    final origin = ApiService.baseUrl.replaceFirst(RegExp(r'\/api\/?$'), '');
    String absolute;
    if (normalized.startsWith('/')) {
      absolute = '$origin$normalized';
    } else if (normalized.startsWith('storage/')) {
      absolute = '$origin/$normalized';
    } else if (normalized.startsWith('public/storage/')) {
      absolute = '$origin/${normalized.replaceFirst('public/', '')}';
    } else {
      absolute = '$origin/storage/$normalized';
    }

    return absolute.contains('%') ? absolute.replaceAll(' ', '%20') : Uri.encodeFull(absolute);
  }

  @override
  void initState() {
    super.initState();
    _future = _apiService.getBlogDetail(widget.blogId);
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Detail Blog'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: FutureBuilder<Map>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 12),
                    Text('Error: ${snapshot.error}', textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => setState(() => _future = _apiService.getBlogDetail(widget.blogId)),
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              );
            }

            final blog = snapshot.data ?? {};
            final title = (blog['title'] ?? blog['judul'] ?? '-').toString();
            final content = (blog['content'] ?? blog['isi'] ?? blog['ringkasan'] ?? '').toString();
            final author = (blog['author'] ?? blog['penulis'] ?? '').toString();
            final imageUrlRaw = (blog['image'] ?? blog['image_url'] ?? blog['thumbnail'] ?? blog['gambar'] ?? '').toString();
            final imageUrl = _resolveMediaUrl(imageUrlRaw);

            DateTime date = DateTime.now();
            final rawDate = blog['created_at'] ?? blog['date'] ?? blog['tanggal'];
            if (rawDate != null) {
              try {
                date = DateTime.parse(rawDate.toString());
              } catch (_) {}
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (imageUrl.isNotEmpty)
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[300],
                          child: const Center(child: Icon(Icons.broken_image, size: 64, color: Colors.grey)),
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(dateFormat.format(date), style: TextStyle(color: Colors.grey[600])),
                            if (author.isNotEmpty) ...[
                              const SizedBox(width: 8),
                              const Text('•'),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  author,
                                  style: TextStyle(color: Colors.grey[600]),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(content.isNotEmpty ? content : '-', style: const TextStyle(fontSize: 15, height: 1.6)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class BlogSearchDelegate extends SearchDelegate {
  final List blogs;
  final void Function(int blogId) onTap;

  BlogSearchDelegate({
    required this.blogs,
    required this.onTap,
  });

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) => _buildList(context);

  @override
  Widget buildSuggestions(BuildContext context) => _buildList(context);

  Widget _buildList(BuildContext context) {
    final q = query.toLowerCase().trim();
    final results = q.isEmpty
        ? blogs
        : blogs.where((b) => (b['title'] ?? b['judul'] ?? '').toString().toLowerCase().contains(q)).toList();

    if (results.isEmpty) {
      return const Center(child: Text('Tidak ada hasil.'));
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final blog = results[index];
        final id = blog['id'] ?? blog['blog_id'] ?? 0;
        final blogId = int.tryParse(id.toString()) ?? 0;
        final title = (blog['title'] ?? blog['judul'] ?? '-').toString();
        return ListTile(
          title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
          onTap: blogId == 0
              ? null
              : () {
                  close(context, null);
                  onTap(blogId);
                },
        );
      },
    );
  }
}
