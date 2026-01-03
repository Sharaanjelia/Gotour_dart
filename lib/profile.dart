import 'package:flutter/material.dart';
import 'login.dart';
import 'layanan_bantuan.dart';
import 'favorite.dart';
import 'e_tiket.dart';
import 'promo_list.dart' as promo;
import 'blog_wisata.dart';
import 'itinerary.dart';
import 'rekomendasi_gaya_foto.dart';
import 'riwayat_booking.dart';
import 'settings.dart';

// Halaman Profile

import 'api_laravel_profile.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

// Fungsi untuk fetch data admin dari API
Future<List<dynamic>> fetchAdminUser() async {
  final response = await http.get(Uri.parse('http://yourdomain.com/api/Admin_User'));
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    // Jika response berupa objek dengan key 'data', ambil array dari 'data'
    if (data is Map<String, dynamic> && data.containsKey('data')) {
      return data['data'];
    }
    // Jika response langsung berupa array
    if (data is List) {
      return data;
    }
    // Jika tidak sesuai, kembalikan list kosong
    return [];
  } else {
    throw Exception('Gagal mengambil data admin');
  }
}

// Contoh penggunaan di widget (letakkan di dalam body atau di bawah tombol logout):
//
// Padding(
//   padding: const EdgeInsets.all(20),
//   child: SizedBox(
//     height: 200,
//     child: FutureBuilder<List<dynamic>>(
//       future: fetchAdminUser(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return Text('Error: \\${snapshot.error}');
//         } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return Text('Tidak ada data admin');
//         } else {
//           return ListView.builder(
//             itemCount: snapshot.data!.length,
//             itemBuilder: (context, index) {
//               final admin = snapshot.data![index];
//               return ListTile(
//                 title: Text(admin['nama'] ?? 'Tanpa Nama'),
//                 subtitle: Text(admin['email'] ?? ''),
//               );
//             },
//           );
//         }
//       },
//     ),
//   ),
// ),

class ProfileScreen extends StatefulWidget {
  final String token;
  const ProfileScreen({super.key, required this.token});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Profil Saya'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.api),
            tooltip: 'Assessment 3',
            onPressed: () {
              Navigator.pushNamed(context, '/api-example');
            },
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: fetchProfile(token: widget.token),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Gagal memuat data profil.'));
          }
          final user = snapshot.data!;
          final nama = user['name'] ?? '-';
          final email = user['email'] ?? '-';
          final noHp = user['no_hp'] ?? '-';
          final alamat = user['alamat'] ?? '-';
          return SingleChildScrollView(
            child: Column(
              children: [
                // Header Profile dengan background gradient
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue[700]!, Colors.blue[400]!],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Avatar dengan border
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.blue[700],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          nama,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          email,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Informasi Pengguna
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Informasi Pribadi',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const Divider(height: 20),
                      ProfileInfoItem(
                        icon: Icons.phone,
                        title: 'Nomor HP',
                        value: noHp,
                      ),
                      const SizedBox(height: 15),
                      ProfileInfoItem(
                        icon: Icons.location_on,
                        title: 'Alamat',
                        value: alamat,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Menu Items
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      ProfileMenuItem(
                        icon: Icons.history,
                        title: 'Riwayat Booking',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RiwayatBookingScreen(token: widget.token),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      ProfileMenuItem(
                        icon: Icons.favorite_border,
                        title: 'Favorit',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FavoriteScreen(),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      ProfileMenuItem(
                        icon: Icons.confirmation_number,
                        title: 'E-Tiket',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ETiketScreen(
                                namaTempat: 'E-Tiket',
                                totalHarga: 0,
                              ),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      ProfileMenuItem(
                        icon: Icons.local_offer,
                        title: 'Promo',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => promo.PromoListScreen(),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      ProfileMenuItem(
                        icon: Icons.article,
                        title: 'Blog Wisata',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const BlogWisataScreen(),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      ProfileMenuItem(
                        icon: Icons.map,
                        title: 'Itinerary',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ItineraryScreen(),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      ProfileMenuItem(
                        icon: Icons.camera_alt,
                        title: 'Rekomendasi Gaya Foto',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RekomendasiGayaFotoScreen(),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      ProfileMenuItem(
                        icon: Icons.help_outline,
                        title: 'Bantuan',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LayananBantuanScreen(),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      ProfileMenuItem(
                        icon: Icons.settings,
                        title: 'Pengaturan',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SettingsScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Tampilkan daftar admin di bawah menu profil
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    height: 200,
                    child: FutureBuilder<List<dynamic>>(
                      future: fetchAdminUser(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text('Error: \\${snapshot.error}');
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Text('Tidak ada data admin');
                        } else {
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final admin = snapshot.data![index];
                              return ListTile(
                                leading: admin['photo'] != null
                                    ? CircleAvatar(
                                        backgroundImage: NetworkImage(admin['photo']),
                                      )
                                    : const CircleAvatar(child: Icon(Icons.person)),
                                title: Text(admin['name'] ?? admin['nama'] ?? 'Tanpa Nama'),
                                subtitle: Text(admin['email'] ?? ''),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Tombol Logout
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // Tampilkan dialog konfirmasi logout
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Konfirmasi Logout'),
                              content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Batal'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const LoginScreen(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  child: const Text('Logout'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
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
