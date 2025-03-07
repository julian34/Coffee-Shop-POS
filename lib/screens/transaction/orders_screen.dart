import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pos_coffee_shop/screens/transaction/widgets/orders/custom_appbar.dart';
import 'package:pos_coffee_shop/screens/transaction/widgets/orders/bottom_nav_bar.dart';
import 'package:pos_coffee_shop/screens/transaction/widgets/orders/orders_items.dart';
import 'package:pos_coffee_shop/screens/transaction/widgets/orders/search_bar.dart';
import 'package:pos_coffee_shop/screens/transaction/widgets/orders/category_tab.dart';

import 'package:pos_coffee_shop/providers/orders_provider.dart';
import 'package:pos_coffee_shop/models/order_model.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});
  @override
  _OrdersWidgetState createState() => _OrdersWidgetState();
}

class _OrdersWidgetState extends State<OrdersScreen> {
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<OrderProvider>(context, listen: false).fetchOrders();
    });
  }

  void _onSearchChanged(String query) {
    Provider.of<OrderProvider>(context, listen: false).updateSearchQuery(query);
  }

  void _onFilterChanged(String filter) {
    Provider.of<OrderProvider>(
      context,
      listen: false,
    ).updateStatusFilter(filter);
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: const OrderAppbar(),
      ),
      body: Column(
        children: [
          SearchBarWidget(
            controller: _searchController,
            onChanged: _onSearchChanged,
          ),
          CategoryTabWidget(
            onFilterChanged: _onFilterChanged,
            selectedFilter: 'Pending',
          ),
          // OrdersItemsWidget()
        ],
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
