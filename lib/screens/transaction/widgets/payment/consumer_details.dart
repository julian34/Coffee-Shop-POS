import 'package:flutter/material.dart';
import 'package:pos_coffee_shop/core/theme.dart';
import 'package:pos_coffee_shop/untils/format_utils.dart';
import 'package:provider/provider.dart';
import 'package:pos_coffee_shop/providers/cart_provider.dart';

class ConsumerDetailsTab extends StatelessWidget {
  final String customerName;
  final double totalAmount;
  const ConsumerDetailsTab({
    super.key,
    required this.customerName,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8.0),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.color3,
              borderRadius: BorderRadius.circular(40),
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgCustomApp.getIcon('user'),
                SizedBox(width: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Customer',
                      textAlign: TextAlign.left,
                      style: TextStyle(color: AppColors.color5),
                    ),
                    Text(
                      customerName,
                      style: TextStyle(
                        color: AppColors.color5,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
                Spacer(flex: 1),
                Row(
                  children: [
                    Text(
                      "Total :",
                      style: TextStyle(
                        color: AppColors.color5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  children: [
                    Text(
                      formatCurrency(totalAmount),
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
        // BoxEditConsumer()
        // TextField();
      },
    );
  }
}
