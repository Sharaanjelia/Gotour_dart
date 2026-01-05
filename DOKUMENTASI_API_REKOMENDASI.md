# 📸 API Rekomendasi Gaya Foto - Dokumentasi Lengkap

## 🎯 Overview

Fitur ini menampilkan rekomendasi gaya foto dari backend Laravel untuk membantu user mendapatkan inspirasi fotografi saat berwisata. Data dikelola oleh admin web dan mobile app hanya melakukan HTTP GET.

---

## 🗄️ Struktur Database Laravel

### Tabel: `recommendations`

```sql
CREATE TABLE recommendations (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nama VARCHAR(255) NOT NULL,
    kategori VARCHAR(100) NOT NULL,
    gambar VARCHAR(255) NULL,
    deskripsi TEXT NOT NULL,
    tips JSON NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL
);
```

### Penjelasan Field:

| Field | Type | Keterangan |
|-------|------|------------|
| `id` | BIGINT | ID unik (auto increment) |
| `nama` | VARCHAR(255) | Nama gaya foto, contoh: "Gaya Foto Santai" |
| `kategori` | VARCHAR(100) | Kategori pose, contoh: "Pose Duduk", "Pose Berdiri" |
| `gambar` | VARCHAR(255) | Path gambar relative, contoh: "recommendations/foto1.jpg" |
| `deskripsi` | TEXT | Deskripsi detail tentang gaya foto |
| `tips` | JSON | Array string berisi tips & tricks |
| `is_active` | BOOLEAN | Status aktif/nonaktif (untuk filter) |
| `created_at` | TIMESTAMP | Waktu dibuat |
| `updated_at` | TIMESTAMP | Waktu diupdate |

### Contoh Data:

```sql
INSERT INTO recommendations (nama, kategori, gambar, deskripsi, tips, is_active) VALUES
(
    'Pose Santai Duduk',
    'Pose Duduk',
    'recommendations/pose_duduk_1.jpg',
    'Pose duduk santai dengan ekspresi natural, cocok untuk foto outdoor maupun indoor.',
    '["Duduk dengan posisi yang nyaman dan rileks", "Tangan bisa diletakkan di paha atau lutut", "Tatapan ke arah kamera atau ke samping", "Background yang simpel lebih baik"]',
    TRUE
),
(
    'Menikmati Alam',
    'Pose Outdoor',
    'recommendations/pose_alam_1.jpg',
    'Gaya foto dengan nuansa menikmati keindahan alam, sempurna untuk destinasi wisata alam.',
    '["Berdiri atau duduk menghadap pemandangan", "Tangan bisa menyentuh rambut atau diangkat", "Ekspresi rileks dan menikmati suasana", "Manfaatkan cahaya natural dari matahari"]',
    TRUE
),
(
    'Candid Playful',
    'Pose Candid',
    'recommendations/pose_candid_1.jpg',
    'Pose candid yang playful dan penuh energi, cocok untuk foto yang fun.',
    '["Gerakan yang spontan dan playful", "Tertawa atau ekspresi senang", "Loncat, lari, atau gerakan dinamis", "Shutter speed tinggi untuk freeze motion"]',
    TRUE
);
```

---

## 🔌 API Endpoint

### GET /api/recommendations

**Deskripsi:** Mengambil semua rekomendasi gaya foto yang aktif

**Method:** `GET`

**Authentication:** Optional (bisa public atau dengan Bearer token)

**Headers:**
```http
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}  # Optional
```

**Response Success (200 OK):**

```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "nama": "Pose Santai Duduk",
      "kategori": "Pose Duduk",
      "gambar": "recommendations/pose_duduk_1.jpg",
      "image_url": "http://localhost:8000/storage/recommendations/pose_duduk_1.jpg",
      "deskripsi": "Pose duduk santai dengan ekspresi natural, cocok untuk foto outdoor maupun indoor.",
      "tips": [
        "Duduk dengan posisi yang nyaman dan rileks",
        "Tangan bisa diletakkan di paha atau lutut",
        "Tatapan ke arah kamera atau ke samping",
        "Background yang simpel lebih baik"
      ],
      "is_active": true,
      "created_at": "2026-01-01T10:00:00.000000Z",
      "updated_at": "2026-01-01T10:00:00.000000Z"
    },
    {
      "id": 2,
      "nama": "Menikmati Alam",
      "kategori": "Pose Outdoor",
      "gambar": "recommendations/pose_alam_1.jpg",
      "image_url": "http://localhost:8000/storage/recommendations/pose_alam_1.jpg",
      "deskripsi": "Gaya foto dengan nuansa menikmati keindahan alam.",
      "tips": [
        "Berdiri atau duduk menghadap pemandangan",
        "Tangan bisa menyentuh rambut atau diangkat",
        "Ekspresi rileks dan menikmati suasana",
        "Manfaatkan cahaya natural dari matahari"
      ],
      "is_active": true,
      "created_at": "2026-01-01T11:00:00.000000Z",
      "updated_at": "2026-01-01T11:00:00.000000Z"
    }
  ],
  "message": "Data rekomendasi berhasil diambil"
}
```

