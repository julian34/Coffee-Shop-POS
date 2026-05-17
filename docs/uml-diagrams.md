# Diagram UML Coffee Shop POS

Dokumen ini berisi rancangan UML untuk aplikasi **Coffee Shop POS** berdasarkan struktur Flutter, Provider, model, service, dan integrasi Firebase/Firestore yang ada di proyek.

## 1. Use Case Diagram

Diagram ini menggambarkan aktor utama aplikasi dan fitur yang dapat diakses oleh setiap peran.

```mermaid
flowchart LR
    Owner([Owner])
    Manager([Manager])
    Cashier([Cashier])
    Customer([Customer])
    Firebase[(Firebase Auth / Firestore)]

    subgraph POS[Coffee Shop POS]
        UCLogin((Login))
        UCLogout((Logout))
        UCProfile((Melihat Profil))
        UCProducts((Melihat Menu Produk))
        UCSearchProduct((Mencari Produk))
        UCFilterProduct((Filter Produk per Kategori))
        UCAddCart((Menambahkan Produk ke Keranjang))
        UCUpdateQty((Mengubah Jumlah Item))
        UCRemoveItem((Menghapus Item Keranjang))
        UCCustomerName((Mengisi Nama Pelanggan))
        UCSaveOrder((Menyimpan Pesanan))
        UCOrders((Melihat Daftar Pesanan))
        UCFilterOrder((Mencari / Filter Pesanan))
        UCOrderDetail((Melihat Detail Pesanan))
        UCPayment((Memproses Pembayaran))
        UCRecordPayment((Mencatat Pembayaran))
        UCMarkPaid((Mengubah Status Pesanan Menjadi Paid))
        UCSuccess((Melihat Halaman Sukses Pembayaran))
        UCUserStatus((Mengelola Status Pengguna))
    end

    Owner --> UCLogin
    Owner --> UCLogout
    Owner --> UCProfile
    Owner --> UCProducts
    Owner --> UCOrders
    Owner --> UCFilterOrder
    Owner --> UCOrderDetail
    Owner --> UCUserStatus

    Manager --> UCLogin
    Manager --> UCLogout
    Manager --> UCProfile
    Manager --> UCProducts
    Manager --> UCOrders
    Manager --> UCFilterOrder
    Manager --> UCOrderDetail
    Manager --> UCUserStatus

    Cashier --> UCLogin
    Cashier --> UCLogout
    Cashier --> UCProfile
    Cashier --> UCProducts
    Cashier --> UCSearchProduct
    Cashier --> UCFilterProduct
    Cashier --> UCAddCart
    Cashier --> UCUpdateQty
    Cashier --> UCRemoveItem
    Cashier --> UCCustomerName
    Cashier --> UCSaveOrder
    Cashier --> UCOrders
    Cashier --> UCOrderDetail
    Cashier --> UCPayment
    Cashier --> UCSuccess

    Customer --> UCCustomerName
    Customer --> UCPayment

    UCProducts -. "include" .-> UCSearchProduct
    UCProducts -. "include" .-> UCFilterProduct
    UCSaveOrder -. "include" .-> UCCustomerName
    UCPayment -. "include" .-> UCRecordPayment
    UCPayment -. "include" .-> UCMarkPaid
    UCOrders -. "include" .-> UCFilterOrder

    UCLogin --> Firebase
    UCProducts --> Firebase
    UCSaveOrder --> Firebase
    UCOrders --> Firebase
    UCRecordPayment --> Firebase
    UCMarkPaid --> Firebase
    UCUserStatus --> Firebase
```

## 2. Class Diagram

Diagram ini memetakan kelas inti pada layer model, provider, service, routing, dan penyimpanan eksternal.

