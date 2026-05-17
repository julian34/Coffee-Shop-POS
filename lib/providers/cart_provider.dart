import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pos_coffee_shop/models/cart_model.dart';
import 'package:pos_coffee_shop/services/cart_service.dart';

class CartProvider extends ChangeNotifier {
  final CartService _cartService;
  final Map<String, CartItem> _items = {};
  String _customerName = 'Guest';

  CartProvider() : _cartService = CartService();

  /// Named constructor untuk unit testing — menerima CartService yang telah di-inject.
  @visibleForTesting
  CartProvider.forTest({required CartService cartService})
    : _cartService = cartService;

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
    // Generate a unique key by combining productId and price label
    final uniqueKey = '${item.productId}-${item.label}';
    if (_items.containsKey(uniqueKey)) {
      // If item already exists, update its quantity
      print('update chackout');
      // _items.update(
      //   uniqueKey,
      //   (existingItem) => existingItem.copyWith(
      //     quantity: existingItem.quantity + item.quantity,
      //   ),
      // );
    } else {
      print('update order');
      // If item does not exist, add a new entry
      _items[uniqueKey] = item.copyWith(quantity: item.quantity);
    }

    notifyListeners();

    // Find an existing item with the same productId AND selectedPrice
    // final existingKey = _items.keys.firstWhere(
    //   (key) =>
    //       _items[key]!.productId == item.productId &&
    //       _items[key]!.selectedPrice == item.selectedPrice,
    //   orElse: () => '',
    // );
    // if (existingKey.isNotEmpty) {
    //   _items.update(
    //     existingKey,
    //     (existingItem) => CartItem(
    //       productId: existingItem.productId,
    //       name: existingItem.name,
    //       price: existingItem.price,
    //       selectedPrice: item.selectedPrice,
    //       label: existingItem.label,
    //       quantity: existingItem.quantity + 1,
    //       image: existingItem.image,
    //     ),
    //   );
    //   // _items[item.productId]!.quantity += 1;
    // } else {
    //   // _items.putIfAbsent(
    //   //   item.uniqueKey,
    //   //   () => CartItem(
    //   //     productId: item.productId,
    //   //     name: item.name,
    //   //     price: item.price,
    //   //     label: item.label,
    //   //     selectedPrice: item.selectedPrice,
    //   //     quantity: 1,
    //   //     image: item.image,
    //   //   ),
    //   // );
    //   // _items[item.uniqueKey] = item;
    //   final uniqueKey =
    //       '${item.productId}_${DateTime.now().millisecondsSinceEpoch}';
    //   _items[uniqueKey] = item;
    // }
    // notifyListeners();
  }

  void updateQuantity(String uniqueKey, int newQuantity) {
    print("$uniqueKey - $newQuantity");

    if (_items.containsKey(uniqueKey) && newQuantity > 0) {
      print('update Quantity $uniqueKey');
      _items.update(
        uniqueKey,
        (existingItem) => CartItem(
          productId: existingItem.productId,
          name: existingItem.name,
          price: existingItem.price,
          label: existingItem.label,
          selectedPrice: existingItem.selectedPrice,
          quantity: newQuantity,
          image: existingItem.image,
        ),
      );
      print('update ${_items.values.isNotEmpty}');
      //   // _items[productId]!.quantity += 1;
    } else {
      print('remove');
      _items.remove(uniqueKey);
    }
    notifyListeners();
  }

  void removeItem(String uniqueKey) {
    if (_items.containsKey(uniqueKey)) {
      print('remove $uniqueKey');
      _items.remove(uniqueKey);
      notifyListeners();
    }
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
