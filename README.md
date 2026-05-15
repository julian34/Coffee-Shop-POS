# Coffee Shop POS

Coffee Shop POS adalah aplikasi Point of Sale berbasis Flutter untuk membantu operasional kedai kopi. Aplikasi ini mendukung alur kasir, pengelolaan keranjang, transaksi pesanan, pembayaran, autentikasi pengguna, dan pemantauan transaksi dengan integrasi Firebase.

## Daftar Isi

- [Fitur Utama](#fitur-utama)
- [Teknologi](#teknologi)
- [Struktur Proyek](#struktur-proyek)
- [Prasyarat](#prasyarat)
- [Instalasi dan Menjalankan Aplikasi](#instalasi-dan-menjalankan-aplikasi)
- [Konfigurasi Firebase](#konfigurasi-firebase)
- [Aset](#aset)
- [Perintah Pengembangan](#perintah-pengembangan)
- [Catatan Pengembangan](#catatan-pengembangan)

## Fitur Utama

- **Autentikasi pengguna**: login email/password dan Google Sign-In melalui Firebase Authentication.
- **Role-based home screen**: rute awal diarahkan berdasarkan role tersimpan (`Owner`, `Manager`, atau `Cashier`).
- **Manajemen produk**: membaca daftar produk dari Cloud Firestore, dengan pencarian dan filter kategori.
- **Keranjang belanja**: mengelola item pesanan sebelum checkout.
- **Transaksi pesanan**: menampilkan daftar order, detail order, dan status pembayaran.
- **Pembayaran**: menyimpan data pembayaran ke Firestore dan memperbarui status order menjadi paid.
- **Receipt printing support**: dependensi thermal printer sudah tersedia untuk kebutuhan cetak struk.
- **UI responsif Flutter**: menggunakan Material UI, Google Fonts, SVG icons, dan aset gambar lokal.

## Teknologi

- [Flutter](https://flutter.dev/) dengan Dart SDK `^3.7.0`
- Firebase Core, Firebase Auth, dan Cloud Firestore
- Provider untuk state management
- Shared Preferences untuk penyimpanan data lokal sederhana
- Google Fonts dan Flutter SVG untuk kebutuhan tampilan
- Print Bluetooth Thermal dan ESC/POS utilities untuk dukungan printer thermal

## Struktur Proyek

```text
lib/
├── core/                 # Konstanta, tema, dan konfigurasi route
├── models/               # Model data aplikasi
├── providers/            # State management menggunakan Provider
├── screens/              # Halaman aplikasi
│   ├── auth/             # Login
│   ├── cart/             # Keranjang dan ringkasan order
│   ├── home/             # Dashboard Owner, Manager, dan Cashier
│   ├── setting/          # Profil pengguna
│   └── transaction/      # Order, pembayaran, dan sukses transaksi
├── services/             # Integrasi Firebase dan logika bisnis
├── untils/               # Helper formatting
├── widgets/              # Widget reusable
├── firebase_options.dart # Konfigurasi Firebase hasil FlutterFire CLI
└── main.dart             # Entry point aplikasi

assets/
├── icons/                # Ikon SVG dan GIF animasi
├── images/               # Gambar UI umum
└── products/             # Gambar produk
```

## Prasyarat

Pastikan perangkat pengembangan sudah memiliki:

1. Flutter SDK sesuai versi proyek.
2. Dart SDK yang kompatibel dengan Flutter.
3. Android Studio, Xcode, atau toolchain platform target yang ingin dijalankan.
4. Firebase project yang sudah dikonfigurasi untuk platform target.
5. FlutterFire CLI jika perlu membuat ulang `lib/firebase_options.dart`.

Cek instalasi Flutter dengan:

```bash
flutter doctor
```

## Instalasi dan Menjalankan Aplikasi

1. Clone repository:

   ```bash
   git clone <repository-url>
   cd Coffee-Shop-POS
   ```

2. Ambil dependensi Flutter:

   ```bash
   flutter pub get
   ```

3. Pastikan konfigurasi Firebase sudah tersedia. Jika belum, lihat bagian [Konfigurasi Firebase](#konfigurasi-firebase).

4. Jalankan aplikasi pada device atau emulator:

   ```bash
   flutter run
   ```

5. Untuk menjalankan pada platform tertentu:

   ```bash
   flutter run -d chrome
   flutter run -d android
   flutter run -d ios
   ```

## Konfigurasi Firebase

Aplikasi menggunakan Firebase untuk autentikasi dan penyimpanan data. File `lib/firebase_options.dart` sudah digunakan oleh `main.dart` saat inisialisasi Firebase.

Jika perlu menghubungkan ulang proyek ke Firebase:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

Pastikan layanan berikut aktif di Firebase Console:

- Authentication untuk login email/password dan Google.
- Cloud Firestore untuk koleksi `users`, `products`, `orders`, dan `payments`.

Contoh koleksi Firestore yang digunakan aplikasi:

| Koleksi | Kegunaan |
| --- | --- |
| `users` | Data pengguna, role, status aktif, dan approval. |
| `products` | Daftar produk yang ditampilkan di halaman kasir. |
| `orders` | Data pesanan dan status pembayaran. |
| `payments` | Riwayat pembayaran transaksi. |

## Aset

Aset yang didaftarkan di `pubspec.yaml` meliputi:

- `assets/`
- `assets/images/`
- `assets/icons/`
- `assets/icons/animated/`

Jika menambahkan aset baru, pastikan path aset tersebut sudah tercantum di `pubspec.yaml`, lalu jalankan:

```bash
flutter pub get
```

## Perintah Pengembangan

Gunakan perintah berikut saat mengembangkan aplikasi:

```bash
flutter pub get      # Mengambil dependensi
flutter analyze      # Mengecek warning dan error statis
flutter test         # Menjalankan unit/widget test
flutter run          # Menjalankan aplikasi
flutter build apk    # Membuat build Android APK
```

## Catatan Pengembangan

- Rute aplikasi dikelola di `lib/core/routes.dart`.
- Provider utama didaftarkan pada `MultiProvider` di `lib/main.dart`.
- Produk, order, pembayaran, dan autentikasi dipisahkan ke masing-masing service di folder `lib/services/`.
- Sebelum membuka pull request, jalankan minimal `flutter analyze` dan `flutter test` untuk memastikan perubahan tidak merusak aplikasi.
