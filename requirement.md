# Requirements

## Flutter & Dart SDK

| Tool       | Version |
| ---------- | ------- |
| Flutter    | 3.41.9  |
| Dart SDK   | ^3.7.0  |
| Dart Tools | 3.11.5  |
| DevTools   | 2.54.2  |

---

## Dependencies (pubspec.yaml)

### Core

| Package           | Version | Keterangan              |
| ----------------- | ------- | ----------------------- |
| `flutter`         | SDK     | Framework utama Flutter |
| `cupertino_icons` | ^1.0.8  | Icon gaya iOS           |

### UI & Fonts

| Package          | Version | Keterangan                             |
| ---------------- | ------- | -------------------------------------- |
| `google_fonts`   | ^6.2.1  | Google Fonts                           |
| `flutter_svg`    | ^2.0.5  | Render file SVG                        |
| `auto_size_text` | ^3.0.0  | Text yang menyesuaikan ukuran otomatis |
| `badges`         | ^3.1.2  | Badge/notifikasi pada widget           |

### Firebase

| Package           | Version | Keterangan            |
| ----------------- | ------- | --------------------- |
| `firebase_core`   | ^4.9.0  | Inisialisasi Firebase |
| `firebase_auth`   | ^6.5.1  | Autentikasi Firebase  |
| `cloud_firestore` | ^6.4.1  | Database Firestore    |
| `google_sign_in`  | ^7.2.0  | Login dengan Google   |

### State Management & Storage

| Package              | Version | Keterangan             |
| -------------------- | ------- | ---------------------- |
| `provider`           | ^6.1.2  | State management       |
| `shared_preferences` | ^2.5.2  | Penyimpanan data lokal |

### Bluetooth & Printing

| Package              | Version | Keterangan                         |
| -------------------- | ------- | ---------------------------------- |
| `permission_handler` | ^12.0.1 | Manajemen izin (permission) device |

### Utility

| Package                   | Version | Keterangan                          |
| ------------------------- | ------- | ----------------------------------- |
| `intl`                    | ^0.20.2 | Internasionalisasi & format tanggal |
| `change_app_package_name` | ^1.1.0  | Ubah package name aplikasi          |

---

## Dev Dependencies

| Package                  | Version | Keterangan                      |
| ------------------------ | ------- | ------------------------------- |
| `flutter_test`           | SDK     | Framework testing Flutter       |
| `flutter_lints`          | ^5.0.0  | Lint rules Flutter              |
| `flutter_launcher_icons` | ^0.14.3 | Generate ikon launcher aplikasi |

---

## Android Requirements

| Requirement     | Value                               |
| --------------- | ----------------------------------- |
| Min SDK Android | 21                                  |
| google-services | Configured (`google-services.json`) |

---

## Assets

```
assets/
├── images/
├── icons/
│   └── animated/
└── logo/
    └── app_logo.png    (Launcher icon)
```
