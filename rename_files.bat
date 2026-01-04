@echo off
REM Script Batch untuk Rename File GoTour
REM Jalankan di Command Prompt: rename_files.bat

echo === GoTour File Rename Script ===
echo.

cd lib

echo Memulai proses rename file...
echo.

REM 1. Detail Paket
echo 1. Processing detail_paket.dart...
if exist detail_paket.dart (
    copy detail_paket.dart detail_paket_old.dart
    del detail_paket.dart
    echo [BACKUP] detail_paket.dart -^> detail_paket_old.dart
)
if exist detail_paket_new.dart (
    ren detail_paket_new.dart detail_paket.dart
    echo [RENAME] detail_paket_new.dart -^> detail_paket.dart
)
echo.

REM 2. Blog Wisata
echo 2. Processing blog_wisata.dart...
if exist blog_wisata.dart (
    copy blog_wisata.dart blog_wisata_old.dart
    del blog_wisata.dart
    echo [BACKUP] blog_wisata.dart -^> blog_wisata_old.dart
)
if exist blog_wisata_new.dart (
    ren blog_wisata_new.dart blog_wisata.dart
    echo [RENAME] blog_wisata_new.dart -^> blog_wisata.dart
)
echo.

REM 3. Login
echo 3. Processing login.dart...
if exist login.dart (
    copy login.dart login_old.dart
    del login.dart
    echo [BACKUP] login.dart -^> login_old.dart
)
if exist login_new.dart (
    ren login_new.dart login.dart
    echo [RENAME] login_new.dart -^> login.dart
)
echo.

REM 4. Register
echo 4. Processing register.dart...
if exist register.dart (
    copy register.dart register_old.dart
    del register.dart
    echo [BACKUP] register.dart -^> register_old.dart
)
if exist register_new.dart (
    ren register_new.dart register.dart
    echo [RENAME] register_new.dart -^> register.dart
)
echo.

REM 5. Profile
echo 5. Processing profile.dart...
if exist profile.dart (
    copy profile.dart profile_old.dart
    del profile.dart
    echo [BACKUP] profile.dart -^> profile_old.dart
)
if exist profile_new.dart (
    ren profile_new.dart profile.dart
    echo [RENAME] profile_new.dart -^> profile.dart
)
echo.

REM 6. Home
echo 6. Processing home.dart...
if exist home.dart (
    copy home.dart home_old.dart
    del home.dart
    echo [BACKUP] home.dart -^> home_old.dart
)
if exist home_updated.dart (
    ren home_updated.dart home.dart
    echo [RENAME] home_updated.dart -^> home.dart
)
echo.

cd ..

echo.
echo === Proses Selesai ===
echo.
echo File backup disimpan dengan suffix '_old.dart'
echo Jalankan: flutter pub get
echo Kemudian: flutter run
echo.
echo SELESAI! Silakan jalankan aplikasi.
echo.

pause
