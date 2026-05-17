// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/theme.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/build_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin(AuthProvider authProvider) async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email and password are required.')),
      );
      return;
    }

    final String? error = await authProvider.signInWithEmail(email, password);

    if (!mounted) return;

    if (error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    final user = authProvider.user;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User data is not available.')),
      );
      return;
    }

    authProvider.navigateBasedOnRole(context, user.role);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color3,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 400,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/login_bg.png'),
                  fit: BoxFit.fill,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 100,
                    left: 20,
                    right: 20,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'The best ideas start with a cup of coffee and a quiet moment.',
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

            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(30, 10, 30, 30),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Sign In',
                          style: GoogleFonts.sora(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppColors.color4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      CustomTextField(
                        hintText: 'E-mail',
                        icon: 'user.svg',
                        controller: emailController,
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        hintText: 'Password',
                        icon: 'lock.svg',
                        isPassword: true,
                        controller: passwordController,
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _handleLogin(authProvider),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD18356),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: Text(
                            'Sign In',
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
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              'or',
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
          ],
        ),
      ),
    );
  }
}
