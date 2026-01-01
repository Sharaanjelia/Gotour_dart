# Cara Setup CORS di Laravel untuk Flutter/Web

1. Install package CORS (jika belum):
   ```
   composer require fruitcake/laravel-cors
   ```
2. Publish config (jika belum):
   ```
   php artisan vendor:publish --tag="cors"
   ```
3. Edit file `config/cors.php`:
   - Ubah bagian `allowed_origins` menjadi:
     ```php
     'allowed_origins' => ['*'], // atau ['http://localhost:xxxx']
     ```
   - Atur `supports_credentials` ke `true` jika perlu.
4. Restart server Laravel:
   ```
   php artisan serve
   ```

Setelah itu, request dari Flutter/web ke Laravel tidak akan error CORS lagi.