import 'package:flutter/material.dart';

import 'package:pos_coffee_shop/models/cart_model.dart';
import 'package:pos_coffee_shop/services/cart_service.dart';

class CartProvider extends ChangeNotifier {
  final CartService _cartService = CartService();

  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => _items;

  void addToCart(CartItem item) {
    if (_items.containsKey(item.productId)) {
      _items.update(
        item.productId,
        (existingItem) => CartItem(
          productId: existingItem.productId,
          name: existingItem.name,
          price: existingItem.price,
          quantity: existingItem.quantity + 1,
          image: existingItem.image,
        ),
      );
      // _items[item.productId]!.quantity += 1;
    } else {
      _items.putIfAbsent(
        item.productId,
        () => CartItem(
          productId: item.productId,
          name: item.name,
          price: item.price,
          quantity: 1,
          image: item.image,
        ),
      );
      // _items[item.productId] = item;
    }
    notifyListeners();
  }

  void updateQuantity(String productId, int newQuantity) {
    if (_items.containsKey(productId) && newQuantity > 0) {
      _items.update(
        productId,
        (existingItem) => CartItem(
          productId: existingItem.productId,
          name: existingItem.name,
          price: existingItem.price,
          quantity: newQuantity,
          image: existingItem.image,
        ),
      );
      // _items[productId]!.quantity += 1;
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }
}
