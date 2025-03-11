import 'package:flutter/material.dart';
import 'package:pos_coffee_shop/core/routes.dart';
import 'package:pos_coffee_shop/core/theme.dart';

class CartAppbar extends StatelessWidget {
  final VoidCallback onPressed;
  final String titleScreen;
  final String cartId;
  final existing;
  const CartAppbar({
    Key? key,
    required this.onPressed,
    required this.titleScreen,
    required this.cartId,
    this.existing,
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
      title: Column(
        children: [
          Text(
            titleScreen,
            style: TextStyle(
              fontSize: 30,
              color: AppColors.color5,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (titleScreen == "Checkout")
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                "No. ${cartId}",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.color5,
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
      actions: [
        Container(
          padding: EdgeInsets.only(right: 30),
          child:
              cartId.isNotEmpty
                  ? IconButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.cashierHome,
                        arguments: existing,
                      );
                    },
                    icon: SvgCustomApp.getIcon('add'),
                  )
                  : SvgCustomApp.getIcon('info'),
        ),
      ],
    );
  }
}
