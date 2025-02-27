import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color3,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 400,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/login_bg.png'),
                  fit: BoxFit.fill,
                ),
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 100, // Added top positioning
                    left: 20,
                    right: 20,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "The best ideas start with a cup of coffee and a quiet moment.",
                            style: AppFonts.qoute,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Thank you for being here—let's make today unforgettable.",
                            style: AppFonts.sub_qoute,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 30),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Sign In",
                      style: GoogleFonts.sora(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.color4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  buildTextField(Icons.person_rounded, "Username"),
                  const SizedBox(height: 20),
                  buildTextField(
                    Icons.lock_rounded,
                    "Password",
                    isPassword: true,
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFD18356),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: Text(
                        "Sign In",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(color: Colors.white54, thickness: 1),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "or",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                      Expanded(
                        child: Divider(color: Colors.white54, thickness: 1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      'assets/icons/icons8-google.svg',
                      semanticsLabel: 'Google Logo Sign In',
                      height: 30,
                      width: 30,
                      color: AppColors.primary,
                    ),
                  ),
                  // SvgPicture.asset(
                  //   'assets/icons/icons8-google.svg',
                  //   color: AppColors.primary,
                  // ),
                  // IconButton(
                  //   onPressed: () {},
                  //   icon: Icon(
                  //     Icons.g_mobiledata_rounded,
                  //     size: 40,
                  //     color: Colors.white,
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
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
      style: const TextStyle(color: Colors.black), // Fixed text visibility
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Color(0xFFD18356)),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.black54,
        ), // Adjusted hint color
        filled: true, // Ensures background color is applied
        fillColor: Colors.white, // Matches form background
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFD18356)),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}

// Fixed Custom Clipper for Better Rendering
class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height;
    final path = Path();
    path.lineTo(0, h - 100);
    path.quadraticBezierTo(w * 0.25, h, w * 0.5, h - 50);
    path.quadraticBezierTo(w * 0.75, h - 100, w, h - 50);
    path.lineTo(w, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
