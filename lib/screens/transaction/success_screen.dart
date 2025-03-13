import 'package:flutter/material.dart';
import 'package:pos_coffee_shop/models/payment_model.dart';
import 'package:pos_coffee_shop/screens/transaction/widgets/payment/bottom_nav_bar.dart';
import 'package:pos_coffee_shop/screens/transaction/widgets/success/custom_appbar.dart';

class SuccessScreen extends StatelessWidget {
  final Payment? payment;

  const SuccessScreen({super.key, this.payment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: CustomAppbar(),
      ),
      body: Column(children: [Text('Success Payment')]),
      // bottomNavigationBar: BottomNavBar(onPayPressed: onPayPressed),
    );
  }
}
