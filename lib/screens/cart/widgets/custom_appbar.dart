import 'package:flutter/material.dart';
import 'package:pos_coffee_shop/core/theme.dart';

class CartAppbar extends StatelessWidget {
  final VoidCallback onPressed;
  final String titleScreen;
  const CartAppbar({
    Key? key,
    required this.onPressed,
    required this.titleScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.color3,
      toolbarHeight: 100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(110),
          bottomRight: Radius.circular(110),
        ),
      ),
      leading: Container(
        padding: EdgeInsets.only(left: 30),
        child: IconButton(
          padding: EdgeInsets.symmetric(vertical: 10),
          onPressed: onPressed,
          icon: SvgCustomApp.getIcon('arrow-left'),
        ),
      ),
      centerTitle: true,
      title: Text(
        titleScreen,
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
