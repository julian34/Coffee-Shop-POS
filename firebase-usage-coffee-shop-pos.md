# Penjelasan Penggunaan Firebase pada Coffee-Shop-POS

Dokumen ini menjelaskan fungsi masing-masing layanan Firebase yang digunakan atau direkomendasikan pada project **Coffee-Shop-POS** berbasis Flutter. Penjelasan disesuaikan dengan struktur project yang memakai folder `lib/models`, `lib/services`, `lib/providers`, dan `lib/screens`.

Firebase pada project ini berperan sebagai backend aplikasi POS. Fungsi utamanya adalah autentikasi pengguna, penyimpanan data produk, penyimpanan order, pemrosesan pembayaran, serta penyimpanan bukti pembayaran apabila fitur QRIS menggunakan upload gambar.

---

## 1. Ringkasan Layanan Firebase

| Layanan Firebase        | Package Flutter    | Fungsi dalam Project                                   |
| ----------------------- | ------------------ | ------------------------------------------------------ |
| Firebase Core           | `firebase_core`    | Menghubungkan aplikasi Flutter dengan project Firebase |
| Firebase Authentication | `firebase_auth`    | Login, register, logout, dan validasi akun pengguna    |
| Cloud Firestore         | `cloud_firestore`  | Menyimpan data user, produk, cart/order, dan payment   |
| Firebase Storage        | `firebase_storage` | Menyimpan file gambar, misalnya bukti pembayaran QRIS  |

Pada `pubspec.yaml`, project sudah memakai beberapa package Firebase utama:

```yaml
firebase_core: ^4.9.0
firebase_auth: ^6.5.1
cloud_firestore: ^6.4.1
```

Jika ingin menyimpan gambar bukti pembayaran QRIS ke Firebase Storage, tambahkan package berikut:

```bash
flutter pub add firebase_storage
```

---

## 2. Firebase Core

### Fungsi

Firebase Core adalah bagian paling awal yang wajib digunakan sebelum layanan Firebase lain berjalan. Package ini bertugas melakukan inisialisasi koneksi antara aplikasi Flutter dan project Firebase.

Pada project Coffee-Shop-POS, Firebase diinisialisasi di file:

```text
lib/main.dart
```

