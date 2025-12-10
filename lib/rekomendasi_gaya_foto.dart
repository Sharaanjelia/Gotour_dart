import 'package:flutter/material.dart';

// Halaman Rekomendasi Gaya Foto
class RekomendasiGayaFotoScreen extends StatelessWidget {
  const RekomendasiGayaFotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Data rekomendasi gaya foto
    final List<Map<String, dynamic>> gayaFotoList = [
      {
        'nama': 'Candid Natural',
        'kategori': 'Outdoor',
        'deskripsi': 'Gaya foto natural dengan pose santai dan ekspresi alami, sempurna untuk foto di alam terbuka.',
        'tips': [
          'Jangan terlalu kaku, biarkan tubuh rileks',
          'Fokus pada aktivitas yang sedang dilakukan',
          'Manfaatkan cahaya alami dari matahari',
          'Pilih background yang tidak terlalu ramai',
        ],
      },
      {
        'nama': 'Aesthetic Minimalis',
        'kategori': 'Indoor/Outdoor',
        'deskripsi': 'Gaya foto dengan komposisi sederhana dan warna-warna soft, cocok untuk feed Instagram yang aesthetic.',
        'tips': [
          'Gunakan tone warna yang konsisten',
          'Pilih background polos atau minimal',
          'Perhatikan rule of thirds dalam komposisi',
          'Hindari elemen yang terlalu ramai',
        ],
      },
      {
        'nama': 'Vintage Retro',
        'kategori': 'Indoor/Outdoor',
        'deskripsi': 'Gaya foto dengan nuansa vintage menggunakan filter film atau tone warm yang khas.',
        'tips': [
          'Gunakan filter vintage atau preset retro',
          'Pilih lokasi dengan arsitektur klasik',
          'Pakaian dengan warna earth tone',
          'Tambahkan grain untuk efek film',
        ],
      },
      {
        'nama': 'Siluet Sunset',
        'kategori': 'Outdoor',
        'deskripsi': 'Gaya foto dengan memanfaatkan cahaya backlight saat golden hour untuk menciptakan siluet dramatis.',
        'tips': [
          'Foto saat golden hour (30 menit sebelum sunset)',
          'Posisikan subjek di depan cahaya',
          'Gunakan mode manual untuk exposure',
          'Buat pose yang unik dan mudah dikenali',
        ],
      },
      {
        'nama': 'Close-up Detail',
        'kategori': 'Indoor/Outdoor',
        'deskripsi': 'Fokus pada detail wajah atau objek tertentu untuk menciptakan foto yang intimate dan personal.',
        'tips': [
          'Gunakan mode portrait atau aperture besar',
          'Fokus pada mata atau detail menarik',
          'Jaga jarak yang pas dengan subjek',
          'Perhatikan pencahayaan pada wajah',
        ],
      },
      {
        'nama': 'Adventure Action',
        'kategori': 'Outdoor',
        'deskripsi': 'Gaya foto yang menangkap momen aksi dan petualangan dengan komposisi dinamis.',
        'tips': [
          'Gunakan shutter speed tinggi untuk freeze motion',
          'Pilih angle yang dramatik',
          'Tangkap momen puncak dari gerakan',
          'Gunakan wide angle untuk perspektif luas',
        ],
      },
      {
        'nama': 'Flat Lay Creative',
        'kategori': 'Indoor',
        'deskripsi': 'Gaya foto dari atas (bird eye view) dengan arrangement objek yang kreatif dan simetris.',
        'tips': [
          'Gunakan background yang bersih',
          'Atur objek dengan komposisi seimbang',
          'Manfaatkan cahaya natural dari samping',
          'Perhatikan color palette yang harmonis',
        ],
      },
      {
        'nama': 'Urban Street Style',
        'kategori': 'Outdoor',
        'deskripsi': 'Gaya foto kasual di tengah kota dengan memanfaatkan elemen urban sebagai background.',
        'tips': [
          'Cari spot dengan grafiti atau mural menarik',
          'Pakai outfit casual dan stylish',
          'Bermain dengan leading lines di jalan',
          'Manfaatkan arsitektur bangunan',
        ],
      },
      {
        'nama': 'Dreamy Bokeh',
        'kategori': 'Indoor/Outdoor',
        'deskripsi': 'Gaya foto dengan background blur (bokeh) yang indah untuk menciptakan suasana dreamy.',
        'tips': [
          'Gunakan lensa dengan aperture besar (f/1.8-f/2.8)',
          'Cari background dengan sumber cahaya kecil',
          'Jaga jarak antara subjek dan background',
          'Foto saat golden hour untuk bokeh lebih cantik',
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
                              // Icon
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.blue[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.blue[700],
                                  size: 28,
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
