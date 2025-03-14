import 'package:flutter/material.dart';
import 'package:pos_coffee_shop/core/theme.dart';

class BodyCartEmpty extends StatelessWidget {
  const BodyCartEmpty({super.key});

  @override
  Widget build(BuildContext contex) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("assets/images/none_items.png"),
        SizedBox(height: 10),
        Text(
          "Cart is empty",
          style: TextStyle(
            fontSize: 20,
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