Contoh kode:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
      ],
      child: MyApp(initialRoute: initialRoute),
    ),
  );
}
```

### Penjelasan

`WidgetsFlutterBinding.ensureInitialized()` digunakan agar Flutter siap menjalankan proses asynchronous sebelum aplikasi dimulai. Setelah itu, `Firebase.initializeApp()` dipanggil agar Firebase aktif pada aplikasi. Parameter `DefaultFirebaseOptions.currentPlatform` mengambil konfigurasi dari file `firebase_options.dart`.

File `firebase_options.dart` biasanya dibuat otomatis oleh FlutterFire CLI melalui perintah:

```bash
flutterfire configure
```

### Realisasi dalam project

Firebase Core tidak menyimpan data secara langsung. Namun, tanpa Firebase Core, layanan lain seperti Authentication dan Firestore tidak dapat digunakan.

---

## 3. Firebase Authentication

### Fungsi

Firebase Authentication digunakan untuk mengelola akun pengguna. Pada aplikasi POS Coffee Shop, fitur ini penting karena sistem memiliki beberapa role, seperti Owner, Manager, dan Cashier.

Pada project ini, Authentication digunakan di file:

```text
lib/services/auth_service.dart
```

### Fungsi utama dalam `AuthService`

| Method               | Fungsi                               |
| -------------------- | ------------------------------------ |
| `signInWithEmail()`  | Login menggunakan email dan password |
| `signInWithGoogle()` | Login menggunakan akun Google        |
| `registerUser()`     | Membuat akun baru                    |
| `getUserData()`      | Mengambil data user dari Firestore   |
| `updateUserStatus()` | Mengaktifkan atau menonaktifkan akun |
| `signOut()`          | Keluar dari akun                     |

---

### a. Login Email dan Password

Contoh fungsi:

```dart
Future signInWithEmail(String email, String password) async {
  UserCredential result = await _auth.signInWithEmailAndPassword(
    email: email,
    password: password,
  );

  User? firebaseUser = result.user;

  if (firebaseUser != null) {
    UserModel? user = await getUserData(firebaseUser.uid);

    if (user != null) {
      if (!user.approved) {
        await _auth.signOut();
        throw Exception("Access denied. Awaiting Manager/Owner approval.");
      } else if (!user.active) {
        await _auth.signOut();
        throw Exception("Your account has been disabled. Contact support.");
      }

      return user;
    }
  }

  return null;
}
```

### Penjelasan

Fungsi ini melakukan login dengan email dan password. Setelah Firebase Authentication berhasil memverifikasi akun, sistem mengambil data tambahan user dari collection `users` di Firestore.

Validasi tambahan dilakukan melalui field:

```text
approved
active
role
```

Jika `approved` bernilai `false`, akun belum disetujui oleh Manager atau Owner. Jika `active` bernilai `false`, akun dinonaktifkan dan tidak boleh masuk ke sistem.

---

### b. Register User

Contoh fungsi:

```dart
Future registerUser(UserModel user, String password) async {
  UserCredential result = await _auth.createUserWithEmailAndPassword(
    email: user.email,
    password: password,
  );

  User? firebaseUser = result.user;

  if (firebaseUser != null) {
    await _db.collection("users").doc(firebaseUser.uid).set(user.toMap());
  }
}
```

### Penjelasan

Fungsi ini membuat akun baru di Firebase Authentication. Setelah akun berhasil dibuat, data profil user disimpan ke collection `users` pada Firestore.

Struktur data user yang disimpan dapat berbentuk seperti berikut:

```json
{
  "uid": "firebase_uid",
  "name": "Nama User",
  "email": "user@gmail.com",
  "role": "Cashier",
  "approved": false,
  "active": true
}
```

Pada aplikasi POS, user baru sebaiknya belum langsung aktif penuh. Manager atau Owner perlu melakukan approval terlebih dahulu.

---

### c. Login Google

Contoh fungsi:

```dart
Future signInWithGoogle() async {
  GoogleAuthProvider googleProvider = GoogleAuthProvider();

  UserCredential result = await _auth.signInWithPopup(googleProvider);

  User? firebaseUser = result.user;

  if (firebaseUser != null) {
    UserModel? user = await getUserData(firebaseUser.uid);

    if (user != null) {
      if (!user.approved) {
        await _auth.signOut();
        throw Exception("Access denied. Awaiting Manager/Owner approval.");
      }

      return user;
    }
  }

  return null;
}
```

### Penjelasan

Login Google digunakan agar user dapat masuk menggunakan akun Google. Namun, project tetap mengambil data user dari Firestore karena role, status approval, dan status aktif tidak disimpan langsung di Firebase Authentication.

---

### d. Logout

Contoh fungsi:

```dart
Future signOut() async {
  await _auth.signOut();
}
```

### Penjelasan

Fungsi ini mengeluarkan user dari sesi login Firebase. Setelah logout, aplikasi dapat diarahkan kembali ke halaman login.

---

## 4. Cloud Firestore

### Fungsi

Cloud Firestore digunakan sebagai database utama aplikasi. Firestore menyimpan data dalam bentuk collection dan document. Pada project Coffee-Shop-POS, Firestore digunakan untuk menyimpan data user, produk, order, dan payment.

Struktur collection yang direkomendasikan:

```text
users
products
orders
payments
```

---

## 5. Firestore untuk User

### Collection

```text
users
```

### Fungsi

Collection `users` menyimpan data tambahan pengguna yang tidak disimpan langsung di Firebase Authentication. Contohnya adalah role, status approval, dan status aktif.

Contoh pengambilan user:

```dart
Future getUserData(String uid) async {
  DocumentSnapshot doc = await _db.collection("users").doc(uid).get();

  if (doc.exists) {
    return UserModel.fromFirestore(doc);
  }

  return null;
}
```

### Penjelasan

Firebase Authentication hanya menyimpan informasi dasar akun, seperti UID dan email. Karena aplikasi POS membutuhkan role dan status akses, maka data tersebut disimpan di Firestore.

---

## 6. Firestore untuk Product

### Collection

```text
products
```

### File terkait

```text
lib/services/product_service.dart
lib/models/products_model.dart
```

### Fungsi

Data produk diambil dari Firestore secara realtime menggunakan `snapshots()`. Jika data produk berubah di Firebase, tampilan aplikasi dapat ikut berubah tanpa perlu reload manual.

Contoh service:

```dart
Stream<List<Product>> getProducts({
  String searchQuery = "",
  String category = "All",
}) {
  return _db.collection('products').snapshots().map((snapshot) {
    List<Product> products = snapshot.docs.map((doc) {
      return Product.fromFirestore(doc.data(), doc.id);
    }).toList();

    if (searchQuery.isNotEmpty) {
      products = products.where((product) {
        return product.name.toLowerCase().contains(
          searchQuery.toLowerCase(),
        );
      }).toList();
    }

    if (category != "All") {
      products = products
          .where((product) => product.category == category)
          .toList();
    }

    return products;
  });
}
```

### Penjelasan

`collection('products')` menunjuk ke collection produk di Firestore. Method `snapshots()` membuat data bersifat realtime. Setiap document produk diubah menjadi object Dart menggunakan:

```dart
Product.fromFirestore(doc.data(), doc.id)
```

### Contoh struktur document produk

```json
{
  "name": "Cappuccino",
  "category": "Coffee",
  "price": 25000,
  "image": "assets/images/cappuccino.png",
  "prices": [
    {
      "label": "Small",
      "amount": 18000
    },
    {
      "label": "Large",
      "amount": 25000
    }
  ]
}
```

### Fungsi dalam aplikasi

Data dari collection `products` digunakan untuk menampilkan daftar menu coffee shop. Kasir dapat memilih produk, memilih harga, lalu memasukkannya ke cart.

---

## 7. Firestore untuk Cart dan Order

### Collection

```text
orders
```

### File terkait

```text
lib/services/cart_service.dart
lib/services/order_service.dart
lib/models/cart_model.dart
lib/models/order_model.dart
```

### Fungsi CartService

`CartService` digunakan untuk menyimpan cart ke Firestore. Pada project ini, cart yang disimpan akan masuk ke collection `orders`.

Contoh fungsi:

```dart
Future saveCart(
  String cartId,
  String customerName,
  List<CartItem> items,
  double totalAmount,
  bool paid,
  String paymentMode,
) async {
  final cartData = {
    'cartId': cartId,
    'customerName': customerName.isEmpty ? cartId : customerName,
    'items': items.map((item) => item.toMap()).toList(),
    'diskon': 0,
    'tax': 0,
    'totalAmount': totalAmount,
    'paid': paid,
    'paymentMode': paymentMode.isEmpty ? '-' : paymentMode,
    'timestamp': FieldValue.serverTimestamp(),
  };

  await _firestore.collection('orders').doc(cartId).set(cartData);
}
```

### Penjelasan

Fungsi ini menyimpan data transaksi ke Firestore. `cartId` digunakan sebagai ID document. Jika nama customer kosong, maka nama customer otomatis menggunakan `cartId`.

Field `items` berisi daftar produk yang dibeli. Setiap item diubah menjadi Map menggunakan:

```dart
item.toMap()
```

### Contoh struktur document order

```json
{
  "cartId": "ORDER-001",
  "customerName": "Budi",
  "items": [
    {
      "productId": "product_1",
      "name": "Cappuccino",
      "quantity": 2,
      "selectedPrice": {
        "label": "Large",
        "amount": 25000
      },
      "subtotal": 50000
    }
  ],
  "diskon": 0,
  "tax": 0,
  "totalAmount": 50000,
  "paid": false,
  "paymentMode": "-",
  "timestamp": "server_timestamp"
}
```

### Fungsi dalam aplikasi

Data order digunakan untuk menyimpan transaksi yang masih pending ataupun sudah paid. Dengan struktur ini, kasir dapat membuka kembali order pending dan melanjutkan proses checkout.

---

## 8. Firestore untuk Daftar Order

### Fungsi OrderService

`OrderService` digunakan untuk membaca daftar order dari Firestore.

Contoh fungsi:

```dart
Stream<List<OrderList>> getOrders() {
  return _db
      .collection('orders')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map((doc) => OrderList.fromMap(doc.data()))
            .toList(),
      );
}
```

### Penjelasan

Fungsi ini mengambil data dari collection `orders`, kemudian mengurutkan berdasarkan `timestamp` terbaru. Method `snapshots()` digunakan agar daftar order berubah otomatis ketika ada transaksi baru atau ketika status pembayaran berubah.

### Mengambil item order

```dart
Future<List<Map<String, dynamic>>?> getItemsOrder(String orderId) async {
  final doc = await _db.collection('orders').doc(orderId).get();

  if (doc.exists) {
    return List<Map<String, dynamic>>.from(doc.data()?['items'] ?? []);
  }

  return null;
}
```

Fungsi ini digunakan untuk mengambil detail item dari satu order berdasarkan `orderId`.

---

## 9. Firestore untuk Payment

### Collection

```text
payments
```

### File terkait

```text
lib/services/payment_service.dart
lib/models/payment_model.dart
```

### Fungsi

PaymentService digunakan untuk menyimpan data pembayaran dan mengubah status order menjadi paid.

Contoh fungsi:

```dart
Future processPayment(Payment payment) async {
  await _firestore.collection('payments').add(payment.toMap());

  await _firestore.collection('orders').doc(payment.orderId).update({
    'paid': true,
    'paymentMode': payment.paymentMethod,
  });
}
```

### Penjelasan

Ada dua proses utama pada fungsi ini.

Pertama, data pembayaran disimpan ke collection `payments`.

Kedua, document order di collection `orders` diperbarui agar field `paid` menjadi `true` dan `paymentMode` berisi metode pembayaran yang dipilih.

### Contoh struktur document payment

```json
{
  "orderId": "ORDER-001",
  "paymentMethod": "Cash",
  "totalAmount": 50000,
  "receivedAmount": 100000,
  "changeAmount": 50000,
  "paymentDate": "server_timestamp"
}
```

### Fungsi dalam aplikasi

Payment digunakan saat kasir menyelesaikan transaksi. Jika pembayaran berhasil, status order berubah dari pending menjadi paid.

---

## 10. Firebase Storage untuk Bukti Pembayaran QRIS

### Status dalam project

Pada `pubspec.yaml`, package `firebase_storage` belum terlihat digunakan. Namun, jika aplikasi ingin menyimpan bukti pembayaran QRIS berupa gambar, Firebase Storage adalah layanan yang tepat.

Tambahkan dependency:

```bash
flutter pub add firebase_storage
```

### Fungsi

Firebase Storage digunakan untuk menyimpan file seperti gambar, foto, audio, atau dokumen. Pada aplikasi POS, Storage dapat digunakan untuk menyimpan gambar bukti pembayaran QRIS.

### Contoh service upload bukti QRIS

Buat file baru:

```text
lib/services/payment_proof_storage_service.dart
```

Isi file:

```dart
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class PaymentProofStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadQrisProof({
    required String orderId,
    required File imageFile,
  }) async {
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

    final ref = _storage.ref().child(
      'payment_proofs/qris/$orderId/$fileName',
    );

    final uploadTask = await ref.putFile(imageFile);

    final downloadUrl = await uploadTask.ref.getDownloadURL();

    return downloadUrl;
  }
}
```

### Penjelasan

Kode tersebut membuat folder penyimpanan:

```text
payment_proofs/qris/{orderId}/{fileName}
```

Setelah gambar berhasil diupload, Firebase Storage akan menghasilkan URL gambar melalui:

```dart
getDownloadURL()
```

URL tersebut kemudian dapat disimpan ke Firestore pada collection `payments`.

### Contoh data payment dengan bukti QRIS

```json
{
  "orderId": "ORDER-001",
  "paymentMethod": "QRIS",
  "totalAmount": 50000,
  "proofImageUrl": "https://firebasestorage.googleapis.com/...",
  "paymentDate": "server_timestamp"
}
```

### Integrasi dengan PaymentService

Contoh pengembangan fungsi pembayaran QRIS:

```dart
Future processQrisPayment({
  required Payment payment,
  required String proofImageUrl,
}) async {
  final paymentData = payment.toMap();
  paymentData['proofImageUrl'] = proofImageUrl;

  await _firestore.collection('payments').add(paymentData);

  await _firestore.collection('orders').doc(payment.orderId).update({
    'paid': true,
    'paymentMode': 'QRIS',
    'proofImageUrl': proofImageUrl,
  });
}
```

---

## 11. Hubungan Firebase dengan Model

Model digunakan untuk mengubah data dari Firebase menjadi object Dart dan sebaliknya.

| Model       | Fungsi                                               |
| ----------- | ---------------------------------------------------- |
| `UserModel` | Mengubah data user Firestore menjadi object user     |
| `Product`   | Mengubah data produk Firestore menjadi object produk |
| `CartItem`  | Mengubah data item cart menjadi Map dan object       |
| `OrderList` | Mengubah data order Firestore menjadi object order   |
| `Payment`   | Mengubah data pembayaran menjadi Map dan object      |

Contoh:

```dart
Product.fromFirestore(doc.data(), doc.id);
```

Kode tersebut berarti data produk dari Firestore diubah menjadi object `Product`.

Contoh lain:

```dart
payment.toMap();
```

Kode tersebut berarti object `Payment` diubah menjadi Map agar bisa disimpan ke Firestore.

---

## 12. Hubungan Firebase dengan Provider

Provider digunakan untuk menghubungkan data dari service ke tampilan UI.

Alur umumnya:

```text
Firebase
   ↓
