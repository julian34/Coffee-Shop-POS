import 'package:flutter/material.dart';
import 'package:pos_coffee_shop/core/theme.dart';

class OrderSummaryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
          Divider(color: AppColors.primary),
        ],
      ),
    );
  }

  // Widget _buildSummaryRow(String title, double value, {bool isBold = false}) {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(horizontal: 30, vertical: 4),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Text(
  //           title,
  //           style: TextStyle(
  //             color: AppColors.primary,
  //             fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
  //             fontSize: isBold ? 12 : 12,
  //           ),
  //         ),
  //         Text(
  //           "Rp. ${value.toStringAsFixed(2)}",
  //           style: TextStyle(
  //             color: AppColors.primary,
  //             fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
  //             fontSize: isBold ? 12 : 12,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
