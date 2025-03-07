import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:pos_coffee_shop/core/theme.dart';
import 'package:pos_coffee_shop/screens/transaction/widgets/orders/custom_appbar.dart';
import 'package:pos_coffee_shop/screens/transaction/widgets/orders/bottom_nav_bar.dart';
import 'package:pos_coffee_shop/screens/transaction/widgets/orders/search_bar.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});
  @override
  _OrdersWidgetState createState() => _OrdersWidgetState();
}

class _OrdersWidgetState extends State<OrdersScreen> {
  String searchQuery = "";
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: const OrderAppbar(),
      ),
      body: ListView(
        children: [
          SearchBarWidget(
            onSearch: (query) {
              setState(() {
                searchQuery = query;
              });
            },
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