Service
   ↓
Provider
   ↓
Screen / Widget
```

Contoh alur produk:

```text
Cloud Firestore collection products
   ↓
ProductService.getProducts()
   ↓
ProductProvider
   ↓
ProductGridWidget
```

Contoh alur order:

```text
Cloud Firestore collection orders
   ↓
OrderService.getOrders()
   ↓
OrderProvider
   ↓
Order List Screen
```

Dengan pola ini, UI tidak langsung memanggil Firebase. UI cukup memanggil Provider, Provider memanggil Service, lalu Service berkomunikasi dengan Firebase.

---

## 13. Rekomendasi Struktur Database Firestore

Struktur sederhana yang sesuai untuk aplikasi POS:

```text
users
 └── {uid}
     ├── name
     ├── email
     ├── role
     ├── approved
     └── active

products
 └── {productId}
     ├── name
     ├── category
     ├── price
     ├── image
     └── prices

orders
 └── {cartId}
     ├── cartId
     ├── customerName
     ├── items
     ├── totalAmount
     ├── paid
     ├── paymentMode
     └── timestamp

payments
 └── {paymentId}
     ├── orderId
     ├── paymentMethod
     ├── totalAmount
     ├── receivedAmount
     ├── changeAmount
     ├── proofImageUrl
     └── paymentDate
