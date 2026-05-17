# Penjelasan Fungsi Constructor Dart pada Project Coffee-Shop-POS

Dokumen ini menjelaskan fungsi **constructor biasa**, **named constructor**, **factory constructor**, dan **static method** dalam bahasa Dart, lalu menyesuaikannya dengan penerapan pada project Flutter **Coffee-Shop-POS**.

Repository acuan: <https://github.com/julian34/Coffee-Shop-POS>  
Artikel acuan: <https://medium.com/@champs_hamy/mastering-dart-constructors-named-vs-factory-vs-static-methods-aacb0c41df7b>  
Dokumentasi Dart: <https://dart.dev/language/constructors>

---

## 1. Tujuan Constructor di Dart

Constructor adalah fungsi khusus di dalam class yang dipakai untuk membuat dan menginisialisasi object. Dalam aplikasi Flutter, constructor sangat penting karena hampir semua data yang ditampilkan di UI perlu dibentuk menjadi object terlebih dahulu.

Pada project **Coffee-Shop-POS**, constructor banyak digunakan pada file model, seperti:

- `products_model.dart`
- `cart_model.dart`
- `order_model.dart`
- `payment_model.dart`
- `user_model.dart`

Model tersebut berfungsi sebagai struktur data utama aplikasi, misalnya data produk, item keranjang, order, pembayaran, dan user.

---

## 2. Constructor Biasa

Constructor biasa digunakan ketika semua data yang dibutuhkan object sudah tersedia dan langsung dimasukkan ke dalam class.

Contoh dari model harga produk:

```dart
class ProductPrice {
  final String label;
  final double amount;

  ProductPrice({
    required this.label,
    required this.amount,
  });
}
```

### Fungsi Constructor Biasa

Constructor ini berfungsi untuk membuat object `ProductPrice` dengan nilai `label` dan `amount`.

Contoh penggunaan:

```dart
final price = ProductPrice(
  label: 'Large',
  amount: 25000,
);
```

Pada aplikasi POS, constructor ini cocok untuk membuat pilihan harga produk, misalnya ukuran `Small`, `Medium`, atau `Large`.

### Penjelasan Tipe Data

| Field    | Tipe Data | Fungsi                                                                  |
| -------- | --------: | ----------------------------------------------------------------------- |
| `label`  |  `String` | Menyimpan nama pilihan harga, misalnya `Small`, `Medium`, atau `Large`. |
| `amount` |  `double` | Menyimpan nominal harga produk.                                         |

### Status Akses

| Bagian         | Status | Penjelasan                                              |
| -------------- | ------ | ------------------------------------------------------- |
| `ProductPrice` | Public | Bisa digunakan dari file lain karena tidak diawali `_`. |
| `label`        | Public | Bisa dibaca dari luar object.                           |
| `amount`       | Public | Bisa dibaca dari luar object.                           |

---

## 3. Named Constructor

Named constructor adalah constructor yang memiliki nama tambahan. Tujuannya agar cara membuat object menjadi lebih jelas sesuai kebutuhan.

Contoh pada project:

```dart
factory ProductPrice.empty() {
  return ProductPrice(label: '', amount: 0.0);
}
```

Walaupun memakai kata kunci `factory`, bentuk ini juga berfungsi sebagai named constructor karena memiliki nama khusus, yaitu `.empty()`.

### Fungsi `ProductPrice.empty()`

`ProductPrice.empty()` digunakan untuk membuat object harga kosong/default ketika data harga tidak tersedia atau tidak valid.

Contoh penggunaan:

```dart
final emptyPrice = ProductPrice.empty();
```

Hasilnya sama seperti:

```dart
ProductPrice(label: '', amount: 0.0);
```

Namun penulisan `ProductPrice.empty()` lebih mudah dipahami karena langsung menjelaskan bahwa object yang dibuat adalah object kosong.

### Realisasi pada Coffee-Shop-POS

Pada `CartItem.fromMap()`, data `selectedPrice` diperiksa terlebih dahulu. Jika data tersebut berbentuk `Map`, maka data diubah menjadi object `ProductPrice`. Jika tidak valid, aplikasi memakai `ProductPrice.empty()` agar tidak error.

