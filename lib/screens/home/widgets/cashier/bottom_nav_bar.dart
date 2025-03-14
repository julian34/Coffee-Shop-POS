import 'package:flutter/material.dart';
import 'package:pos_coffee_shop/core/routes.dart';
import 'package:pos_coffee_shop/core/theme.dart';

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
          // IconButton(icon: Icon(Icons.home), onPressed: () {}),
          // IconButton(icon: Icon(Icons.receipt), onPressed: () {}),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 50),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: SvgCustomApp.getIcon('home'),
                    ),
                    // Text("Home", style: AppFonts.navBarText),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 70),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.order);
                      },
                      icon: SvgCustomApp.getIcon(
                        'receipt',
                        c: AppColors.color4,
                      ),
                    ),
                    // Text("Orders List", style: AppFonts.navBarText),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
