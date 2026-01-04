import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'e_tiket.dart';
import 'pembayaran.dart';
import 'services/api_service.dart';

class RiwayatBookingScreen extends StatefulWidget {
  const RiwayatBookingScreen({super.key});

  @override
  State<RiwayatBookingScreen> createState() => _RiwayatBookingScreenState();
}

class _RiwayatBookingScreenState extends State<RiwayatBookingScreen> {
  final ApiService _apiService = ApiService();
  late Future<List> _future;

  @override
  void initState() {
    super.initState();
    _future = _apiService.getPayments();
  }

  Future<void> _refresh() async {
    setState(() {
      _future = _apiService.getPayments();
    });
    await _future;
  }

  Color _statusColor(String status) {
    final s = status.toLowerCase();
    if (s.contains('paid') || s.contains('selesai') || s.contains('success')) return Colors.green;
    if (s.contains('pending') || s.contains('proses') || s.contains('unpaid')) return Colors.orange;
    if (s.contains('cancel') || s.contains('batal') || s.contains('failed')) return Colors.red;
    return Colors.grey;
  }

  bool _isPaid(String status) {
    final s = status.toLowerCase();
    return s.contains('paid') || s.contains('selesai') || s.contains('success');
  }

  void _goToPay({
    required int paymentId,
    required String packageName,
    required int amount,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PembayaranScreen(
          namaTempat: packageName,
          jumlahOrang: 1,
          totalHarga: amount,
          paymentId: paymentId,
        ),
      ),
    );
  }

  Future<void> _confirmDelete(int paymentId) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Riwayat'),
        content: const Text('Yakin ingin menghapus riwayat pembayaran ini?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Hapus')),
        ],
      ),
    );

    if (ok != true) return;
    try {
      await _apiService.deletePayment(paymentId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Riwayat dihapus.')));
      await _refresh();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final rupiah = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final dateFormat = DateFormat('dd MMM yyyy');

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Riwayat Pembayaran'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
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

              final payments = snapshot.data ?? const [];
              if (payments.isEmpty) {
                return ListView(
                  children: const [
                    SizedBox(height: 140),
                    Icon(Icons.receipt_long_outlined, size: 80, color: Colors.grey),
                    SizedBox(height: 12),
                    Center(child: Text('Belum ada riwayat pembayaran.')),
                  ],
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: payments.length,
                itemBuilder: (context, index) {
                  final p = payments[index] is Map ? payments[index] as Map : <dynamic, dynamic>{};
                  final idRaw = p['id'] ?? p['payment_id'] ?? 0;
                  final paymentId = int.tryParse(idRaw.toString()) ?? 0;

                  final status = (p['status'] ?? p['payment_status'] ?? '-').toString();
                  final statusColor = _statusColor(status);

                  final packageRaw = p['package'] ?? p['paket'];
                  final package = packageRaw is Map ? packageRaw : <dynamic, dynamic>{};
                  final packageName = (
                    p['package_name'] ??
                    p['nama_paket'] ??
                    package['name'] ??
                    package['title'] ??
                    package['nama'] ??
                    '-'
                  ).toString();

                  final amountRaw = p['amount'] ?? p['total'] ?? p['total_amount'] ?? p['harga'] ?? 0;
                  final amount = int.tryParse(amountRaw.toString()) ?? 0;

                  DateTime date = DateTime.now();
                  final rawDate = p['created_at'] ?? p['date'] ?? p['tanggal'];
                  if (rawDate != null) {
                    try {
                      date = DateTime.parse(rawDate.toString());
                    } catch (_) {}
                  }

                  return Card(
                    margin: const EdgeInsets.only(bottom: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  packageName,
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ),
                              PopupMenuButton<String>(
                                onSelected: (v) {
                                  if (v == 'delete' && paymentId != 0) {
                                    _confirmDelete(paymentId);
                                  }
                                },
                                itemBuilder: (_) => [
                                  const PopupMenuItem(value: 'delete', child: Text('Hapus')),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                              const SizedBox(width: 6),
                              Text(dateFormat.format(date), style: const TextStyle(color: Colors.grey)),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  status,
                                  style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total Pembayaran:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                              Text(
                                rupiah.format(amount),
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: paymentId == 0
                                      ? null
                                      : () {
                                          if (_isPaid(status)) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => ETiketScreen(namaTempat: packageName, totalHarga: amount),
                                              ),
                                            );
                                          } else {
                                            _goToPay(paymentId: paymentId, packageName: packageName, amount: amount);
                                          }
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context).primaryColor,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                  child: Text(_isPaid(status) ? 'Lihat E-Tiket' : 'Bayar'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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