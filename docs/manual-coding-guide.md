# Manual Coding Guide

Dokumen ini dipakai sebagai panduan coding manual untuk dua hal:

1. koneksi ke Firebase
2. perbaikan bug yang harus dilakukan

Fokusnya adalah langkah yang bisa langsung dieksekusi di repo ini, bukan otomatisasi atau refactor besar.

## 1. Koneksi ke Firebase

### Kondisi yang sudah ada

- `lib/main.dart` sudah memanggil `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)` sebelum `runApp`.
- `lib/firebase_options.dart` sudah tersedia untuk Android, iOS, macOS, web, dan Windows.
- Android sudah terhubung lewat `android/settings.gradle.kts`, `android/app/build.gradle.kts`, dan `android/app/google-services.json`.
- Dependency Firebase yang dibutuhkan juga sudah ada di `pubspec.yaml`, terutama `firebase_core`, `firebase_auth`, dan `cloud_firestore`.

### Langkah manual yang perlu dilakukan

1. Pastikan project Firebase yang dipakai sesuai dengan aplikasi ini.
2. Cocokkan package name Android dan bundle ID iOS dengan project Firebase yang benar.
3. Jika ada perubahan project Firebase, regenerate `lib/firebase_options.dart` supaya konfigurasi tetap sinkron.
4. Pastikan file konfigurasi native terpasang di platform yang dipakai.
5. Jalankan build ulang setelah konfigurasi selesai.

### Android

- Simpan `google-services.json` di `android/app`.
- Pastikan Google Services plugin tetap aktif di Gradle.
- Cocokkan package name Android dengan project Firebase.
- Setelah itu jalankan ulang build Android.

### iOS

- Tambahkan `GoogleService-Info.plist` ke folder `ios/Runner`.
- Pastikan bundle ID iOS cocok dengan project Firebase.
- Jika diperlukan, cek `AppDelegate.swift` dan pastikan konfigurasi native Firebase lengkap.
- Jalankan `pod install` lalu build ulang iOS.

### Batasan platform

- Konfigurasi `lib/firebase_options.dart` tidak menyiapkan Linux.
- Jika target build Linux diperlukan, Firebase perlu disesuaikan atau dibatasi ke platform yang didukung.

### Urutan kerja yang disarankan

1. Sinkronkan project Firebase dan app ID.
2. Pasang file konfigurasi native untuk Android dan iOS.
3. Regenerate `firebase_options.dart`.
4. Build ulang satu platform dulu, lalu lanjut platform lain.
5. Cek error inisialisasi Firebase sebelum masuk ke fitur auth dan Firestore.

## 2. Perbaikan bug yang harus dilakukan

### Prioritas tinggi

#### 1. Mismatch field pada `Payment.fromMap`

- File: `lib/models/payment_model.dart`
- Masalah: `fromMap` membaca key yang tidak sama dengan `toMap`.
- Dampak: data pembayaran yang di-load dari Firestore bisa kosong atau salah.
- Perbaikan: samakan key `orderId`, `totalAmount`, `receivedAmount`, `changeAmount`, `paymentMethod`, dan `createdAt` antara `fromMap` dan `toMap`.

#### 2. Navigasi dobel saat keluar dari cart

- File: `lib/screens/cart/cart_screen.dart`
- Masalah: alur keluar memicu navigasi lebih dari sekali.
- Dampak: halaman order bisa muncul dobel atau stack navigasi jadi tidak konsisten.
- Perbaikan: pilih satu mekanisme navigasi saja pada flow exit.

#### 3. Payment diproses tanpa menunggu hasil save

- File: `lib/screens/transaction/payment_screen.dart`
- Masalah: `makePayment` dipanggil tanpa menunggu hasilnya sebelum pindah ke success screen.
- Dampak: UI bisa menampilkan sukses padahal penyimpanan transaksi belum selesai atau gagal.
- Perbaikan: `await` proses pembayaran, lalu navigasi hanya jika penyimpanan berhasil.

### Prioritas menengah

#### 4. Fetch berulang dari dalam build

- File: `lib/screens/transaction/success_screen.dart`
- Masalah: `fetchCustomerName` dipicu lewat `addPostFrameCallback` di area yang berpotensi terpanggil ulang.
- Dampak: request dan update state bisa berulang tanpa perlu.
- Perbaikan: pindahkan inisialisasi ke `initState` atau guard agar hanya jalan sekali.

#### 5. Force unwrap user di provider

- File: `lib/providers/auth_provider.dart`
- Masalah: `_user!` dipakai setelah load auth state tanpa memastikan datanya ada.
- Dampak: aplikasi bisa crash kalau Firebase Auth ada, tetapi data user Firestore tidak ditemukan.
- Perbaikan: cek null sebelum menyimpan ke prefs atau menandai user authenticated.

#### 6. Provider logout yang lepas dari tree

- File: `lib/screens/home/widgets/cashier/cashier_app_bar.dart`
- Masalah: aksi menu membuat instance `AuthProvider` baru, bukan memakai provider aktif.
- Dampak: listener auth dan state logout bisa tidak sinkron.
- Perbaikan: ambil provider dari context yang sedang aktif.

### Backlog tambahan

- `lib/services/auth_service.dart`: `signInWithPopup` adalah flow web-only, jadi perlu diganti jika target utama Android/iOS.
- `lib/models/appbarselected.dart` dan `lib/screens/home/models/cashier/appbarselected.dart`: ada duplikasi model yang sebaiknya dirapikan.
- `lib/untils/format_utils.dart` dan `lib/core/app_constans.dart`: nama folder/file typo, sebaiknya dibenahi agar konsisten.

## Catatan implementasi

- Prioritaskan bug yang berpotensi crash atau mengganggu transaksi.
- Setelah perbaikan, jalankan analisis dan build per platform yang memang dipakai.
- Jika Firebase sudah stabil, lanjutkan ke validasi auth, pembayaran, dan penyimpanan transaksi.
