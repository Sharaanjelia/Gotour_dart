# Script PowerShell untuk Rename File GoTour
# Jalankan di PowerShell: .\rename_files.ps1

Write-Host "=== GoTour File Rename Script ===" -ForegroundColor Green
Write-Host ""

# Fungsi untuk backup dan rename
function Backup-And-Rename {
    param (
        [string]$oldFile,
        [string]$newFile
    )
    
    if (Test-Path $oldFile) {
        $backupFile = $oldFile -replace '\.dart$', '_old.dart'
        
        # Backup file lama
        if (Test-Path $backupFile) {
            Write-Host "Backup sudah ada: $backupFile" -ForegroundColor Yellow
        } else {
            Copy-Item $oldFile $backupFile
            Write-Host "[BACKUP] $oldFile -> $backupFile" -ForegroundColor Cyan
        }
        
        # Hapus file lama
        Remove-Item $oldFile
        Write-Host "[DELETE] $oldFile" -ForegroundColor Red
    }
    
    if (Test-Path $newFile) {
        # Rename file baru ke nama asli
        Rename-Item $newFile $oldFile
        Write-Host "[RENAME] $newFile -> $oldFile" -ForegroundColor Green
    } else {
        Write-Host "[ERROR] File tidak ditemukan: $newFile" -ForegroundColor Red
    }
    
    Write-Host ""
}

# Pindah ke directory lib
Set-Location "lib"

Write-Host "Memulai proses rename file..." -ForegroundColor Yellow
Write-Host ""

# 1. Detail Paket
Write-Host "1. Processing detail_paket.dart..." -ForegroundColor White
Backup-And-Rename "detail_paket.dart" "detail_paket_new.dart"

# 2. Blog Wisata
Write-Host "2. Processing blog_wisata.dart..." -ForegroundColor White
Backup-And-Rename "blog_wisata.dart" "blog_wisata_new.dart"

# 3. Login
Write-Host "3. Processing login.dart..." -ForegroundColor White
Backup-And-Rename "login.dart" "login_new.dart"

# 4. Register
Write-Host "4. Processing register.dart..." -ForegroundColor White
Backup-And-Rename "register.dart" "register_new.dart"

# 5. Profile
Write-Host "5. Processing profile.dart..." -ForegroundColor White
Backup-And-Rename "profile.dart" "profile_new.dart"

# 6. Home
Write-Host "6. Processing home.dart..." -ForegroundColor White
Backup-And-Rename "home.dart" "home_updated.dart"

# Kembali ke root directory
Set-Location ".."

Write-Host ""
Write-Host "=== Proses Selesai ===" -ForegroundColor Green
Write-Host ""
Write-Host "File backup disimpan dengan suffix '_old.dart'" -ForegroundColor Cyan
Write-Host "Jalankan: flutter pub get" -ForegroundColor Yellow
Write-Host "Kemudian: flutter run" -ForegroundColor Yellow
Write-Host ""

# Tampilkan daftar file yang di-backup
Write-Host "File yang di-backup:" -ForegroundColor Cyan
Get-ChildItem -Path "lib" -Filter "*_old.dart" | ForEach-Object {
    Write-Host "  - $_" -ForegroundColor Gray
}

Write-Host ""
Write-Host "SELESAI! Silakan jalankan aplikasi." -ForegroundColor Green
