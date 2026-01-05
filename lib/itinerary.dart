import 'package:flutter/material.dart';

class ItineraryScreen extends StatefulWidget {
  final String? namaPaket;
  final String? tanggalLabel;
  final int? jumlahHari;
  final String? imageUrl;

  const ItineraryScreen({
    super.key,
    this.namaPaket,
    this.tanggalLabel,
    this.jumlahHari,
    this.imageUrl,
  });

  @override
  State<ItineraryScreen> createState() => _ItineraryScreenState();
}

class _ItineraryScreenState extends State<ItineraryScreen> {
  int selectedDay = 1;

  String get _namaPaket => (widget.namaPaket ?? '').trim().isNotEmpty ? widget.namaPaket!.trim() : '-';
  String get _tanggal => (widget.tanggalLabel ?? '').trim().isNotEmpty ? widget.tanggalLabel!.trim() : '-';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E88E5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detail Itinerary Per Hari',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      body: Column(
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Status Perjalanan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.white, size: 20),
                      SizedBox(width: 12),
                      Text(
                        '$_tanggal Trip',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Paket Anda Saat Ini',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: (widget.imageUrl ?? '').trim().isNotEmpty
                              ? Image.network(
                                  widget.imageUrl!.trim(),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.image, color: Colors.grey);
                                  },
                                )
                              : const Icon(Icons.image, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _namaPaket,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.jumlahHari != null ? '${widget.jumlahHari} Hari' : '-',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Timeline Section
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Program Timeline',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Timeline Items
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        _buildTimelineItem(
                          day: 1,
                          title: 'Menungu Konfirmasi',
                          time: '12:01 • 15 Dec',
                          isCompleted: true,
                        ),
                        _buildTimelineItem(
                          day: 2,
                          title: 'Pendaftaran Berhasil',
                          time: '12:01 • 15 Dec',
                          subtitle: 'Selamat pendaftaran anda berhasil dilakukan.',
                          isCompleted: true,
                        ),
                        _buildTimelineItem(
                          day: 3,
                          title: 'Pembayaran Berhasil',
                          time: '12:01 • 15 Dec',
                          subtitle: 'Terima kasih, pembayaran anda sudah kami terima.',
                          isCompleted: true,
                        ),
                        _buildTimelineItem(
                          day: 4,
                          title: 'Persiapan Pemberangkatan',
                          time: 'Mulai 1 • 20 Dec',
                          subtitle: 'Mohon persiapkan kebutuhan anda untuk perjalanan.',
                          isActive: true,
                        ),
                        _buildTimelineItem(
                          day: 5,
                          title: 'Waiting Group',
                          time: 'Hotel 1 • 22 Dec',
                          subtitle: 'Menunggu kepastian group berjalan atau tidak.',
                        ),
                        _buildTimelineItem(
                          day: 6,
                          title: 'Keberangkatan Perjalanan',
                          time: 'Menunggu',
                          subtitle: 'Berangkat sesuai jadwal dan selamat jalan.',
                        ),
                        _buildTimelineItem(
                          day: 7,
                          title: 'Selesai',
                          time: 'Selesai',
                          subtitle: 'Perjalanan selesai',
                          isLast: true,
                        ),
                      ],
                    ),
                  ),
                  // Bottom Button
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E88E5),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Kembali',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required int day,
    required String title,
    required String time,
    String? subtitle,
    bool isCompleted = false,
    bool isActive = false,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedDay = day;
        });
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline Indicator
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? Colors.green
                      : isActive
                          ? const Color(0xFF1E88E5)
                          : Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: isCompleted
                      ? const Icon(Icons.check, color: Colors.white, size: 20)
                      : Text(
                          day.toString(),
                          style: TextStyle(
                            color: isActive ? Colors.white : Colors.grey[600],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 60,
                  color: isCompleted ? Colors.green : Colors.grey[300],
                ),
            ],
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isCompleted || isActive ? Colors.black : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