```mermaid
classDiagram
    direction LR

    class AppRoutes {
        <<core>>
        +String splash
        +String login
        +String ownerHome
        +String managerHome
        +String cashierHome
        +String cart
        +String order
        +String payment
        +String successpayment
        +String orderDetail
        +Future~String~ getInitialRoute()
        +Route~dynamic~ generateRoute(RouteSettings settings)
    }

    class UserModel {
        +String uid
        +String name
        +String email
        +String role
        +bool approved
        +bool active
        +UserModel fromFirestore(DocumentSnapshot doc)
        +Map~String,dynamic~ toMap()
    }

    class Product {
        +String id
        +String name
        +String category
        +double price
        +String image
        +Product fromFirestore(Map data, String docId)
    }

    class ProductPrice {
        +String label
        +double amount
        +ProductPrice fromMap(Map data)
    }

    class CartItem {
        +String productId
        +String name
        +double price
        +int quantity
        +String image
        +CartItem fromMap(Map map)
        +Map~String,dynamic~ toMap()
    }

    class OrderList {
        +String cartId
        +String customerName
        +double totalAmount
        +bool isPaid
        +String paymentMode
        +String status
        +DateTime createdAt
        +bool paid
        +List~CartItem~ items
        +OrderList fromMap(Map map)
        +Map~String,dynamic~ toMap()
        +OrderList empty()
    }

    class Payment {
        +String orderId
        +double totalAmount
        +double receivedAmount
        +double changeAmount
        +String paymentMethod
        +DateTime createdAt
        +Payment fromMap(Map map)
        +Map~String,dynamic~ toMap()
    }

    class AuthProvider {
        <<ChangeNotifier>>
        -AuthService authService
        -UserModel? user
        -String? errorMessage
        +bool isAuthenticated
        +Future~String?~ signInWithEmail(String email, String password)
        +Future~void~ signOut()
        +Future~void~ saveUserRole(String role)
    }

    class CartProvider {
        <<ChangeNotifier>>
        -CartService cartService
        -Map~String,CartItem~ items
        -String customerName
        +double totalAmount
        +void updateCustomerName(String name)
        +void addToCart(CartItem item)
        +void updateQuantity(String productId, int newQuantity)
        +void removeItem(String productId)
        +Future~void~ saveCart(String cartId, String customerName)
        +Future~void~ updateCart(String cartId, String customerName)
    }

    class OrdersProvider {
        <<ChangeNotifier>>
        -List~OrderList~ orders
        -List~OrderList~ filteredOrders
        -String searchQuery
        -String statusFilter
        +Future~void~ fetchOrders()
        +void updateSearchQuery(String query)
        +void updateStatusFilter(String status)
        +void applyFilters()
        +Future~void~ saveStatusFilter(String status)
        +Future~void~ loadStatusFilter()
    }

    class PaymentProvider {
        <<ChangeNotifier>>
        -PaymentService paymentService
        -OrderService orderService
        -String customerName
        +Future~void~ makePayment(Payment payment)
        +Future~void~ fetchCustomerName(String orderId)
        +Future fetchItemOrder(String orderId)
        +void clearCustomerName()
    }

    class AuthService {
        -FirebaseAuth auth
        -FirebaseFirestore db
        +FirebaseAuth authInstance
        +Future~UserModel?~ getUserData(String uid)
        +Future~UserModel?~ signInWithEmail(String email, String password)
        +Future~UserModel?~ signInWithGoogle()
        +Future~void~ registerUser(UserModel user, String password)
        +Future~void~ updateUserStatus(String uid, bool activeStatus)
        +Future~void~ signOut()
    }

    class ProductService {
        -FirebaseFirestore db
        +Stream getProducts(String searchQuery, String category)
    }

    class CartService {
        -FirebaseFirestore firestore
        +Future saveCart(String cartId, String customerName, List items, double totalAmount, bool paid, String paymentMode)
    }

    class OrderService {
        -FirebaseFirestore db
        +Stream getOrders()
        +Future getItemsOrder(String orderId)
    }

    class PaymentService {
        -FirebaseFirestore firestore
        +Future~void~ processPayment(Payment payment)
        +Future~String?~ getCustomerName(String orderId)
    }

    class FirebaseAuth {
        <<external>>
    }

    class FirebaseFirestore {
        <<external>>
        users
        products
        orders
        payments
    }

    Product "1" o-- "0..*" ProductPrice : optional prices
    OrderList "1" o-- "1..*" CartItem : items
    Payment "1" --> "1" OrderList : pays orderId

    AuthProvider --> AuthService : uses
    AuthProvider --> UserModel : stores session
    CartProvider --> CartService : persists cart
    CartProvider --> CartItem : manages
    OrdersProvider --> OrderList : filters
    PaymentProvider --> PaymentService : processes
    PaymentProvider --> OrderService : reads order items

    AuthService --> FirebaseAuth : authenticates
    AuthService --> FirebaseFirestore : reads/writes users
    ProductService --> FirebaseFirestore : reads products
    ProductService --> Product : maps documents
    CartService --> FirebaseFirestore : writes orders
    OrderService --> FirebaseFirestore : reads orders
    OrderService --> OrderList : maps documents
    PaymentService --> FirebaseFirestore : writes payments & updates orders

    AppRoutes --> UserModel : role based routing
    AppRoutes --> OrderList : screen arguments
    AppRoutes --> Payment : success argument
```

## 3. Sequence Diagram