Contoh pola logikanya:

```dart
final selectedPriceData = map['selectedPrice'];

final ProductPrice selectedPrice = (selectedPriceData is Map)
    ? ProductPrice.fromMap(selectedPriceData)
    : ProductPrice.empty();
```

Artinya, aplikasi tetap bisa membuat item keranjang walaupun data harga pilihan tidak lengkap.

---

## 4. Factory Constructor

Factory constructor adalah constructor yang dipakai ketika proses pembuatan object membutuhkan logika tambahan. Factory constructor tidak hanya menerima data, tetapi juga bisa melakukan validasi, parsing, konversi tipe data, memberi nilai default, atau mengembalikan object yang sudah diproses.

Dalam project **Coffee-Shop-POS**, factory constructor banyak dipakai karena data dari Firebase Firestore biasanya berbentuk `Map` atau `DocumentSnapshot`, sedangkan aplikasi Flutter lebih rapi jika data tersebut diubah menjadi object Dart.

---

## 5. `Product.fromFirestore()`

Contoh factory constructor pada `products_model.dart`:

```dart
factory Product.fromFirestore(Map data, String docId) {
  return Product(
    id: docId,
    name: data['name'] ?? 'Unknown',
    category: data['category'] ?? 'Unknown',
    price: _parsePrice(data['price']),
    image: data['image'] ?? '',
    prices: (data['prices'] as List?)
            ?.map((p) => ProductPrice.fromMap(p))
            .toList() ??
        [ProductPrice(label: 'Default', amount: _parsePrice(data['price']))],
  );
}
```

### Fungsi

`Product.fromFirestore()` berfungsi untuk mengubah data produk dari Firestore menjadi object `Product`.

Data dari Firestore biasanya berbentuk seperti ini:

```dart
{
  'name': 'Cappuccino',
  'category': 'Coffee',
  'price': 25000,
  'image': 'cappuccino.png'
}
```

Kemudian data tersebut diubah menjadi object:

```dart
Product(
  id: docId,
  name: 'Cappuccino',
  category: 'Coffee',
  price: 25000.0,
  image: 'cappuccino.png',
  prices: [...]
);
```

### Realisasi pada Aplikasi

Pada aplikasi kasir, produk yang tersimpan di Firestore perlu ditampilkan di halaman produk. Agar UI Flutter tidak langsung membaca data mentah Firestore, data tersebut diubah dahulu menjadi object `Product`.

Alurnya:

```text
Firestore Document
        ↓
Map data
        ↓
Product.fromFirestore(data, docId)
        ↓
Object Product
        ↓
Ditampilkan di UI Flutter
```

### Penjelasan Field

| Field      |            Tipe Data | Fungsi                                      |
| ---------- | -------------------: | ------------------------------------------- |
| `id`       |             `String` | Menyimpan ID dokumen produk dari Firestore. |
| `name`     |             `String` | Menyimpan nama produk.                      |
| `category` |             `String` | Menyimpan kategori produk.                  |
| `price`    |             `double` | Menyimpan harga utama produk.               |
| `image`    |             `String` | Menyimpan path atau URL gambar produk.      |
| `prices`   | `List<ProductPrice>` | Menyimpan daftar pilihan harga produk.      |

---

## 6. `ProductPrice.fromMap()`

Contoh:

```dart
factory ProductPrice.fromMap(Map data) {
  return ProductPrice(
    label: data['label'] ?? 'Unknown',
    amount: Product._parsePrice(data['amount']),
  );
}
```

### Fungsi

`ProductPrice.fromMap()` digunakan untuk mengubah data harga dari bentuk `Map` menjadi object `ProductPrice`.

Contoh data mentah:

```dart
{
  'label': 'Large',
  'amount': 25000
}
```

Diubah menjadi:

```dart
ProductPrice(
  label: 'Large',
  amount: 25000.0,
);
```

### Realisasi pada Aplikasi

Fungsi ini berguna ketika satu produk memiliki beberapa pilihan harga. Misalnya satu menu kopi memiliki ukuran `Small`, `Medium`, dan `Large`.

