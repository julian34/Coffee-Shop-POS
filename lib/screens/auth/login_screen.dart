import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color3,
      body: Stack(
        children: [
          // Positioned.fill(
          //   child: Container(color: Colors.black.withOpacity(0.6)),
          // ),
          Positioned.fill(
            bottom: 400,
            child: ClipPath(
              clipper: CustomClipPath(),
              child: Image.asset(
                'assets/images/coffee_bg.png',
                fit: BoxFit.cover,
              ),
            ),
          ),

          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.6)),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(
    IconData icon,
    String hintText, {
    bool isPassword = false,
  }) {
    return TextField(
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Color(0xFFD18356)),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white70),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white54),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFD18356)),
        ),
      ),
    );
  }
}

// Custom Clipper for Curved Shape
class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height;
    final path = Path();
    path.lineTo(0, h - 100);
    path.quadraticBezierTo(w / 30, h / 2, w / 2, h / 2);
    path.quadraticBezierTo(w, h / 2, w / 2, h / 2);
    path.quadraticBezierTo(w, h / 2, w, (h / 2) - 50);
    path.lineTo(w, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
