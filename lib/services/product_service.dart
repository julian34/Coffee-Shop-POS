import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/products_model.dart';

class ProductService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  // Fetch products from Firestore
  Stream<List<Product>> getProducts({
    String searchQuery = "",
    String category = "All",
  }) {
    // return _db.collection('products').snapshots().map((snapshot) {
    //   print("Fetched ${snapshot.docs.length} products from Firestore");
    //   return snapshot.docs.map((doc) {
    //     print("Product: ${doc.data()}");
    //     return Product.fromFirestore(doc.data(), doc.id);
    //   }).toList();
    return _db.collection('products').snapshots().map((snapshot) {
      List<Product> products =
          snapshot.docs.map((doc) {
            return Product.fromFirestore(doc.data(), doc.id);
          }).toList();

      // 🔍 Search Filtering (case-insensitive)
      if (searchQuery.isNotEmpty) {
        products =
            products.where((product) {
              print("Search-Product: $searchQuery");
              return product.name.toLowerCase().contains(
                searchQuery.toLowerCase(),
              );
            }).toList();
      }

      // 🏷️ Category Filtering
      if (category != "All") {
        products =
            products.where((product) => product.category == category).toList();
      }

      return products;
    });
  }
}
