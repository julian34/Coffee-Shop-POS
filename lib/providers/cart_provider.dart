import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _cart = [];

  List<Map<String, dynamic>> get cart => _cart;

  void addToCart(Map<String, dynamic> product) {
    _cart.add(product);
    notifyListeners();
  }

  void removeFromCart(int index) {
    _cart.removeAt(index);
    notifyListeners();
  }

  double get total => _cart.fold(0, (sum, item) => sum + item['price']);
}
