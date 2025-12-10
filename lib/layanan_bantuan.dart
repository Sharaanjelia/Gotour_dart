import 'package:flutter/material.dart';

// Halaman Layanan Bantuan
class LayananBantuanScreen extends StatelessWidget {
  const LayananBantuanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Layanan Bantuan'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue[700],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.support_agent, size: 50, color: Colors.white),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Butuh Bantuan?',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Kami siap membantu Anda 24/7',
                          style: TextStyle(fontSize: 14, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Hubungi Kami
            const Text(
              'Hubungi Kami',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // WhatsApp
            BantuanCard(
              icon: Icons.phone,
              title: 'WhatsApp',
              subtitle: '+62 812-3456-7890',
              color: Colors.green,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Membuka WhatsApp...')),
                );
              },
            ),

            // Email
            BantuanCard(
              icon: Icons.email,
              title: 'Email',
              subtitle: 'support@gotour.com',
              color: Colors.blue,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Membuka Email...')),
                );
              },
            ),

            // Live Chat
            BantuanCard(
              icon: Icons.chat,
              title: 'Live Chat',
              subtitle: 'Chat dengan Customer Service',
              color: Colors.orange,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Membuka Live Chat...')),
                );
              },
            ),

            const SizedBox(height: 24),

            // FAQ
            const Text(
              'Pertanyaan yang Sering Diajukan (FAQ)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            FAQCard(
              pertanyaan: 'Bagaimana cara melakukan booking?',
              jawaban:
                  'Pilih destinasi atau paket wisata, isi form booking, lalu lakukan pembayaran.',
            ),
            FAQCard(
              pertanyaan: 'Metode pembayaran apa saja yang tersedia?',
              jawaban:
                  'Kami menerima transfer bank, e-wallet (OVO, GoPay, Dana), dan kartu kredit.',
            ),
            FAQCard(
              pertanyaan: 'Apakah bisa refund jika batal?',
              jawaban:
                  'Refund dapat dilakukan maksimal 7 hari sebelum tanggal keberangkatan.',
            ),
            FAQCard(
              pertanyaan: 'Bagaimana cara menggunakan kode promo?',
              jawaban:
                  'Masukkan kode promo pada saat checkout untuk mendapatkan diskon.',
            ),
          ],
        ),
      ),
    );
  }
}

// Widget Card untuk Bantuan
class BantuanCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const BantuanCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

// Widget Card untuk FAQ
class FAQCard extends StatefulWidget {
  final String pertanyaan;
  final String jawaban;

  const FAQCard({super.key, required this.pertanyaan, required this.jawaban});

  @override
  State<FAQCard> createState() => _FAQCardState();
}

class _FAQCardState extends State<FAQCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          setState(() {
            isExpanded = !isExpanded;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.pertanyaan,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                ],
              ),
              if (isExpanded) ...[
                const SizedBox(height: 12),
                Text(
                  widget.jawaban,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