Sequence berikut menjelaskan alur transaksi utama: kasir login, memilih produk, menyimpan pesanan, memproses pembayaran, lalu sistem menampilkan pembayaran berhasil.

```mermaid
sequenceDiagram
    autonumber
    actor Cashier as Kasir
    participant LoginScreen
    participant AuthProvider
    participant AuthService
    participant FirebaseAuth
    participant Firestore
    participant CashierHomeScreen
    participant ProductService
    participant CartProvider
    participant CartService
    participant OrdersScreen
    participant PaymentScreen
    participant PaymentProvider
    participant PaymentService
    participant SuccessScreen

    Cashier->>LoginScreen: Masukkan email dan password
    LoginScreen->>AuthProvider: signInWithEmail(email, password)
    AuthProvider->>AuthService: signInWithEmail(email, password)
    AuthService->>FirebaseAuth: signInWithEmailAndPassword(email, password)
    FirebaseAuth-->>AuthService: UserCredential
    AuthService->>Firestore: get users/{uid}
    Firestore-->>AuthService: UserModel data
    AuthService-->>AuthProvider: UserModel aktif dan approved
    AuthProvider-->>LoginScreen: Login berhasil + simpan role
    LoginScreen->>CashierHomeScreen: Navigasi sesuai role Cashier

    CashierHomeScreen->>ProductService: getProducts(searchQuery, category)
    ProductService->>Firestore: listen collection products
    Firestore-->>ProductService: snapshot produk
    ProductService-->>CashierHomeScreen: List<Product>
    Cashier->>CashierHomeScreen: Pilih produk
    CashierHomeScreen->>CartProvider: addToCart(CartItem)
    CartProvider-->>CashierHomeScreen: notifyListeners() + totalAmount diperbarui

    Cashier->>CashierHomeScreen: Checkout / simpan pesanan
    CashierHomeScreen->>CartProvider: saveCart(cartId, customerName, paid=false, paymentMode="-")
    CartProvider->>CartService: saveCart(cartId, customerName, items, totalAmount, paid, paymentMode)
    CartService->>Firestore: set orders/{cartId}
    Firestore-->>CartService: pesanan tersimpan
    CartService-->>CartProvider: selesai
    CartProvider-->>CashierHomeScreen: keranjang dikosongkan

    Cashier->>OrdersScreen: Buka daftar pesanan
    OrdersScreen->>Firestore: query orders orderBy timestamp desc
    Firestore-->>OrdersScreen: daftar OrderList
    Cashier->>PaymentScreen: Pilih order dan bayar
    PaymentScreen->>PaymentProvider: makePayment(Payment)
    PaymentProvider->>PaymentService: processPayment(payment)
    PaymentService->>Firestore: add payments
    Firestore-->>PaymentService: paymentId dibuat
    PaymentService->>Firestore: update orders/{orderId} paid=true, paymentMode
    Firestore-->>PaymentService: status order diperbarui
    PaymentService-->>PaymentProvider: selesai
    PaymentProvider-->>PaymentScreen: notifyListeners()
    PaymentScreen->>SuccessScreen: Navigasi dengan data Payment
    SuccessScreen-->>Cashier: Tampilkan bukti pembayaran berhasil
```

## 4. Entity Relationship Diagram (ERD)

Diagram ini menggambarkan struktur data yang digunakan pada koleksi Firestore dan relasi antar entitas dalam aplikasi Coffee Shop POS.

```mermaid
erDiagram
    USER {
        string uid PK
        string name
        string email
        string role
        boolean approved
        boolean active
    }

    PRODUCT {
        string id PK
        string name
        string category
        double price
        string image
    }

    PRODUCT_PRICE {
        string label
        double amount
    }

    ORDER {
        string cartId PK
        string customerName
        double totalAmount
        boolean isPaid
        boolean paid
        string paymentMode
        string status
        datetime createdAt
    }

    CART_ITEM {
        string productId FK
        string name
        double price
        string label
        int quantity
        string image
    }

    SELECTED_PRICE {
        string label
        double amount
    }

    PAYMENT {
        string orderId FK
        double totalAmount
        double receivedAmount
        double changeAmount
        string paymentMethod
        datetime createdAt
    }

    PRODUCT ||--|{ PRODUCT_PRICE : "memiliki harga"
    ORDER ||--|{ CART_ITEM : "memuat item"
    CART_ITEM ||--|| SELECTED_PRICE : "menggunakan harga"
    CART_ITEM }o--|| PRODUCT : "mereferensi produk"
    ORDER ||--o| PAYMENT : "dibayar dengan"
    USER ||--o{ ORDER : "memproses pesanan"
```
