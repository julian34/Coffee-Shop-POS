import 'package:firebase_core/firebase_core.dart';

import 'package:pos_coffee_shop/firebase_options.dart';

class AppInitializer {
  const AppInitializer._();

  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
