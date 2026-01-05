import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'services/api_service.dart';
import 'detail_paket.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaketWisataScreen extends StatefulWidget {
  const PaketWisataScreen({super.key});

  @override
  State<PaketWisataScreen> createState() => _PaketWisataScreenState();
}

class _PaketWisataScreenState extends State<PaketWisataScreen> {
  final ApiService _apiService = ApiService();
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkUserRole();
  }

  Future<void> _checkUserRole() async {
    try {
      final user = await _apiService.getUser();
      setState(() {
        _isAdmin = user['role'] == 'admin';
      });
    } catch (e) {
      // User belum login atau error
    }
  }

  @override
  Widget build(BuildContext context) {
    // Data paket wisata - backup jika API gagal
    final List<Map<String, dynamic>> paketList = [
      {
        'id': 1,
        'nama': 'Barusan Hills Satu',
        'slug': 'barusan-hills-satu',
        'harga': 'Rp 1.500.000',
        'durasi': '2 Hari 1 Malam',
        'rating': 4.8,
        'gambar': 'assets/images/Barusen Hills Ciwidey.jpg',
        'excerpt': 'Barusen Hills Ciwidey adalah sebuah tempat wisata yang terletak di kawasan Ciwidey, dekat Lembang.',
        'deskripsi': 'Tempat ini dikenal dengan pemandangan alam yang indah dan suasana yang tenang, menjadikannya pilihan populer untuk berlibur. Barusen Hills menawarkan berbagai fasilitas seperti spot foto menarik, area bermain anak, dan jalur trekking yang memungkinkan pengunjung menikmati keindahan alam sekitar.\n\nFasilitas:\n• Akomodasi Hotel Bintang 4\n• Transportasi selama tour\n• Tour guide berpengalaman\n• Asuransi perjalanan',
        'featured': true,
      },
      {
        'id': 2,
        'nama': 'Ciwidey Valley',
        'slug': 'ciwidey-valley',
        'harga': 'Rp 1.000.000',
        'durasi': '3 Hari 2 Malam',
        'rating': 4.7,
        'gambar': 'assets/images/Ciwidey Valley Hot Spring Waterpark Resort.jpg',
        'excerpt': 'Destinasi liburan yang sempurna bagi pecinta olahraga di Bandung, Indonesia.',
        'deskripsi': 'Ciwidey Valley Hot Spring Waterpark Resort adalah resor yang menawarkan pengalaman relaksasi dengan pemandian air panas alami. Dikenal karena kolam renangnya yang luas dan fasilitas spa, resor ini menjadi tempat ideal untuk bersantai sambil menikmati keindahan alam Ciwidey.\n\nFasilitas:\n• Akomodasi Hotel Bintang 4\n• Transportasi selama tour\n• Tour guide berpengalaman\n• Asuransi perjalanan',
        'featured': true,
      },
      {
        'id': 3,
        'nama': 'Tafsor Barn',
        'slug': 'tafsor-barn',
        'harga': 'Rp 679.000',
        'durasi': '1 Hari 0 Malam',
        'rating': 4.6,
        'gambar': 'assets/images/tafsor barn.jpg',
        'excerpt': 'Tafso Barn adalah sebuah restoran dan kafe yang terletak di Pagerwangi, Lembang, Bandung Barat.',
        'deskripsi': 'Didirikan pada tahun 2016, tempat ini awalnya dibangun sebagai area bermain mini golf yang juga menyajikan berbagai makanan dan minuman. Seiring waktu, Tafso Barn menjadi terkenal karena konsepnya yang kekinian dan suasana yang sangat instagramable.\n\nFasilitas:\n• Akomodasi Hotel Bintang 4\n• Transportasi selama tour\n• Tour guide berpengalaman\n• Asuransi perjalanan',
        'featured': true,
      },
      {
        'id': 4,
        'nama': 'Orchid Forest Cikole',
        'slug': 'orchid-forest-cikole',
        'harga': 'Rp 699.000',
        'durasi': '2 Hari 1 Malam',
        'rating': 4.9,
        'gambar': 'assets/images/orchid forest cikole.jpg',
        'excerpt': 'Terletak di Cikole, Lembang, Kabupaten Bandung Barat, Jawa Barat, orchid forest cikole adalah hutan anggrek terbesar di Indonesia.',
        'deskripsi': 'Enggak main-main, jumlah anggrek di sini mencapai 20.000 tanaman! Selain anggrek, barisan pohon pinus yang ada di sana juga membuat pemandangan Orchid Forest Cikole menjadi sangat indah.\n\nFasilitas:\n• Akomodasi Hotel Bintang 4\n• Transportasi selama tour\n• Tour guide berpengalaman\n• Asuransi perjalanan',
        'featured': true,
      },
      {
        'id': 5,
        'nama': 'Kampung Cai Ranca Upas',
        'slug': 'kampung-cai-ranva-upas',
        'harga': 'Rp 419.000',
        'durasi': '1 Hari 2 Malam',
        'rating': 4.5,
        'gambar': 'assets/images/kampung cai ranva upas.webp',
        'excerpt': 'Jika ingin ke luar kota Bandung, Ciwidey adalah area yang wajib kamu kunjungi!',
        'deskripsi': 'Salah satu tempat wisata paling menarik di Ciwidey adalah Kampung Cai Ranca Upas. Selain punya area perkemahan yang cantik, Kampung Cai Ranca Upas juga punya Penangkaran Rusa yang menyenangkan untuk dikunjungi.\n\nFasilitas:\n• Akomodasi Hotel Bintang 4\n• Transportasi selama tour\n• Tour guide berpengalaman\n• Asuransi perjalanan',
        'featured': true,
      },
      {
        'id': 6,
        'nama': 'The Lodge Maribaya',
        'slug': 'the-lodge-maribaya',
        'harga': 'Rp 350.000',
        'durasi': '2 Hari 1 Malam',
        'rating': 4.8,
        'gambar': 'assets/images/The Lodge Maribaya.jpg',
        'excerpt': 'Objek wisata di Lembang tengah berkembang banget selama beberapa tahun belakangan, dan The Lodge Maribaya adalah salah satu destinasi wisata di Lembang yang mencuat dan menjadi populer.',
        'deskripsi': 'Dengan wajah baru sejak 2016 lalu, The Lodge Maribaya menawarkan tempat wisata di Bandung yang ideal bagi keluarga yang menginginkan liburan unik.\n\nFasilitas:\n• Akomodasi Hotel Bintang 4\n• Transportasi selama tour\n• Tour guide berpengalaman\n• Asuransi perjalanan',
        'featured': true,
      },
      {
        'id': 7,
        'nama': 'Tebing Karaton',
        'slug': 'tebing-karaton',
        'harga': 'Rp 376.000',
        'durasi': '1 Hari 2 Malam',
        'rating': 4.7,
        'gambar': 'assets/images/Tebing karaton.webp',
        'excerpt': 'Tebing Keraton adalah sebuah tebing dengan pemandangan luar biasa di area Taman Hutan Raya Ir. H. Djuanda.',
        'deskripsi': 'Kalau ingin merasakan pengalaman melihat lautan pohon yang hijau dari atas tebing, di sinilah tempatnya. Banyak orang juga yang datang sekitar subuh untuk melihat matahari terbit di sini.\n\nFasilitas:\n• Akomodasi Hotel Bintang 4\n• Transportasi selama tour\n• Tour guide berpengalaman\n• Asuransi perjalanan',
        'featured': true,
      },
      {
        'id': 8,
        'nama': 'Taman Hutan Raya Ir. H. Djuanda',
        'slug': 'taman-hutan-raya-ir-h-djuanda',
        'harga': 'Rp 639.000',
        'durasi': '1 Hari 1 Malam',
        'rating': 4.6,
        'gambar': 'assets/images/Taman Hutan Raya Ir. H. Djuanda.webp',
        'excerpt': 'Taman Hutan Raya Ir. H. Djuanda memang bukan sekadar taman - ini adalah hutan kota yang terletak di area Dago Pakar.',
        'deskripsi': 'Taman yang kerap disebut Tahura oleh warga Bandung ini juga jadi salah satu tempat wisata di Bandung favorit - termasuk bagi masyarakat kota Bandung sekalipun.\n\nFasilitas:\n• Akomodasi Hotel Bintang 4\n• Transportasi selama tour\n• Tour guide berpengalaman\n• Asuransi perjalanan',
        'featured': true,
      },
      {
        'id': 9,
        'nama': 'Kawah Putih Ciwidey',
        'slug': 'kawah-putih-ciwidey',
        'harga': 'Rp 350.000',
        'durasi': '2 Hari 1 Malam',
        'rating': 4.9,
        'gambar': 'assets/images/kawah putih ciwidey.webp',
        'excerpt': 'Sering melihat menjadi latar untuk foto-foto yang Instagramable? Well, memang sepopuler itu tempat wisata di Bandung ini.',
        'deskripsi': 'Kawah Putih Ciwidey sendiri merupakan danau kawah yang terbentuk dari letusan Gunung Patuha, salah satu gunung berapi di Jawa Barat. Air di danau kawah ini memiliki kandungan asam yang sangat tinggi.\n\nFasilitas:\n• Akomodasi Hotel Bintang 4\n• Transportasi selama tour\n• Tour guide berpengalaman\n• Asuransi perjalanan',
        'featured': true,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Paket Wisata'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: FutureBuilder<List>(
          future: _apiService.getPackages(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {});
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Belum ada paket wisata',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              );
            }

            final packages = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: packages.length,
              itemBuilder: (context, index) {
                final package = packages[index];
                return _buildPackageCard(context, package);
              },
            );
          },
        ),
      ),
      floatingActionButton: _isAdmin
          ? FloatingActionButton(
              onPressed: () => _showAddPackageDialog(context),
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildPackageCard(BuildContext context, Map package) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    final photoUrl = (package['photo'] ??
            package['cover_image_url'] ??
            package['image_url'] ??
            package['image'] ??
            package['thumbnail'] ??
            '')
        .toString();
    final hasPhoto = photoUrl.trim().isNotEmpty;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailPaketScreen(packageId: package['id']),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto paket
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: hasPhoto
                    ? Image.network(
                        photoUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.broken_image,
                              size: 60,
                              color: Colors.grey,
                            ),
                          );
                        },
                      )
                    : Container(
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.image,
                          size: 60,
                          color: Colors.grey,
                        ),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama paket
                  Text(
                    package['name'] ?? 'Nama Paket',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Lokasi
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          package['location'] ?? 'Lokasi tidak tersedia',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Harga
                  Text(
                    currencyFormat.format(package['price'] ?? 0),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Deskripsi
                  Text(
                    package['description'] ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddPackageDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final priceController = TextEditingController();
    final locationController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Paket Wisata'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Paket',
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) =>
                      val!.isEmpty ? 'Nama paket tidak boleh kosong' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: locationController,
                  decoration: const InputDecoration(
                    labelText: 'Lokasi',
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) =>
                      val!.isEmpty ? 'Lokasi tidak boleh kosong' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: priceController,
                  decoration: const InputDecoration(
                    labelText: 'Harga',
                    border: OutlineInputBorder(),
                    prefixText: 'Rp ',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (val) =>
                      val!.isEmpty ? 'Harga tidak boleh kosong' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (val) =>
                      val!.isEmpty ? 'Deskripsi tidak boleh kosong' : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;

              try {
                await _apiService.createPackage({
                  'name': nameController.text,
                  'description': descriptionController.text,
                  'price': int.parse(priceController.text),
                  'location': locationController.text,
                });

                Navigator.pop(context);
                setState(() {}); // Refresh list
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Paket berhasil ditambahkan!')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}