**Response Empty (200 OK):**
```json
{
  "success": true,
  "data": [],
  "message": "Belum ada rekomendasi"
}
```

**Response Error (500):**
```json
{
  "success": false,
  "message": "Gagal mengambil data rekomendasi",
  "error": "Database connection failed"
}
```

---

## 💻 Laravel Backend Implementation

### Model: `app/Models/Recommendation.php`

```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Recommendation extends Model
{
    protected $fillable = [
        'nama',
        'kategori',
        'gambar',
        'deskripsi',
        'tips',
        'is_active',
    ];

    protected $casts = [
        'tips' => 'array',
        'is_active' => 'boolean',
    ];

    protected $appends = ['image_url'];

    public function getImageUrlAttribute()
    {
        if (!$this->gambar) {
            return null;
        }
        
        // Jika sudah full URL
        if (str_starts_with($this->gambar, 'http')) {
            return $this->gambar;
        }
        
        // Generate full URL ke storage
        return url('storage/' . $this->gambar);
    }
}
```

### Controller: `app/Http/Controllers/Api/RecommendationController.php`

```php
<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Recommendation;
use Illuminate\Http\Request;

class RecommendationController extends Controller
{
    /**
     * GET /api/recommendations
     * Ambil semua rekomendasi yang aktif
     */
    public function index()
    {
        try {
            $recommendations = Recommendation::where('is_active', true)
                ->orderBy('created_at', 'desc')
                ->get();

            return response()->json([
                'success' => true,
                'data' => $recommendations,
                'message' => 'Data rekomendasi berhasil diambil'
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil data rekomendasi',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * GET /api/recommendations/{id}
     * Ambil detail satu rekomendasi
     */
    public function show($id)
    {
        try {
            $recommendation = Recommendation::findOrFail($id);

            return response()->json([
                'success' => true,
                'data' => $recommendation,
                'message' => 'Detail rekomendasi berhasil diambil'
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Rekomendasi tidak ditemukan',
                'error' => $e->getMessage()
            ], 404);
        }
    }
}
```

### Routes: `routes/api.php`

```php
use App\Http\Controllers\Api\RecommendationController;

// Public endpoint (tidak perlu login)
Route::get('/recommendations', [RecommendationController::class, 'index']);
Route::get('/recommendations/{id}', [RecommendationController::class, 'show']);

// Atau dengan authentication jika diperlukan
Route::middleware('auth:sanctum')->group(function () {
    Route::get('/recommendations', [RecommendationController::class, 'index']);
    Route::get('/recommendations/{id}', [RecommendationController::class, 'show']);
});
```

---

## 📱 Flutter Implementation

### 1. Model: `lib/models/recommendation_model.dart`

Model sudah dibuat dengan fitur:
- ✅ `fromJson()` untuk parsing response API
- ✅ `toJson()` untuk POST/PUT (jika diperlukan)
- ✅ Handling tips sebagai List atau JSON string
- ✅ Helper method `getImageUrl()` untuk URL gambar

### 2. API Service: `lib/services/api_service.dart`

Method `getRecommendations()` sudah ditambahkan:
```dart
Future<List> getRecommendations() async {
  final response = await http.get(
    Uri.parse('$baseUrl/recommendations'),
    headers: await getHeaders(),
  );
  // ... error handling & parsing
}
```

### 3. UI Screen: `lib/rekomendasi_gaya_foto.dart`

Sudah diimplementasi dengan:
- ✅ **FutureBuilder** untuk async data loading
- ✅ **Loading State** dengan CircularProgressIndicator
- ✅ **Error State** dengan pesan error & tombol retry
- ✅ **Empty State** jika data kosong
- ✅ **Pull to Refresh** untuk reload data
- ✅ **ListView** dengan Card design
- ✅ **Image loading** dengan placeholder & error handling
- ✅ **Detail Dialog** saat item diklik