```

---

## 14. Contoh Security Rules Sederhana

Security Rules harus disesuaikan lagi dengan kebutuhan role Owner, Manager, dan Cashier. Contoh berikut hanya dasar awal.

```js
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {

    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }

    match /products/{productId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }

    match /orders/{orderId} {
      allow read, write: if request.auth != null;
    }

    match /payments/{paymentId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

Untuk produksi, rules sebaiknya dibatasi berdasarkan role. Contohnya, Cashier dapat membuat order dan payment, tetapi tidak boleh menghapus produk. Manager dapat mengelola produk. Owner dapat mengelola user.

---

## 15. Catatan Keamanan Project

Jangan upload file private Firebase Admin SDK ke GitHub. File seperti berikut harus masuk `.gitignore`:

```text
*-firebase-adminsdk-*.json
```

Firebase Admin SDK berbeda dengan `firebase_options.dart`.

`firebase_options.dart` berisi konfigurasi client app dan biasanya boleh ada di project Flutter. Namun, file Admin SDK JSON berisi private key dan tidak boleh masuk repository publik.

---

## 16. Checklist Penggunaan Firebase

Gunakan checklist berikut untuk memastikan Firebase berjalan benar.

```text
[ ] Project Firebase sudah dibuat
[ ] Android app sudah terdaftar di Firebase
[ ] Package name Android sesuai dengan project Flutter
[ ] File google-services.json sudah benar
[ ] FlutterFire CLI sudah dijalankan
[ ] firebase_options.dart sudah ada di folder lib
[ ] Firebase.initializeApp() sudah dipanggil di main.dart
[ ] Email/password login sudah diaktifkan di Firebase Authentication
[ ] Google Sign-In sudah dikonfigurasi jika digunakan
[ ] Cloud Firestore sudah dibuat
[ ] Collection users, products, orders, payments sudah sesuai
[ ] Security Rules sudah disesuaikan
[ ] Firebase Storage sudah diaktifkan jika memakai upload bukti QRIS
```

---

## 17. Referensi Resmi

- Firebase Flutter Setup: https://firebase.google.com/docs/flutter/setup
- Firebase Authentication Email/Password Flutter: https://firebase.google.com/docs/auth/flutter/password-auth
- Cloud Firestore Add Data: https://firebase.google.com/docs/firestore/manage-data/add-data
- Cloud Firestore Realtime Updates: https://firebase.google.com/docs/firestore/query-data/listen
- Cloud Storage Flutter Upload Files: https://firebase.google.com/docs/storage/flutter/upload-files

---

## 18. Kesimpulan

Firebase pada project Coffee-Shop-POS digunakan sebagai backend utama. Firebase Core menghubungkan aplikasi dengan Firebase. Firebase Authentication mengatur login, register, dan logout. Cloud Firestore menyimpan data user, produk, order, dan payment. Firebase Storage dapat digunakan untuk menyimpan bukti pembayaran QRIS berupa gambar.

Pembagian file dalam project sudah tepat karena logic Firebase diletakkan di folder `services`, struktur data diletakkan di folder `models`, dan state aplikasi dikelola melalui `providers`. Pola ini membuat kode lebih rapi, mudah diuji, dan lebih mudah dikembangkan.
