import 'package:flutter/material.dart';
import 'package:pos_coffee_shop/models/cart_model.dart';
import 'package:pos_coffee_shop/services/cart_service.dart';

class CartProvider extends ChangeNotifier {
  final CartService _cartService = CartService();
  final Map<String, CartItem> _items = {};
  String _customerName = 'Guest';

  Map<String, CartItem> get items => _items;
  String get customerName => _customerName;

  double get totalAmount {
    return _items.values.fold(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );
  }

  void updateCustomerName(String name) {
    _customerName = name;
    notifyListeners();
  }

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

  Future<void> saveCart(
    String cartId,
    String customerName, {
    required bool paid,
    required String paymentMode,
  }) async {
    if (_items.isEmpty) {
      print("Cart is empty, not saving.");
      return;
    }
    try {
      await _cartService.saveCart(
        cartId,
        customerName,
        _items.values.toList(),
        totalAmount,
        paid,
        paymentMode,
      );
      _items.clear();
      notifyListeners();

      // Navigator.pop(context);
    } catch (e) {
      print("Error saving cart: $e");
    }
  }

  Future<void> updateCart(
    String cartId,
    String customerName, {
    required bool paid,
    required String paymentMode,
  }) async {
    if (_items.isEmpty) {
      print("Cart is empty, not saving.");
      return;
    }
    try {
      await _cartService.saveCart(
        cartId,
        customerName,
        _items.values.toList(),
        totalAmount,
        paid,
        paymentMode,
      );
      notifyListeners();
      // Navigator.pop(context);
    } catch (e) {
      print("Error saving cart: $e");
    }
  }
}
