# GoTour - Integrasi API Flutter

Integrasi API lengkap untuk aplikasi Flutter GoTour dengan semua fitur CRUD, authentication, dan file upload.

## 🚀 Quick Start

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Rename File (Pilih salah satu)

**PowerShell:**
```powershell
.\rename_files.ps1
```

**Command Prompt:**
```cmd
rename_files.bat
```

**Manual (PowerShell):**
```powershell
cd lib
Rename-Item detail_paket.dart detail_paket_old.dart
Rename-Item detail_paket_new.dart detail_paket.dart

Rename-Item blog_wisata.dart blog_wisata_old.dart
Rename-Item blog_wisata_new.dart blog_wisata.dart

Rename-Item login.dart login_old.dart
Rename-Item login_new.dart login.dart

Rename-Item register.dart register_old.dart
Rename-Item register_new.dart register.dart

Rename-Item profile.dart profile_old.dart
Rename-Item profile_new.dart profile.dart

Rename-Item home.dart home_old.dart
Rename-Item home_updated.dart home.dart
```

### 3. Update Base URL
Edit [lib/services/api_service.dart](lib/services/api_service.dart#L7):

```dart
// Android Emulator
static const String baseUrl = 'http://10.0.2.2:8000/api';

// iOS Simulator
static const String baseUrl = 'http://127.0.0.1:8000/api';

// Physical Device (ganti dengan IP komputer Anda)
static const String baseUrl = 'http://192.168.x.x:8000/api';
```

### 4. Run App
```bash
flutter run
```

## 📚 Dokumentasi Lengkap

Baca [INTEGRASI_API_GUIDE.md](INTEGRASI_API_GUIDE.md) untuk:
- Daftar semua endpoints
- Cara kerja setiap fitur
- Error handling
- Troubleshooting
- Customization

## 📁 File Structure

```
lib/
├── services/
│   └── api_service.dart          ✅ NEW - API Service
├── paket_wisata.dart             ✅ UPDATED - API Integration
├── detail_paket.dart             ✅ UPDATED - Booking Flow
├── blog_wisata.dart              ✅ UPDATED - API + Search
├── login.dart                    ✅ UPDATED - API Login
├── register.dart                 ✅ UPDATED - API Register
├── profile.dart                  ✅ UPDATED - Photo Upload
├── home.dart                     ✅ UPDATED - API Sections
├── riwayat_booking.dart          ✅ NEW - Payment History
├── services_screen.dart          ✅ NEW - Services & Discounts
└── testimonial_screen.dart       ✅ NEW - Testimonials
```

## ✨ Fitur Utama

- ✅ Authentication (Login/Register)
- ✅ Paket Wisata CRUD
- ✅ Booking & Payment Management
- ✅ Blog dengan Search
- ✅ Services & Discounts
- ✅ Testimonials dengan Rating
- ✅ Profile dengan Photo Upload
- ✅ Error Handling & Loading States
- ✅ Format Rupiah & Tanggal Indonesia

## 🔑 API Endpoints

| Method | Endpoint | Auth | Deskripsi |
|--------|----------|------|-----------|
| POST | /api/login | ❌ | Login user |
| POST | /api/register | ❌ | Register user |
| GET | /api/user | ✅ | Get user profile |
| GET | /api/packages | ❌ | List paket wisata |
| GET | /api/packages/{id} | ❌ | Detail paket |
| POST | /api/packages | ✅ | Create paket (admin) |
| GET | /api/payments | ✅ | List pembayaran |
| POST | /api/payments | ✅ | Create booking |
| POST | /api/payments/{id}/pay | ✅ | Bayar pembayaran |
| DELETE | /api/payments/{id} | ✅ | Cancel pembayaran |
| GET | /api/blogs | ❌ | List blog |
| GET | /api/blog-posts/{id} | ❌ | Detail blog |
| GET | /api/services | ❌ | List layanan |
| GET | /api/discounts | ❌ | List diskon |
| GET | /api/testimonials | ❌ | List testimoni |
| POST | /api/profile/photo | ✅ | Upload foto profile |

## 🛠️ Dependencies

```yaml
dependencies:
  http: ^1.1.0
  shared_preferences: ^2.2.2
  image_picker: ^1.0.7
  flutter_rating_bar: ^4.0.1
  intl: ^0.18.1
```

## ⚙️ Configuration

### Android Permissions
Tambahkan di `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
```

### iOS Permissions
Tambahkan di `ios/Runner/Info.plist`:
```xml
<key>NSCameraUsageDescription</key>
<string>Aplikasi membutuhkan akses kamera untuk foto profil</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Aplikasi membutuhkan akses galeri untuk foto profil</string>
```

## 🐛 Troubleshooting

### Connection Refused
- Pastikan backend Laravel running di `http://localhost:8000`
- Cek base URL sesuai platform (emulator/simulator/device)

### Image Not Loading
- Pastikan permission INTERNET sudah ditambahkan
- Cek URL image valid

### Auth Error
- Pastikan token tersimpan dengan benar
- Login ulang jika token expired

## 📞 Support

Jika ada masalah, cek:
1. Console error message
2. API response di network inspector
3. [INTEGRASI_API_GUIDE.md](INTEGRASI_API_GUIDE.md) untuk detail lengkap

---

**Created with ❤️ for GoTour**
