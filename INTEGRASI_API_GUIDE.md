# INTEGRASI API GOTOUR - PANDUAN IMPLEMENTASI

## 📁 FILE YANG DIBUAT/DIUPDATE

### ✅ File Baru yang Dibuat:
1. **lib/services/api_service.dart** - Service utama untuk semua API calls
2. **lib/blog_wisata_new.dart** - Blog dengan API integration + search
3. **lib/detail_paket_new.dart** - Detail paket dengan booking flow
4. **lib/login_new.dart** - Login screen dengan API
5. **lib/register_new.dart** - Register screen dengan API
6. **lib/services_screen.dart** - Layanan & Diskon dengan tabs
7. **lib/testimonial_screen.dart** - Testimonial dengan rating
8. **lib/profile_new.dart** - Profile dengan upload photo
9. **lib/home_updated.dart** - Home dengan sections API

### ✅ File yang Sudah Diupdate:
1. **lib/paket_wisata.dart** - Sudah diupdate dengan FutureBuilder API
2. **lib/riwayat_booking.dart** - Existing file, perlu replace manual jika ingin full API

---

## 🔧 CARA IMPLEMENTASI

### Step 1: Install Dependencies
Dependencies sudah ada di pubspec.yaml, jalankan:
```bash
flutter pub get
```

### Step 2: Replace File Lama dengan File Baru

Karena beberapa file sudah ada, Anda perlu rename/replace manual:

```bash
# Option A: Backup dan replace
mv lib/detail_paket.dart lib/detail_paket_old.dart
mv lib/detail_paket_new.dart lib/detail_paket.dart

mv lib/blog_wisata.dart lib/blog_wisata_old.dart
mv lib/blog_wisata_new.dart lib/blog_wisata.dart

mv lib/login.dart lib/login_old.dart
mv lib/login_new.dart lib/login.dart

mv lib/register.dart lib/register_old.dart
mv lib/register_new.dart lib/register.dart

mv lib/profile.dart lib/profile_old.dart
mv lib/profile_new.dart lib/profile.dart

mv lib/home.dart lib/home_old.dart
mv lib/home_updated.dart lib/home.dart
```

Atau gunakan PowerShell:
```powershell
Rename-Item lib/detail_paket.dart lib/detail_paket_old.dart
Rename-Item lib/detail_paket_new.dart lib/detail_paket.dart

Rename-Item lib/blog_wisata.dart lib/blog_wisata_old.dart
Rename-Item lib/blog_wisata_new.dart lib/blog_wisata.dart

Rename-Item lib/login.dart lib/login_old.dart
Rename-Item lib/login_new.dart lib/login.dart

Rename-Item lib/register.dart lib/register_old.dart
Rename-Item lib/register_new.dart lib/register.dart

Rename-Item lib/profile.dart lib/profile_old.dart
Rename-Item lib/profile_new.dart lib/profile.dart

Rename-Item lib/home.dart lib/home_old.dart
Rename-Item lib/home_updated.dart lib/home.dart
```

### Step 3: Update Imports
Pastikan semua import statement sudah sesuai:

**Di home.dart:**
```dart
import 'services/api_service.dart';
import 'testimonial_screen.dart';
import 'services_screen.dart';
```

**Di login_new.dart, tambahkan:**
```dart
import 'package:shared_preferences/shared_preferences.dart';
```

### Step 4: Setup API Base URL
Jika menggunakan emulator iOS, update base URL di **api_service.dart**:
```dart
// Untuk iOS Simulator
static const String baseUrl = 'http://127.0.0.1:8000/api';

// Untuk Android Emulator (default)
static const String baseUrl = 'http://10.0.2.2:8000/api';

// Untuk device fisik, gunakan IP komputer
static const String baseUrl = 'http://192.168.x.x:8000/api';
```

---

## 📋 STRUKTUR API ENDPOINTS

### Authentication
- `POST /api/login` - Login user
- `POST /api/register` - Register user baru
- `GET /api/user` - Get user profile (dengan auth)

