import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../core/theme.dart';
import '../../models/cashier/appbarselected.dart';

class CashierAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.color3,
      toolbarHeight: 100,
      automaticallyImplyLeading: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(110),
          bottomRight: Radius.circular(110),
        ),
      ),
      title: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          String username = authProvider.user?.name ?? "User";
          String role = authProvider.user?.role ?? "Role";
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgCustomApp.getIcon("user"),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$username",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.color2,
                            ),
                          ),
                          Text(
                            "$role",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.color2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgCustomApp.getIcon("marker", c: AppColors.color2),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Coffee Shop name",
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.color2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      actions: <Widget>[
        Column(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 15),
              child: PopupMenuButton<int>(
                icon: SvgCustomApp.getIcon('menu-burger', h: 30),
                color: AppColors.primary,
                onSelected:
                    (item) => AppBarSelectItem(context, item, AuthProvider()),
                itemBuilder:
                    (context) => [
                      PopupMenuItem<int>(
                        value: 0,
                        child: Row(
                          children: [
                            SvgCustomApp.getIcon(
                              'user',
                              c: AppColors.color4,
                              h: 15,
                              w: 15,
                            ),
                            const SizedBox(width: 5.0),
                            Text(
                              'Profile',
                              style: TextStyle(
                                color: AppColors.color2,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuDivider(),
                      PopupMenuItem<int>(
                        value: 1,
                        child: Row(
                          children: [
                            SvgCustomApp.getIcon(
                              'sign-out-alt',
                              c: AppColors.color4,
                              h: 15,
                              w: 15,
                            ),
                            const SizedBox(width: 5.0),
                            Text(
                              'Logout',
                              style: TextStyle(
                                color: AppColors.color2,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
