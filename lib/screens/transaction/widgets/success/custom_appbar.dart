import 'package:flutter/material.dart';
import 'package:pos_coffee_shop/core/theme.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.color3,
      toolbarHeight: 100,
      automaticallyImplyLeading: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(110),
          bottomRight: Radius.circular(100),
        ),
      ),
      centerTitle: true,
      title: Column(
        children: [
          Text(
            'Payment',
            style: TextStyle(
              fontSize: 30,
              color: AppColors.color5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
