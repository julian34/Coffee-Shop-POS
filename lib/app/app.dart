import 'package:flutter/material.dart';

import 'package:pos_coffee_shop/app/app_providers.dart';
import 'package:pos_coffee_shop/app/app_theme.dart';
import 'package:pos_coffee_shop/core/routes.dart';

class CoffeeShopPOSApp extends StatelessWidget {
  const CoffeeShopPOSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppProviders(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Coffee POS',
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}
