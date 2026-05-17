import 'package:flutter/material.dart';

import 'app_providers.dart';
import 'app_theme.dart';
import 'routes.dart';

class CoffeeShopPOSApp extends StatelessWidget {
  final String initialRoute;

  const CoffeeShopPOSApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return AppProviders(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Coffee POS',
        theme: AppTheme.lightTheme,
        initialRoute: initialRoute,
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}
