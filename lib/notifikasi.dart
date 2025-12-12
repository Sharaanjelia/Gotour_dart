import 'package:flutter/material.dart';

// Halaman Notifikasi
class NotifikasiScreen extends StatelessWidget {
  const NotifikasiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Data dummy notifikasi
    final List<Map<String, dynamic>> notifikasiList = [
      {
        'title': 'Booking Berhasil!',
        'message': 'Booking Anda untuk Gunung Bromo telah dikonfirmasi.',
        'time': '2 jam yang lalu',
        'isRead': false,
        'type': 'booking',
      },
      {
        'title': 'Promo Spesial!',
        'message': 'Diskon 20% untuk paket wisata Bali. Buruan pesan!',
        'time': '1 hari yang lalu',
        'isRead': false,
        'type': 'promo',
      },
      {
        'title': 'Pembayaran Berhasil',
        'message': 'Pembayaran untuk Pantai Kuta telah diterima.',
        'time': '2 hari yang lalu',
        'isRead': true,
        'type': 'payment',
      },
      {
        'title': 'Update Status Booking',
        'message': 'Status booking Danau Toba telah diperbarui.',
        'time': '3 hari yang lalu',
        'isRead': true,
        'type': 'update',
      },
      {
        'title': 'Selamat Datang!',
        'message': 'Terima kasih telah bergabung dengan GoTour.',
        'time': '1 minggu yang lalu',
        'isRead': true,
        'type': 'welcome',
      },
    ];

    IconData getNotificationIcon(String type) {
      switch (type) {
        case 'booking':
          return Icons.check_circle;
        case 'promo':
          return Icons.local_offer;
        case 'payment':
          return Icons.payment;
        case 'update':
          return Icons.update;
        case 'welcome':
          return Icons.waving_hand;
        default:
          return Icons.notifications;
      }
    }

    Color getNotificationColor(String type) {
      switch (type) {
        case 'booking':
          return Colors.green;
        case 'promo':
          return Colors.orange;
        case 'payment':
          return Colors.blue;
        case 'update':
          return Colors.purple;
        case 'welcome':
          return Colors.teal;
        default:
          return Colors.grey;
      }
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Notifikasi'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () {
              // Mark all as read (placeholder)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Semua notifikasi ditandai sebagai dibaca')),
              );
            },
            child: const Text(
              'Tandai Semua Dibaca',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
      body: notifikasiList.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Belum ada notifikasi',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notifikasiList.length,
              itemBuilder: (context, index) {
                final notif = notifikasiList[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: notif['isRead'] ? 1 : 3,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: getNotificationColor(notif['type']).withOpacity(0.1),
                      child: Icon(
                        getNotificationIcon(notif['type']),
                        color: getNotificationColor(notif['type']),
                      ),
                    ),
                    title: Text(
                      notif['title'],
                      style: TextStyle(
                        fontWeight: notif['isRead'] ? FontWeight.normal : FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          notif['message'],
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notif['time'],
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    trailing: notif['isRead']
                        ? null
                        : Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                          ),
                    onTap: () {
                      // Mark as read and show detail (placeholder)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Notifikasi: ${notif['title']}')),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}