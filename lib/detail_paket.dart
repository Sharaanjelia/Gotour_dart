import 'package:flutter/material.dart';
import 'booking.dart';

// Halaman Detail Paket Wisata
class DetailPaketScreen extends StatelessWidget {
  final String nama;
  final String harga;
  final String durasi;
  final double rating;
  final String deskripsi;

  const DetailPaketScreen({
    super.key,
    required this.nama,
    required this.harga,
    required this.durasi,
    required this.rating,
    required this.deskripsi,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Detail Paket'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Bagikan paket')));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gambar paket
                  Container(
                    height: 250,
                    decoration: BoxDecoration(color: Colors.green[300]),
                    child: const Center(
                      child: Icon(
                        Icons.card_travel,
                        size: 100,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  // Info Paket
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nama dan Rating
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                nama,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    rating.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Durasi
                        Row(
                          children: [
                            Icon(Icons.access_time, color: Colors.blue[700]),
                            const SizedBox(width: 8),
                            Text(
                              durasi,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Harga
                        Row(
                          children: [
                            Text(
                              harga,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[700],
                              ),
                            ),
                            Text(
                              ' /paket',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Deskripsi
                        const Text(
                          'Deskripsi Paket',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          deskripsi,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Include dalam paket
                        const Text(
                          'Termasuk Dalam Paket',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        IncludeItem(icon: Icons.hotel, text: 'Akomodasi Hotel'),
                        IncludeItem(
                          icon: Icons.restaurant,
                          text: 'Makan 3x Sehari',
                        ),
                        IncludeItem(
                          icon: Icons.directions_car,
                          text: 'Transportasi',
                        ),
                        IncludeItem(icon: Icons.person, text: 'Tour Guide'),
                        IncludeItem(
                          icon: Icons.confirmation_number,
                          text: 'Tiket Masuk',
                        ),
                        const SizedBox(height: 24),

                        // Itinerary
                        const Text(
                          'Itinerary',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ItineraryItem(
                          hari: 'Hari 1',
                          kegiatan: 'Tiba di lokasi, check-in hotel, city tour',
                        ),
                        ItineraryItem(
                          hari: 'Hari 2',
                          kegiatan: 'Explore destinasi utama, foto session',
                        ),
                        ItineraryItem(
                          hari: 'Hari 3',
                          kegiatan: 'Belanja oleh-oleh, check-out, pulang',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // Tombol Booking
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      BookingScreen(namaTempat: nama, harga: harga),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[700],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Booking Paket', style: TextStyle(fontSize: 18)),
          ),
        ),
      ),
    );
  }
}

// Widget untuk item yang termasuk dalam paket
class IncludeItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const IncludeItem({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.green, size: 20),
          const SizedBox(width: 12),
          Text(text, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
        ],
      ),
    );
  }
}

// Widget untuk itinerary
class ItineraryItem extends StatelessWidget {
  final String hari;
  final String kegiatan;

  const ItineraryItem({super.key, required this.hari, required this.kegiatan});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue[700],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              hari,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              kegiatan,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}