### Packages
- `GET /api/packages` - List semua paket
- `GET /api/packages/{id}` - Detail paket
- `POST /api/packages` - Create paket (admin only)
- `PUT /api/packages/{id}` - Update paket (admin only)
- `DELETE /api/packages/{id}` - Delete paket (admin only)

### Payments
- `GET /api/payments` - List pembayaran user (dengan auth)
- `POST /api/payments` - Create pembayaran baru (dengan auth)
- `POST /api/payments/{id}/pay` - Bayar pembayaran (dengan auth)
- `PUT /api/payments/{id}` - Update pembayaran (dengan auth)
- `DELETE /api/payments/{id}` - Cancel pembayaran (dengan auth)

### Blog
- `GET /api/blogs` - List semua blog
- `GET /api/blog-posts/{id}` - Detail blog

### Services & Discounts
- `GET /api/services` - List layanan
- `GET /api/discounts` - List diskon/promo

### Testimonials
- `GET /api/testimonials` - List testimoni

### Profile
- `POST /api/profile/photo` - Upload foto profile (multipart, dengan auth)

---

## 🎨 FITUR YANG SUDAH DIIMPLEMENTASI

### ✅ Paket Wisata (paket_wisata.dart)
- FutureBuilder untuk fetch packages dari API
- Card dengan NetworkImage
- Format harga Rupiah
- Error handling & loading state
- Empty state
- FAB untuk admin add package
- Navigate ke detail dengan package ID

### ✅ Detail Paket (detail_paket_new.dart)
- Fetch detail dari API
- Foto full width
- Info lengkap paket
- Button "Book Now" dengan AlertDialog konfirmasi
- Create payment API call
- Navigate ke riwayat pembayaran
- Success/error SnackBar

### ✅ Blog Wisata (blog_wisata_new.dart)
- FutureBuilder getBlogs()
- ListView dengan thumbnail
- RefreshIndicator (pull to refresh)
- Search dengan SearchDelegate
- Detail blog screen dengan full content
- Format tanggal Indonesia
- Error & empty state

### ✅ Riwayat Booking (riwayat_booking.dart)
- FutureBuilder getPayments() dengan auth
- Card dengan status color (pending/paid/cancelled)
- Filter dropdown (Semua/Pending/Paid/Cancelled)
- Delete payment dengan konfirmasi
- Button "Bayar Sekarang" untuk pending
- FAB navigate ke paket wisata

### ✅ Login (login_new.dart)
- Form validation
- Password toggle visibility
- Loading state
- Save token ke SharedPreferences
- Navigate ke home setelah login
- Error SnackBar

### ✅ Register (register_new.dart)
- Form dengan validation
- Name (min 3 char)
- Email (format check)
- Password (min 8 char)
- Confirm password (match check)
- Checkbox T&C
- Success dialog
- Navigate back to login

### ✅ Services Screen (services_screen.dart)
- TabController dengan 2 tabs
- Tab Layanan: GridView dengan icons dynamic
- Tab Diskon: ListView dengan gradient cards
- Copy promo code ke clipboard
- Format tanggal expired

### ✅ Testimonial (testimonial_screen.dart)
- Horizontal ListView testimonials
- CircleAvatar user photo
- RatingBarIndicator
- BottomSheet untuk add review
- RatingBar builder
- Submit review (perlu tambah endpoint di API)

### ✅ Profile (profile_new.dart)
- FutureBuilder getUser()
- Header dengan gradient
- CircleAvatar dengan photo
- Upload photo (camera/gallery)
- Image preview sebelum upload
- Menu list (Edit, Riwayat, Favorit, Settings)
- Logout dengan konfirmasi
- Clear SharedPreferences

### ✅ Home Updated (home_updated.dart)
- Greeting dengan nama user dari SharedPreferences
- Section Paket Populer (horizontal ListView, limit 5)
- Section Testimoni (horizontal ListView, limit 3)
- Section Promo Terbaru (horizontal ListView, limit 2)
- "Lihat Semua" navigate ke each screen
- Search bar
- Loading states

---

## 🔒 AUTHENTICATION FLOW

1. **Login** → Save token & user data ke SharedPreferences
2. **API Calls** → getToken() & getHeaders(withAuth: true)
3. **Logout** → Clear SharedPreferences → Navigate to Login

