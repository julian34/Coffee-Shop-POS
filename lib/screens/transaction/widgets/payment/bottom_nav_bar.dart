import 'package:flutter/material.dart';
import 'package:pos_coffee_shop/core/routes.dart';
import 'package:pos_coffee_shop/core/theme.dart';
import 'package:pos_coffee_shop/models/order_model.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 5.0,
      color: AppColors.color3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: Text(
              'Submit',
              style: TextStyle(
                fontSize: 20,
                color: AppColors.color5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
