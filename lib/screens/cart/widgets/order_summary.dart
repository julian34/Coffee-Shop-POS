import 'package:flutter/material.dart';
import 'package:pos_coffee_shop/core/theme.dart';

class OrderSummaryTab extends StatefulWidget {
  const OrderSummaryTab({super.key});

  @override
  _OrderSummaryTabWidgetState createState() => _OrderSummaryTabWidgetState();
}

class _OrderSummaryTabWidgetState extends State<OrderSummaryTab> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.color2,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Order Summary',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Divider(color: AppColors.primary),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Item total',
                    style: TextStyle(color: AppColors.primary),
                  ),
                  Text(
                    'Rp. 100.000,-',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Discount', style: TextStyle(color: AppColors.primary)),
                  Text('-', style: TextStyle(color: AppColors.primary)),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Tax', style: TextStyle(color: AppColors.primary)),
                  Text('-', style: TextStyle(color: AppColors.primary)),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Divider(color: AppColors.primary),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Rp. 100.000,-',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
