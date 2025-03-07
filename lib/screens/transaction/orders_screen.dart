import 'package:flutter/material.dart';
import 'package:pos_coffee_shop/screens/transaction/widgets/orders/custom_appbar.dart';
import 'package:pos_coffee_shop/screens/transaction/widgets/orders/bottom_nav_bar.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: const OrderAppbar(),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
