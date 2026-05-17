import 'package:flutter_test/flutter_test.dart';
import 'package:pos_coffee_shop/main.dart';

import 'package:pos_coffee_shop/app/app.dart'; // bukan main.dart

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app with a default initial route and trigger a frame.
    await tester.pumpWidget(const CoffeeShopPOSApp()); // hapus initialRoute
  });
}