---

## 7. `CartItem.fromMap()`

Contoh pada `cart_model.dart`:

```dart
factory CartItem.fromMap(Map map) {
  final selectedPriceData = map['selectedPrice'];

  final ProductPrice selectedPrice = (selectedPriceData is Map)
      ? ProductPrice.fromMap(selectedPriceData)
      : ProductPrice.empty();

  return CartItem(
    productId: map['productId'] ?? '',
    name: map['name'] ?? '',
    price: (map['price'] ?? 0).toDouble(),
    label: map['label'] ?? '',
    selectedPrice: selectedPrice,
    quantity: (map['quantity'] ?? 1).toInt(),
    image: map['image'] ?? '',
  );
}
```

### Fungsi

`CartItem.fromMap()` berfungsi untuk mengubah data item keranjang dari `Map` menjadi object `CartItem`.

### Realisasi pada Aplikasi

Ketika kasir menambahkan produk ke keranjang, data item disimpan dalam struktur tertentu. Saat data tersebut dibaca kembali, `CartItem.fromMap()` mengubahnya menjadi object yang bisa digunakan oleh UI dan provider.

### Penjelasan Field

| Field           |      Tipe Data | Fungsi                             |
| --------------- | -------------: | ---------------------------------- |
| `productId`     |       `String` | ID produk yang masuk ke keranjang. |
| `name`          |       `String` | Nama produk.                       |
| `price`         |       `double` | Harga produk.                      |
| `label`         |       `String` | Label pilihan harga.               |
| `selectedPrice` | `ProductPrice` | Object harga yang dipilih.         |
| `quantity`      |          `int` | Jumlah item.                       |
| `image`         |       `String` | Gambar produk.                     |

---

## 8. `OrderList.fromMap()`

Contoh pada `order_model.dart`:

```dart
factory OrderList.fromMap(Map<String, dynamic> map) {
  return OrderList(
    cartId: map['cartId'] ?? '',
    customerName: map['customerName'] ?? 'Unknown',
    totalAmount: (map['totalAmount'] ?? 0).toDouble(),
    isPaid: map['isPaid'] ?? false,
    paid: map['paid'] ?? false,
    paymentMode: map['paymentMode'] ?? 'Cash',
    status: map['status'] ?? 'Pending',
    createdAt: _parseDate(map['createdAt']) ?? DateTime.now(),
    items: (map['items'] is List)
        ? (map['items'] as List)
            .whereType<Map<String, dynamic>>()
            .map((item) => CartItem.fromMap(item))
            .toList()
        : [],
  );
}
```

### Fungsi

`OrderList.fromMap()` digunakan untuk mengubah data order dari Firestore atau Map menjadi object `OrderList`.

### Realisasi pada Aplikasi

Data order dipakai pada halaman daftar pesanan. Jika status order masih `Pending`, aplikasi dapat mengarahkan pengguna ke proses checkout. Jika status sudah `Paid`, aplikasi dapat menampilkan detail order.

### Bagian Penting

Field `createdAt` tidak langsung dipakai begitu saja. Nilai tanggal dapat berbentuk `Timestamp`, `DateTime`, atau `String`, sehingga diproses melalui method `_parseDate()`.

---

## 9. `Payment.fromMap()`

Contoh pada `payment_model.dart`:

```dart
factory Payment.fromMap(Map<String, dynamic> map) {
  return Payment(
    orderId: map['orderId'] ?? '',
    totalAmount: (map['totalAmount'] as num?)?.toDouble() ?? 0.0,
    receivedAmount: (map['receivedAmount'] as num?)?.toDouble() ?? 0.0,
    changeAmount: (map['changeAmount'] as num?)?.toDouble() ?? 0.0,
    paymentMethod: map['paymentMethod'] ?? 'Cash',
    createdAt: _parseDate(map['createdAt']) ?? DateTime.now(),
  );
}
```

### Fungsi

`Payment.fromMap()` berfungsi untuk mengubah data pembayaran menjadi object `Payment`.

### Realisasi pada Aplikasi

