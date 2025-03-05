import 'package:flutter/material.dart';
import '../models/cart_model.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  bool _isEditingCN = false;

  List<CartItem> get items => _items;

  bool get isCartEmpty => _items.isEmpty;
  bool get isEditingCN => _isEditingCN;

  void showtEditingCN() {
    print("Show Editing CN");
    _isEditingCN = true;
    notifyListeners();
  }

  void submitEditingCN() {
    _isEditingCN = false;
    notifyListeners();
  }

  void addToCart(CartItem item) {
    int index = _items.indexWhere((cartItem) => cartItem.id == item.id);
    if (index != -1) {
      _items[index].quantity += 1;
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  void updateQuantity(String itemId, int quantity) {
    int index = _items.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      if (quantity > 0) {
        _items[index].quantity = quantity;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void removeFromCart(String itemId) {
    _items.removeWhere((item) => item.id == itemId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
