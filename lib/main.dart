import 'package:flutter/material.dart';

import 'package:pos_coffee_shop/app/app.dart';
import 'package:pos_coffee_shop/app/app_initializer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppInitializer.initialize();

  runApp(const CoffeeShopPOSApp());
}
