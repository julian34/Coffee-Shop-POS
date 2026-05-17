import 'package:flutter/foundation.dart';
import 'package:pos_coffee_shop/models/cart_model.dart';
import 'package:pos_coffee_shop/services/cart_service.dart';

class CartProvider extends ChangeNotifier {
  static const String _defaultCustomerName = 'Guest';
  static const String _emptyCartMessage = 'Cart is empty. No data was saved.';
  static const String _saveCartFailedMessage = 'Failed to save cart.';

  final CartService _cartService;
  final Map<String, CartItem> _items = {};

  String _customerName = _defaultCustomerName;
  bool _isSaving = false;
  String? _errorMessage;

  CartProvider({CartService? cartService})
    : _cartService = cartService ?? CartService();

  /// Named constructor untuk unit testing.
  ///
  /// Constructor ini dipertahankan agar struktur refactor tetap mendukung
  /// dependency injection tanpa menambah file baru.
  @visibleForTesting
  CartProvider.forTest({required CartService cartService})
    : _cartService = cartService;

  Map<String, CartItem> get items => Map.unmodifiable(_items);

  List<CartItem> get itemList => List.unmodifiable(_items.values);

  String get customerName => _customerName;

  bool get isSaving => _isSaving;

  String? get errorMessage => _errorMessage;

  bool get isEmpty => _items.isEmpty;

  bool get isNotEmpty => _items.isNotEmpty;

  int get totalItems {
    return _items.values.fold(0, (total, item) => total + item.quantity);
  }

  double get totalAmount {
    return _items.values.fold(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );
  }

  void updateCustomerName(String name) {
    final String trimmedName = name.trim();

    _customerName = trimmedName.isEmpty ? _defaultCustomerName : trimmedName;

    notifyListeners();
  }

  void addToCart(CartItem item) {
    if (!_isValidCartItem(item)) {
      _setError('Invalid cart item.');
      return;
    }

    final String uniqueKey = _getItemKey(item);
    final CartItem? existingItem = _items[uniqueKey];

    if (existingItem == null) {
      _items[uniqueKey] = item.copyWith(
        quantity: _normalizeQuantity(item.quantity),
      );
    } else {
      _items[uniqueKey] = existingItem.copyWith(
        quantity: existingItem.quantity + _normalizeQuantity(item.quantity),
      );
    }

    _clearError();
    notifyListeners();
  }

  void updateQuantity(String uniqueKey, int newQuantity) {
    if (!_items.containsKey(uniqueKey)) return;

    if (newQuantity <= 0) {
      removeItem(uniqueKey);
      return;
    }

    _items[uniqueKey] = _items[uniqueKey]!.copyWith(quantity: newQuantity);

    _clearError();
    notifyListeners();
  }

  void increaseQuantity(String uniqueKey) {
    final CartItem? item = _items[uniqueKey];
    if (item == null) return;

    updateQuantity(uniqueKey, item.quantity + 1);
  }

  void decreaseQuantity(String uniqueKey) {
    final CartItem? item = _items[uniqueKey];
    if (item == null) return;

    updateQuantity(uniqueKey, item.quantity - 1);
  }

  void removeItem(String uniqueKey) {
    if (!_items.containsKey(uniqueKey)) return;

    _items.remove(uniqueKey);
    _clearError();
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _customerName = _defaultCustomerName;
    _clearError();
    notifyListeners();
  }

  Future<void> saveCart(
    String cartId,
    String customerName, {
    required bool paid,
    required String paymentMode,
  }) async {
    await _persistCart(
      cartId,
      customerName,
      paid: paid,
      paymentMode: paymentMode,
      clearAfterSave: true,
    );
  }

  Future<void> updateCart(
    String cartId,
    String customerName, {
    required bool paid,
    required String paymentMode,
  }) async {
    await _persistCart(
      cartId,
      customerName,
      paid: paid,
      paymentMode: paymentMode,
      clearAfterSave: false,
    );
  }

  Future<void> _persistCart(
    String cartId,
    String customerName, {
    required bool paid,
    required String paymentMode,
    required bool clearAfterSave,
  }) async {
    if (!_canSaveCart(cartId)) return;

    _setSavingState(true);

    try {
      await _cartService.saveCart(
        cartId.trim(),
        _resolveCustomerName(cartId, customerName),
        _items.values.toList(),
        totalAmount,
        paid,
        paymentMode.trim(),
      );

      if (clearAfterSave) {
        _items.clear();
        _customerName = _defaultCustomerName;
      }

      _clearError();
    } catch (error) {
      _setError('$_saveCartFailedMessage ${error.toString()}');
    } finally {
      _setSavingState(false);
    }
  }

  bool _canSaveCart(String cartId) {
    if (cartId.trim().isEmpty) {
      _setError('Cart id cannot be empty.');
      return false;
    }

    if (_items.isEmpty) {
      _setError(_emptyCartMessage);
      return false;
    }

    return true;
  }

  bool _isValidCartItem(CartItem item) {
    return item.productId.trim().isNotEmpty &&
        item.name.trim().isNotEmpty &&
        item.price >= 0 &&
        item.quantity > 0;
  }

  String _getItemKey(CartItem item) {
    return item.uniqueKey;
  }

  int _normalizeQuantity(int quantity) {
    return quantity <= 0 ? 1 : quantity;
  }

  String _resolveCustomerName(String cartId, String customerName) {
    final String trimmedCustomerName = customerName.trim();

    if (trimmedCustomerName.isEmpty ||
        trimmedCustomerName == _defaultCustomerName) {
      return cartId.trim();
    }

    return trimmedCustomerName;
  }

  void _setSavingState(bool value) {
    _isSaving = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }
}
