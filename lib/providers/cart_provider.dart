import 'package:flutter/material.dart';

import 'package:pos_coffee_shop/models/cart_model.dart';
import 'package:pos_coffee_shop/services/cart_service.dart';

class CartProvider extends ChangeNotifier {
  final CartService _cartService = CartService();

  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => _items;

  void addToCart(CartItem item) {
    if (_items.containsKey(item.productId)) {
      _items[item.productId]!.quantity += 1;
    } else {
      _items[item.productId] = item;
    }
    notifyListeners();
  }

  void updateQuantity() {}

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }
}