Model ini digunakan ketika aplikasi menyimpan atau membaca data pembayaran, seperti:

- total belanja,
- uang yang diterima,
- uang kembalian,
- metode pembayaran,
- waktu pembayaran.

Model ini cocok untuk fitur pembayaran kasir, baik pembayaran tunai maupun QRIS.

---

## 10. `UserModel.fromFirestore()`

Contoh pada `user_model.dart`:

```dart
factory UserModel.fromFirestore(DocumentSnapshot doc) {
  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

  return UserModel(
    uid: doc.id,
    name: data['name'] ?? '',
    email: data['email'] ?? '',
    role: data['role'] ?? 'Cashier',
    approved: data['approved'] ?? false,
    active: data['active'] ?? true,
  );
}
```

### Fungsi

`UserModel.fromFirestore()` berfungsi untuk mengubah dokumen user dari Firestore menjadi object `UserModel`.

### Realisasi pada Aplikasi

Model ini digunakan untuk sistem login dan role user. Dalam aplikasi Coffee-Shop-POS, role user dapat berupa:

- `Owner`
- `Manager`
- `Cashier`

Data `approved` digunakan untuk menandai apakah akun sudah disetujui admin. Data `active` digunakan untuk menandai apakah akun masih aktif.

---

## 11. `toMap()`

Selain `fromMap()` atau `fromFirestore()`, beberapa model juga memiliki method `toMap()`.

Contoh:

```dart
Map<String, dynamic> toMap() {
  return {
    'label': label,
    'amount': amount,
  };
}
```

### Fungsi

`toMap()` adalah kebalikan dari `fromMap()`.

Jika `fromMap()` mengubah `Map` menjadi object, maka `toMap()` mengubah object menjadi `Map`.

Alurnya:

```text
Object Dart
        ↓
toMap()
        ↓
Map
        ↓
Disimpan ke Firestore
```

### Realisasi pada Aplikasi

Method `toMap()` dipakai ketika data dari Flutter perlu disimpan kembali ke Firestore. Contohnya saat menyimpan item keranjang, order, pembayaran, atau data user.

---

## 12. Static Method

Static method adalah method yang dimiliki oleh class, bukan oleh object. Method ini dapat dipanggil tanpa membuat object terlebih dahulu.

Contoh pada `Product`:

```dart
static double _parsePrice(dynamic price) {
  if (price is num) {
    return price.toDouble();
  }

  if (price is String) {
    return double.tryParse(price) ?? 0.0;
  }

  return 0.0;
}
```

### Fungsi

`_parsePrice()` digunakan untuk mengubah nilai harga menjadi tipe `double`.

Data harga dari Firestore bisa berbentuk:

```dart
25000
```

atau:

```dart
"25000"
```

Dengan `_parsePrice()`, dua bentuk data tersebut dapat diubah menjadi:

```dart
25000.0
```

### Kenapa Menggunakan Static?

Method ini tidak membutuhkan object `Product`. Ia hanya membutuhkan input `price`, lalu mengembalikan nilai `double`. Karena itu, method ini dibuat sebagai `static`.

### Kenapa Ada Tanda `_`?

Tanda `_` pada `_parsePrice()` berarti method tersebut bersifat private pada library Dart. Artinya, method ini tidak dimaksudkan untuk dipanggil langsung dari luar file.

---

## 13. Perbedaan Public dan Private

Dalam Dart, penanda private menggunakan awalan garis bawah `_`.

Contoh:

```dart
static double _parsePrice(dynamic price) { ... }
```

Method `_parsePrice()` bersifat private karena diawali `_`.

Sementara itu, class atau method berikut bersifat public karena tidak diawali `_`:

```dart
Product
Product.fromFirestore()
ProductPrice
ProductPrice.fromMap()
CartItem
CartItem.fromMap()
OrderList
Payment
UserModel
```

### Tabel Public dan Private

