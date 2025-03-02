import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/products_model.dart';

class ProductService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  // Fetch products from Firestore
  Stream<List<Product>> getProducts() {
    return _db.collection('products').snapshots().map((snapshot) {
      print("Fetched ${snapshot.docs.length} products from Firestore");
      return snapshot.docs.map((doc) {
        print("Product: ${doc.data()}");
        return Product.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }
}
