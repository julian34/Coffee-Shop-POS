import 'package:flutter/material.dart';
import 'package:pos_coffee_shop/models/order_model.dart';
import 'package:pos_coffee_shop/screens/transaction/widgets/payment/bottom_nav_bar.dart';
import 'package:pos_coffee_shop/screens/transaction/widgets/payment/custom_appbar.dart';

class PaymentScreen extends StatelessWidget {
  final OrderList? orderList;
  const PaymentScreen({super.key, this.orderList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: CustomAppbar(cartId: orderList!.cartId),
      ),
      body: Column(),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
