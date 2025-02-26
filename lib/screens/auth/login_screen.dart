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
          Positioned.fill(
            bottom: 300,
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

          Positioned(
            top: 90,
            left: 30,
            right: 30,
            child: Text(
              "The best ideas start with a cup of coffee and a quiet moment.",
              style: AppFonts.qoute,
            ),
          ),

          Positioned(
            top: 230,
            left: 25,
            right: 25,
            child: Center(
              child: Text(
                "The best ideas start with a cup of coffee and a quiet moment.",
                style: AppFonts.sub_qoute,
                textAlign: TextAlign.center,
              ),
            ),
          ),

          Positioned(
            top: 320,
            left: 60,
            right: 60,
            child: Container(
              margin: EdgeInsets.only(top: 50),
              // decoration: const BoxDecoration(color: AppColors.primary),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sign In",
                    style: GoogleFonts.lato(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    height: 4,
                    width: 66,
                    color: AppColors.primary, // Accent color for underline
                    margin: EdgeInsets.only(top: 4, bottom: 20),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 60),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 100),
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person, color: AppColors.primary),
                      hintText: 'Email',
                      hintStyle: TextStyle(
                        color: AppColors.color4,
                        fontWeight: FontWeight.bold,
                      ),
                      filled: true,
                      fillColor: AppColors.color3,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.color4),
                      ),
                    ),
                    style: TextStyle(
                      color: AppColors.color4,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock, color: AppColors.primary),
                      hintText: 'Password',
                      hintStyle: TextStyle(
                        color: AppColors.color4,
                        fontWeight: FontWeight.bold,
                      ),
                      filled: true,
                      fillColor: AppColors.color3,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.color4),
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: const [
                      Expanded(
                        child: Divider(color: Colors.white70, thickness: 1),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'or',
                          style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(color: Colors.white70, thickness: 1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: () {},
                      child: Column(
                        children: [
                          Icon(
                            Icons.g_mobiledata,
                            size: 48,
                            color: Color(0xFFD38B5D),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
    path.quadraticBezierTo(w / 30, h / 2, w / 2.5, h / 2);
    path.quadraticBezierTo(w, h / 2, w / 2, h / 2);
    path.quadraticBezierTo(w, h / 2, w, (h / 2) - 50);
    path.lineTo(w, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
