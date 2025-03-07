import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pos_coffee_shop/models/order_model.dart';

class OrderProvider extends ChangeNotifier {
  List<OrderList> _orders = [];
  List<OrderList> _filteredOrders = [];
  String _searchQuery = '';
  String _statusFilter = 'Pending'; // Default filter

  List<OrderList> get orders => _orders;
  List<OrderList> get filteredOrders => _filteredOrders;

  OrderProvider() {
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
              order.idOrder.contains(_searchQuery);
          final matchesStatus =
              _statusFilter == 'All' ||
              (_statusFilter == 'Pending' && !order.isPaid) ||
              (_statusFilter == 'Paid' && order.isPaid);

          return matchesSearch && matchesStatus;
        }).toList();

    notifyListeners();
  }
}