---

## 🚀 Cara Menggunakan

### Testing dengan Postman:

1. **GET All Recommendations:**
   ```
   GET http://localhost:8000/api/recommendations
   ```

2. **GET Single Recommendation:**
   ```
   GET http://localhost:8000/api/recommendations/1
   ```

### Testing di Flutter:

1. Jalankan backend Laravel: `php artisan serve`
2. Jalankan aplikasi Flutter
3. Navigasi ke menu "Rekomendasi Gaya Foto"
4. Data akan dimuat otomatis dari API

---

## 🛠️ Admin Web Laravel (CRUD)

Backend perlu menyediakan halaman admin untuk CRUD rekomendasi:

### Form Create/Edit:
- Nama Gaya Foto
- Kategori (dropdown atau input)
- Upload Gambar
- Deskripsi (textarea)
- Tips (textarea dengan newline atau dynamic input)
- Status Aktif (checkbox)

### Validasi:
```php
$request->validate([
    'nama' => 'required|string|max:255',
    'kategori' => 'required|string|max:100',
    'gambar' => 'nullable|image|mimes:jpg,png,jpeg|max:2048',
    'deskripsi' => 'required|string',
    'tips' => 'required|array|min:1',
    'tips.*' => 'required|string',
    'is_active' => 'boolean',
]);
```

---

## ✅ Checklist Implementation

### Backend Laravel:
- ✅ Buat migration untuk tabel `recommendations`
- ✅ Buat model `Recommendation`
- ✅ Buat controller `RecommendationController`
- ✅ Tambahkan routes di `api.php`
- ✅ Seed data dummy untuk testing
- ✅ Upload gambar ke `/storage/recommendations/`
- ✅ Buat admin panel untuk CRUD (optional tapi recommended)

### Flutter Mobile:
- ✅ Model `RecommendationModel`
- ✅ API Service method `getRecommendations()`
- ✅ UI dengan FutureBuilder & ListView
- ✅ Loading, Error, Empty states
- ✅ Image loading dengan Network Image
- ✅ Pull to Refresh

---

## 🎨 UI States

### 1. Loading State
```dart
CircularProgressIndicator + Text "Memuat rekomendasi..."
```

### 2. Error State
```dart
Icon Error + Pesan error + Tombol "Coba Lagi"
```

### 3. Empty State
```dart
Icon Camera + Text "Belum ada rekomendasi"
```

### 4. Success State
```dart
ListView dengan Card untuk setiap rekomendasi
```

---

## 📊 Data Flow

```
Admin Web (Laravel)
    ↓ CRUD
Database (MySQL/PostgreSQL)
    ↓ API GET
Laravel Backend (JSON Response)
    ↓ HTTP GET
Flutter App (Parse JSON → Model)
    ↓ FutureBuilder
UI ListView (Display Cards)
```

---

## 🔒 Security Notes

1. **Validasi Input:** Pastikan semua input dari admin divalidasi
2. **Image Upload:** Validasi tipe file & ukuran
3. **XSS Prevention:** Sanitize HTML jika ada
4. **CORS:** Enable CORS jika mobile app dan backend beda domain
5. **Rate Limiting:** Batasi jumlah request per IP

---

## 📝 Assessment Fokus

✅ **HTTP GET** → Data dari backend Laravel  
✅ **JSON Parsing** → Model Dart dengan `fromJson()`  
✅ **ListView** → Menampilkan data dalam list  
✅ **FutureBuilder** → Async loading  
✅ **Loading State** → UX saat loading  
✅ **Error Handling** → Tampilkan error dengan jelas  
✅ **Pull to Refresh** → Reload data  
✅ **Network Image** → Load gambar dari server  

❌ **Tidak ada** admin panel di Flutter  
❌ **Tidak ada** CRUD dari mobile  
❌ **Tidak ada** POST/PUT/DELETE  

> **Mobile hanya melakukan HTTP GET dan menampilkan data!** 📱

---

## 🎯 Kesimpulan

Fitur Rekomendasi Gaya Foto ini sudah lengkap dengan:
- Struktur database yang jelas
- API endpoint yang terstandarisasi
- Model Dart yang robust
- UI dengan proper state management
- Error handling yang baik
- Image loading dari network

Data dikelola oleh admin web Laravel, dan mobile app hanya menampilkan data tersebut. Sesuai dengan konsep Assessment 3! 🚀
