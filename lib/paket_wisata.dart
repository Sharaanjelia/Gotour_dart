import 'package:flutter/material.dart';
import 'detail_paket.dart';

// Halaman Paket Wisata
class PaketWisataScreen extends StatelessWidget {
  const PaketWisataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Data paket wisata
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
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // List paket
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
                            gambar: paket['gambar'],
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
                          height: 180,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                            child: paket['gambar'] != null
                                ? Image.asset(
                                    paket['gambar'],
                                    width: double.infinity,
                                    height: 180,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.green[200],
                                        child: const Center(
                                          child: Icon(
                                            Icons.card_travel,
                                            size: 60,
                                            color: Colors.white,
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : Container(
                                    color: Colors.green[200],
                                    child: const Center(
                                      child: Icon(
                                        Icons.card_travel,
                                        size: 60,
                                        color: Colors.white,
                                      ),
                                    ),
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
