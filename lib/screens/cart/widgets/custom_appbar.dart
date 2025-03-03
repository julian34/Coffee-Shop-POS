import 'package:flutter/material.dart';
import '../../../core/theme.dart';

class CartAppbar extends StatelessWidget {
  const CartAppbar({super.key});

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
          onPressed: () => Navigator.of(context).pop(),
          icon: SvgCustomApp.getIcon('arrow-left'),
        ),
      ),
      centerTitle: true,
      title: Text(
        "Cart",
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
