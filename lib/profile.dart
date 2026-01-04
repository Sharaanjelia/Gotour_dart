import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'e_tiket.dart';
import 'favorite.dart';
import 'testimonial_screen.dart';
import 'itinerary.dart';
import 'layanan_bantuan.dart';
import 'login.dart';
import 'blog_wisata.dart';
import 'rekomendasi_gaya_foto.dart';
import 'riwayat_booking.dart';
import 'services/api_service.dart';
import 'services_screen.dart';
import 'settings.dart';

// Halaman Profile
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService _apiService = ApiService();
  bool _isUploading = false;

  Future<void> _confirmLogout() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (ok != true) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_id');
    await prefs.remove('user_name');
    await prefs.remove('user_email');

    if (!mounted) return;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  void _showPhotoSourceDialog(Map user) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Pilih Sumber Foto'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Kamera'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeri'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    if (_isUploading) return;

    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: source, imageQuality: 80);
      if (picked == null) return;

      setState(() => _isUploading = true);
      await _apiService.uploadProfilePhoto(File(picked.path));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Foto profil berhasil diupload.')));
      setState(() {});
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Profil Saya'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: FutureBuilder<Map>(
          future: _apiService.getUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 60, color: Colors.red),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text('Error: ${snapshot.error}', textAlign: TextAlign.center),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(onPressed: () => setState(() {}), child: const Text('Retry')),
                  ],
                ),
              );
            }

            final user = snapshot.data ?? <dynamic, dynamic>{};
            final name = (user['name'] ?? user['nama'] ?? 'User').toString();
            final email = (user['email'] ?? '').toString();
            final phone = (user['phone'] ?? user['no_hp'] ?? user['telp'] ?? '-').toString();
            final address = (user['address'] ?? user['alamat'] ?? '-').toString();
            final photoUrl = (user['photo'] ?? user['photo_url'] ?? user['avatar'] ?? '').toString();

            return SingleChildScrollView(
              child: Column(
                children: [
                  // Header
                  Container(
                    height: 220,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColor.withOpacity(0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 4),
                                ),
                                child: CircleAvatar(
                                  radius: 52,
                                  backgroundColor: Colors.white,
                                  backgroundImage: photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
                                  child: photoUrl.isEmpty
                                      ? Text(
                                          name.isNotEmpty ? name[0].toUpperCase() : 'U',
                                          style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                                        )
                                      : null,
                                ),
                              ),
                              if (_isUploading)
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(color: Colors.black.withOpacity(0.35), shape: BoxShape.circle),
                                    child: const Center(child: CircularProgressIndicator(color: Colors.white)),
                                  ),
                                ),
                              Positioned(
                                bottom: 2,
                                right: 2,
                                child: CircleAvatar(
                                  backgroundColor: Theme.of(context).primaryColor,
                                  radius: 18,
                                  child: IconButton(
                                    icon: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                                    onPressed: () => _showPhotoSourceDialog(user),
                                    padding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            name,
                            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(email, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Informasi
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 2, blurRadius: 5),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Informasi Pribadi',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        const Divider(height: 20),
                        ProfileInfoItem(icon: Icons.phone, title: 'Nomor HP', value: phone),
                        const SizedBox(height: 15),
                        ProfileInfoItem(icon: Icons.location_on, title: 'Alamat', value: address),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Menu
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 2, blurRadius: 5),
                      ],
                    ),
                    child: Column(
                      children: [
                        ProfileMenuItem(
                          icon: Icons.receipt_long,
                          title: 'Riwayat Pembayaran',
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const RiwayatBookingScreen()));
                          },
                        ),
                        const Divider(height: 1),
                        ProfileMenuItem(
                          icon: Icons.rate_review,
                          title: 'Testimoni',
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const TestimonialScreen()));
                          },
                        ),
                        const Divider(height: 1),
                        ProfileMenuItem(
                          icon: Icons.local_offer,
                          title: 'Layanan & Promo',
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const ServicesScreen()));
                          },
                        ),
                        const Divider(height: 1),
                        ProfileMenuItem(
                          icon: Icons.article,
                          title: 'Blog Wisata',
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const BlogWisataScreen()));
                          },
                        ),
                        const Divider(height: 1),
                        ProfileMenuItem(
                          icon: Icons.map,
                          title: 'Itinerary',
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const ItineraryScreen()));
                          },
                        ),
                        const Divider(height: 1),
                        ProfileMenuItem(
                          icon: Icons.camera_alt,
                          title: 'Rekomendasi Gaya Foto',
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const RekomendasiGayaFotoScreen()));
                          },
                        ),
                        const Divider(height: 1),
                        ProfileMenuItem(
                          icon: Icons.help_outline,
                          title: 'Bantuan',
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const LayananBantuanScreen()));
                          },
                        ),
                        const Divider(height: 1),
                        ProfileMenuItem(
                          icon: Icons.settings,
                          title: 'Pengaturan',
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _confirmLogout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Logout', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// Widget untuk Info Item
class ProfileInfoItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const ProfileInfoItem({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue[700], size: 24),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Widget untuk Menu Item di Profile
class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue[700]),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}

// Halaman Edit Profil
class EditProfileScreen extends StatefulWidget {
  final String nama;
  final String email;
  final String noHp;
  final String alamat;
  final Function(String, String, String, String) onSave;

  const EditProfileScreen({
    super.key,
    required this.nama,
    required this.email,
    required this.noHp,
    required this.alamat,
    required this.onSave,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController namaController;
  late TextEditingController emailController;
  late TextEditingController noHpController;
  late TextEditingController alamatController;

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.nama);
    emailController = TextEditingController(text: widget.email);
    noHpController = TextEditingController(text: widget.noHp);
    alamatController = TextEditingController(text: widget.alamat);
  }

  @override
  void dispose() {
    namaController.dispose();
    emailController.dispose();
    noHpController.dispose();
    alamatController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    widget.onSave(
      namaController.text,
      emailController.text,
      noHpController.text,
      alamatController.text,
    );
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil berhasil diperbarui')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Edit Profil'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.blue[100],
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.blue[700],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.blue[700],
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                        onPressed: () {
                          // Fungsi ganti foto (placeholder)
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Fitur ganti foto akan segera hadir')),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Form Fields
            TextField(
              controller: namaController,
              decoration: InputDecoration(
                labelText: 'Nama Lengkap',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: noHpController,
              decoration: InputDecoration(
                labelText: 'Nomor HP',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: alamatController,
              decoration: InputDecoration(
                labelText: 'Alamat',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.location_on),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 30),

            // Tombol Simpan
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Simpan Perubahan', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
