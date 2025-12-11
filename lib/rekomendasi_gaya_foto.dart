import 'package:flutter/material.dart';

// Halaman Rekomendasi Gaya Foto
class RekomendasiGayaFotoScreen extends StatelessWidget {
  const RekomendasiGayaFotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Data rekomendasi gaya foto
    final List<Map<String, dynamic>> gayaFotoList = [
      {
        'nama': 'Gaya Foto 1',
        'kategori': 'Pose Duduk',
        'gambar': 'assets/images/gya fto 2.avif',
        'deskripsi': 'Pose duduk santai dengan ekspresi natural, cocok untuk foto outdoor maupun indoor.',
        'tips': [
          'Duduk dengan posisi yang nyaman dan rileks',
          'Tangan bisa diletakkan di paha atau lutut',
          'Tatapan ke arah kamera atau ke samping',
          'Background yang simpel lebih baik',
        ],
      },
      {
        'nama': 'Gaya Foto 2',
        'kategori': 'Pose Menikmati Alam',
        'gambar': 'assets/images/gya fto 1.jpg',
        'deskripsi': 'Gaya foto dengan nuansa menikmati keindahan alam, sempurna untuk destinasi wisata alam.',
        'tips': [
          'Berdiri atau duduk menghadap pemandangan',
          'Tangan bisa menyentuh rambut atau diangkat',
          'Ekspresi rileks dan menikmati suasana',
          'Manfaatkan cahaya natural dari matahari',
        ],
      },
      {
        'nama': 'Gaya Foto 3',
        'kategori': 'Pose Ekspresi Bebas',
        'gambar': 'assets/images/gya fto 3.avif',
        'deskripsi': 'Gaya foto dengan ekspresi bebas dan candid, menunjukkan kepribadian yang ceria.',
        'tips': [
          'Jangan takut untuk bergerak bebas',
          'Tunjukkan ekspresi yang genuine',
          'Tertawa atau senyum natural',
          'Biarkan fotografer capture momen spontan',
        ],
      },
      {
        'nama': 'Gaya Foto 4',
        'kategori': 'Pose Ceria',
        'gambar': 'assets/images/gya fto 14.jpg',
        'deskripsi': 'Pose dengan ekspresi ceria dan energik, cocok untuk foto grup atau solo.',
        'tips': [
          'Senyum lebar dan tunjukkan kebahagiaan',
          'Gesture tangan yang playful',
          'Mata yang berbinar',
          'Background yang colorful menambah vibe ceria',
        ],
      },
      {
        'nama': 'Gaya Foto 5',
        'kategori': 'Pose Santai Berdiri',
        'gambar': 'assets/images/gya fto 5.jpg',
        'deskripsi': 'Pose berdiri santai dengan body language yang rileks, cocok untuk casual photoshoot.',
        'tips': [
          'Berdiri dengan satu kaki sedikit ditekuk',
          'Tangan di saku atau menyentuh rambut',
          'Badan sedikit miring ke samping',
          'Tatapan natural ke kamera',
        ],
      },
      {
        'nama': 'Gaya Foto 6',
        'kategori': 'Pose Santai di Jalan',
        'gambar': 'assets/images/gya fto 6.jpg',
        'deskripsi': 'Gaya foto urban dengan pose santai di tengah jalan atau trotoar.',
        'tips': [
          'Berjalan santai atau berhenti sejenak',
          'Tangan di saku atau membawa tas',
          'Tatapan ke depan atau samping',
          'Manfaatkan leading lines dari jalan',
        ],
      },
      {
        'nama': 'Gaya Foto 7',
        'kategori': 'Pose Liburan',
        'gambar': 'assets/images/gya fto 7.jpg',
        'deskripsi': 'Pose khas liburan dengan vibe happy dan santai, sempurna untuk kenangan traveling.',
        'tips': [
          'Tunjukkan antusiasme liburan',
          'Bisa dengan topi atau kacamata',
          'Gesture tangan yang fun',
          'Background destinasi wisata yang iconic',
        ],
      },
      {
        'nama': 'Gaya Foto 8',
        'kategori': 'Pose Elegan',
        'gambar': 'assets/images/gya fto 16.jpg',
        'deskripsi': 'Gaya foto elegan dengan postur yang anggun dan classy.',
        'tips': [
          'Postur tubuh yang tegak dan anggun',
          'Tangan dengan gesture yang lembut',
          'Ekspresi yang tenang dan confident',
          'Outfit formal atau semi-formal',
        ],
      },
      {
        'nama': 'Gaya Foto 9',
        'kategori': 'Pose Berjalan Santai',
        'gambar': 'assets/images/gya fto 10.jpg',
        'deskripsi': 'Pose candid saat berjalan dengan langkah santai, menciptakan kesan natural.',
        'tips': [
          'Berjalan dengan tempo yang santai',
          'Tangan bebas atau di saku',
          'Tatapan ke depan atau ke samping',
          'Fotografer capture dari samping atau belakang',
        ],
      },
      {
        'nama': 'Gaya Foto 10',
        'kategori': 'Casual Natural Pose',
        'gambar': 'assets/images/gya fto 11.jpg',
        'deskripsi': 'Gaya foto kasual dengan pose yang sangat natural dan tidak dibuat-buat.',
        'tips': [
          'Pose seperti sedang tidak difoto',
          'Ekspresi rileks dan natural',
          'Interaksi dengan lingkungan sekitar',
          'Cahaya natural lebih baik',
        ],
      },
      {
        'nama': 'Gaya Foto 11',
        'kategori': 'Headphone dan Pemandangan Kota',
        'gambar': 'assets/images/gya foto 12.jpg',
        'deskripsi': 'Gaya foto urban dengan headphone dan city view sebagai background.',
        'tips': [
          'Pakai headphone sebagai props',
          'Background gedung atau skyline kota',
          'Tatapan menerawang atau fokus',
          'Vibe yang modern dan urban',
        ],
      },
      {
        'nama': 'Gaya Foto 12',
        'kategori': 'Playful Candid Pose',
        'gambar': 'assets/images/gya fto 13.jpg',
        'deskripsi': 'Pose candid yang playful dan penuh energi, cocok untuk foto yang fun.',
        'tips': [
          'Gerakan yang spontan dan playful',
          'Tertawa atau ekspresi senang',
          'Loncat, lari, atau gerakan dinamis',
          'Shutter speed tinggi untuk freeze motion',
        ],
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Rekomendasi Gaya Foto'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Header Info
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              border: Border(
                bottom: BorderSide(color: Colors.blue[100]!),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tips Fotografi untuk Wisata',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Jadikan momen liburanmu lebih berkesan dengan gaya foto yang menarik!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),

          // List Gaya Foto
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: gayaFotoList.length,
              itemBuilder: (context, index) {
                final gaya = gayaFotoList[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 2,
                  child: InkWell(
                    onTap: () {
                      // Show detail dialog
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(gaya['nama']),
                          content: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Chip(
                                  label: Text(
                                    gaya['kategori'],
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  backgroundColor: Colors.blue[100],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  gaya['deskripsi'],
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Tips & Tricks:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ...List.generate(
                                  gaya['tips'].length,
                                  (i) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${i + 1}. ',
                                          style: TextStyle(
                                            color: Colors.blue[700],
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(gaya['tips'][i]),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Tutup'),
                            ),
                          ],
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(15),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // Image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  gaya['gambar'],
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: Colors.blue[100],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: Colors.blue[700],
                                        size: 32,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      gaya['nama'],
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.category,
                                          size: 16,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          gaya['kategori'],
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Arrow
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.grey[400],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            gaya['deskripsi'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                              height: 1.5,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange[50],
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.orange[200]!,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.tips_and_updates,
                                  size: 16,
                                  color: Colors.orange[700],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${gaya['tips'].length} Tips',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.orange[700],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
