import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class ManagerHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Manager Dashboard")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome, Manager!"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => authProvider.signOut(),
              child: Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
