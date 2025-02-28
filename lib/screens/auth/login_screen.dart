import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/build_textfield.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordContoller = TextEditingController();

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
            ChangeNotifierProvider(
              create: (context) => AuthProvider(),
              child: Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return Padding(
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
                        CustomTextField(
                          hintText: "E-mail",
                          icon: "user.svg",
                          controller: emailController,
                        ),
                        // buildTextField('user.svg', "Email"),
                        const SizedBox(height: 20),
                        CustomTextField(
                          hintText: 'Password',
                          icon: "lock.svg",
                          isPassword: true,
                          controller: passwordContoller,
                        ),
                        // buildTextField('lock.svg', "Password", isPassword: true),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              // await authProvider.signInWithEmail(
                              //   emailController.text,
                              //   passwordContoller.text,
                              // );
                              String? error = await authProvider
                                  .signInWithEmail(
                                    emailController.text,
                                    passwordContoller.text,
                                  );
                              if (error != null) {
                                ScaffoldMessenger.of(
                                  context,
                                ).showSnackBar(SnackBar(content: Text(error)));
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFD18356),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 15),
                            ),
                            child: Text(
                              "Sign In",
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.color4,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: AppColors.color4,
                                thickness: 4,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Text(
                                "or",
                                style: TextStyle(color: Colors.white70),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: AppColors.color4,
                                thickness: 4,
                              ),
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
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
    String icon,
    String hintText, {
    bool isPassword = false,
  }) {
    return TextField(
      obscureText: isPassword,
      style: const TextStyle(color: Colors.black), // Fixed text visibility
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SvgPicture.asset(
            "assets/icons/" + icon,
            color: AppColors.primary,
            height: 20,
            width: 20,
          ),
        ),
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
