import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pos_coffee_shop/models/order_model.dart';

class OrderProvider extends ChangeNotifier {
  List<OrderList> _orders = [];
  List<OrderList> _filteredOrders = [];
  String _searchQuery = '';
  String _statusFilter = 'Pending'; // Default filter

  List<OrderList> get orders => _orders;
  List<OrderList> get filteredOrders => _filteredOrders;
  String get selectedFilter => _statusFilter;

  OrderProvider() {
    loadStatusFilter();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('orders').get();
      _orders =
          snapshot.docs
              .map(
                (doc) => OrderList.fromMap(doc.data() as Map<String, dynamic>),
              )
              .toList();

      applyFilters();
    } catch (e) {
      print("Error fetching orders: $e");
    }
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    applyFilters();
  }

  void updateStatusFilter(String status) {
    _statusFilter = status;
    applyFilters();
  }

  void applyFilters() {
    _filteredOrders =
        _orders.where((order) {
          final matchesSearch =
              order.customerName.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              order.cartId.contains(_searchQuery);
          final matchesStatus =
              _statusFilter == 'All' ||
              (_statusFilter == 'Pending' && !order.isPaid && !order.paid) ||
              (_statusFilter == 'Paid' && order.paid);
          return matchesSearch && matchesStatus;
        }).toList();

    notifyListeners();
  }

  // Save selected filter to SharedPreferences
  Future<void> saveStatusFilter(String status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedFilter', status);
  }

  // Load saved filter from SharedPreferences
  Future<void> loadStatusFilter() async {
    final prefs = await SharedPreferences.getInstance();
    _statusFilter = prefs.getString('selectedFilter') ?? 'Pending';
    notifyListeners();
  }
}
