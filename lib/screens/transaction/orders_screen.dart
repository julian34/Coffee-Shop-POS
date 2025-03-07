import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pos_coffee_shop/screens/transaction/widgets/orders/custom_appbar.dart';
import 'package:pos_coffee_shop/screens/transaction/widgets/orders/bottom_nav_bar.dart';
import 'package:pos_coffee_shop/screens/transaction/widgets/orders/search_bar.dart';
import 'package:pos_coffee_shop/screens/transaction/widgets/orders/category_tab.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});
  @override
  _OrdersWidgetState createState() => _OrdersWidgetState();
}

class _OrdersWidgetState extends State<OrdersScreen> {
  String searchQuery = "";
  String selectedCategory = "Pending";
  List<String> categories = ["Pending", "Checkout", "All"];
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

          CategoryTabWidget(
            categories: categories,
            selectedCategory: selectedCategory,
            onCategorySelected: (category) {
              setState(() {
                selectedCategory = category;
              });
            },
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
