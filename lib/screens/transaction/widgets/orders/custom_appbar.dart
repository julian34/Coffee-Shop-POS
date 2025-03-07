import 'package:flutter/material.dart';
import 'package:pos_coffee_shop/core/theme.dart';

class OrderAppbar extends StatelessWidget {
  const OrderAppbar({super.key});
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.color3,
      toolbarHeight: 100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(110),
          bottomRight: Radius.circular(100),
        ),
      ),
      leading: Container(
        padding: EdgeInsets.only(left: 30),
        child: IconButton(
          padding: EdgeInsets.symmetric(vertical: 10),
          onPressed: () => Navigator.of(context).pop(),
          icon: SvgCustomApp.getIcon('arrow-left'),
        ),
      ),
      centerTitle: true,
      title: Text(
        "Order List",
        style: TextStyle(
          fontSize: 30,
          color: AppColors.color5,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        Container(
          padding: EdgeInsets.only(right: 30),
          child: SvgCustomApp.getIcon('info'),
        ),
      ],
    );
  }
}
