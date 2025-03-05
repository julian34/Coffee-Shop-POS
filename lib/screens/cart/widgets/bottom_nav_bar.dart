import 'package:flutter/material.dart';
import '../../../../core/theme.dart';

class BottomNavBar extends StatelessWidget {
  final bool isCartEmpty;
  const BottomNavBar({super.key, required this.isCartEmpty});
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      notchMargin: 5.0,
      color: AppColors.color3,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: ElevatedButton(
          onPressed: isCartEmpty ? null : () {},
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          child: Text(
            isCartEmpty ? 'Please select some item' : "Prosess Order",
            style: TextStyle(
              fontSize: 20,
              color: AppColors.color4,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
