import 'package:flutter/material.dart';
import 'package:pos_coffee_shop/core/theme.dart';
import 'package:pos_coffee_shop/models/order_model.dart';
import 'package:pos_coffee_shop/screens/transaction/widgets/payment/bottom_nav_bar.dart';
import 'package:pos_coffee_shop/screens/transaction/widgets/payment/consumer_details.dart';
import 'package:pos_coffee_shop/screens/transaction/widgets/payment/custom_appbar.dart';
import 'package:pos_coffee_shop/screens/transaction/widgets/payment/list_products.dart';

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ConsumerDetailsTab(
            customerName: orderList!.customerName,
            totalAmount: orderList!.totalAmount,
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Ordered",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                ),
                Divider(color: AppColors.color3),
              ],
            ),
          ),
          Flexible(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: ListProducts(orderItems: orderList!.items),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