| Nama                      | Status  | Penjelasan                                                                 |
| ------------------------- | ------- | -------------------------------------------------------------------------- |
| `Product`                 | Public  | Dapat digunakan dari file lain.                                            |
| `Product.fromFirestore()` | Public  | Dapat dipakai service/provider untuk membuat object produk dari Firestore. |
| `Product._parsePrice()`   | Private | Hanya dipakai sebagai helper internal untuk parsing harga.                 |
| `ProductPrice`            | Public  | Dapat digunakan dari file lain.                                            |
| `ProductPrice.empty()`    | Public  | Dapat digunakan untuk membuat harga kosong/default.                        |
| `CartItem.fromMap()`      | Public  | Dapat digunakan untuk mengubah data Map menjadi item keranjang.            |
| `OrderList._parseDate()`  | Private | Helper internal untuk mengubah format tanggal.                             |
| `Payment._parseDate()`    | Private | Helper internal untuk mengubah format tanggal pembayaran.                  |

---

## 14. Perbandingan Konsep

| Konsep              | Fungsi Utama                                       | Contoh di Project                                                    | Kapan Digunakan                                                 |
| ------------------- | -------------------------------------------------- | -------------------------------------------------------------------- | --------------------------------------------------------------- |
| Constructor biasa   | Membuat object langsung dari data yang sudah siap. | `ProductPrice(...)`, `CartItem(...)`, `Payment(...)`                 | Saat semua nilai sudah tersedia.                                |
| Named constructor   | Memberi nama khusus pada cara membuat object.      | `ProductPrice.empty()`, `OrderList.empty()`                          | Saat ingin membuat object default atau variasi object tertentu. |
| Factory constructor | Membuat object dengan proses tambahan.             | `Product.fromFirestore()`, `CartItem.fromMap()`, `Payment.fromMap()` | Saat data berasal dari Firestore, JSON, atau Map.               |
| Static method       | Fungsi bantuan milik class.                        | `Product._parsePrice()`, `Payment._parseDate()`                      | Saat fungsi tidak membutuhkan object.                           |
| `toMap()`           | Mengubah object menjadi Map.                       | `CartItem.toMap()`, `Payment.toMap()`                                | Saat data akan disimpan ke Firestore.                           |

---

## 15. Alur Data pada Coffee-Shop-POS

Secara sederhana, penggunaan constructor pada aplikasi dapat digambarkan seperti ini:

```text
Firebase Firestore
        ↓
DocumentSnapshot / Map
        ↓
Factory Constructor
        ↓
Object Model Dart
        ↓
Provider / Service
        ↓
UI Flutter
```

Contoh alur produk:

```text
products collection di Firestore
        ↓
ProductService mengambil dokumen
        ↓
Product.fromFirestore(data, docId)
        ↓
Object Product
        ↓
Product Grid menampilkan produk
```

Contoh alur cart:

```text
Data keranjang dari Firestore / Map
        ↓
CartItem.fromMap()
        ↓
Object CartItem
        ↓
Cart screen menampilkan item pesanan
```

Contoh alur order:

```text
Data order dari Firestore
        ↓
OrderList.fromMap()
        ↓
Object OrderList
        ↓
Order list screen menampilkan status pending/paid
```

---

## 16. Kesimpulan

Pada project **Coffee-Shop-POS**, constructor tidak hanya berfungsi untuk membuat object, tetapi juga menjadi bagian penting dari proses pengolahan data aplikasi. Constructor biasa digunakan ketika data sudah siap. Factory constructor digunakan ketika data masih berbentuk `Map`, `DocumentSnapshot`, atau data mentah dari Firestore. Named constructor digunakan untuk membuat object dengan kondisi khusus, seperti object kosong/default. Static method digunakan sebagai helper internal untuk mengubah tipe data, seperti harga dan tanggal.

Dengan pola ini, kode menjadi lebih rapi karena UI tidak perlu memproses data mentah dari Firebase secara langsung. Semua proses konversi ditempatkan di dalam model, sehingga service, provider, dan screen dapat bekerja dengan object Dart yang sudah siap digunakan.

---

## 17. Rekomendasi Penempatan File

File ini dapat disimpan pada folder:

```text
docs/dart-constructors-pos.md
```

atau:

```text
docs/constructor-dart-coffee-shop-pos.md
```

Nama file yang disarankan:

```text
dart-constructors-pos.md
```