**SharedPreferences Keys:**
- `auth_token` - JWT token
- `user_id` - ID user
- `user_name` - Nama user
- `user_email` - Email user

---

## 🎯 ERROR HANDLING

Semua API calls memiliki:
- Try-catch block
- Throw exception dengan pesan dari API
- CircularProgressIndicator untuk loading
- Error state dengan retry button
- Empty state dengan icon & text
- SnackBar untuk success/error messages

---

## 📱 UI COMPONENTS

### Format Helper Functions:
```dart
// Currency Format
final currencyFormat = NumberFormat.currency(
  locale: 'id_ID',
  symbol: 'Rp ',
  decimalDigits: 0,
);
currencyFormat.format(price)

// Date Format
final dateFormat = DateFormat('dd MMM yyyy');
dateFormat.format(DateTime.parse(dateString))
```

### NetworkImage dengan Error Handler:
```dart
Image.network(
  url,
  errorBuilder: (context, error, stackTrace) {
    return Container(
      color: Colors.grey[300],
      child: const Icon(Icons.broken_image),
    );
  },
)
```

---

## 🚀 NEXT STEPS

1. **Jalankan Backend API** di `http://localhost:8000`
2. **Test Endpoints** dengan Postman/Thunder Client
3. **Run Flutter App**:
   ```bash
   flutter run
   ```
4. **Test Flow**:
   - Register akun baru
   - Login
   - Browse paket wisata
   - Book paket
   - Lihat riwayat pembayaran
   - Bayar pembayaran
   - Upload foto profile
   - Logout

---

## ⚠️ CATATAN PENTING

1. **CORS**: Pastikan backend Laravel sudah enable CORS
2. **Token Expiry**: Implementasikan refresh token jika perlu
3. **Photo Upload**: Backend harus support multipart/form-data
4. **Validation**: Backend harus return proper error messages
5. **Status Codes**: 
   - 200/201 = Success
   - 400 = Bad Request
   - 401 = Unauthorized
   - 404 = Not Found
   - 500 = Server Error

---

## 📝 CUSTOMIZATION

### Ubah Primary Color:
Di `main.dart`, update theme:
```dart
theme: ThemeData(
  primaryColor: Colors.blue[700], // Ubah di sini
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue[700]!,
  ),
),
```

### Tambah Endpoint Baru:
Di `api_service.dart`, tambahkan method baru:
```dart
Future<Map> getNewData() async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/new-endpoint'),
      headers: await getHeaders(withAuth: true),
    );
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'] as Map;
    } else {
      throw Exception('Error message');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}
```

---

## 🐛 TROUBLESHOOTING

### Error: Connection Refused
- Cek backend sudah running
- Cek base URL sudah benar
- Untuk Android emulator, gunakan `10.0.2.2`
- Untuk iOS simulator, gunakan `127.0.0.1`

### Error: Unauthorized
- Cek token tersimpan di SharedPreferences
- Cek header Authorization format: `Bearer {token}`
- Login ulang jika token expired

### Error: Image not loading
- Cek URL image valid
- Cek network permission di AndroidManifest.xml
- Tambahkan: `<uses-permission android:name="android.permission.INTERNET"/>`

### Error: Camera/Gallery not working
- iOS: Tambahkan permission di Info.plist
- Android: Tambahkan permission di AndroidManifest.xml

---

## ✨ FITUR TAMBAHAN (Optional)

Jika ingin menambahkan:
1. **Skeleton Loading** - Gunakan `shimmer` package
2. **Cached Images** - Gunakan `cached_network_image` package
3. **State Management** - Implementasi Provider/Riverpod
4. **Pagination** - Tambahkan page parameter di API
5. **Push Notifications** - Firebase Cloud Messaging
6. **Offline Mode** - SQLite/Hive untuk local storage

---

## 📞 SUPPORT

Jika ada error atau pertanyaan:
1. Cek error message di console
2. Cek response API di network inspector
3. Pastikan semua dependencies sudah terinstall
4. Clean & rebuild project: `flutter clean && flutter pub get`

---

**SELAMAT CODING! 🚀**
