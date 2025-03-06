import 'package:flutter/material.dart';
import '../../../../core/theme.dart';

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      notchMargin: 5.0,
      color: AppColors.color3,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          child: Text(
            "Prosess Order",
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
