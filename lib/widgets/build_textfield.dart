import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../core/theme.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final String icon;
  final bool isPassword;
  final TextEditingController controller;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.icon,
    this.isPassword = false,
    required this.controller,
  });

  @override
  Widget build(BuildContext Contex) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: AppColors.color3),
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.all(10),
          child: SvgPicture.asset(
            "assets/icons/" + icon,
            color: AppColors.primary,
            height: 20,
            width: 20,
          ),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(color: AppColors.color3),
        filled: true,
        fillColor: AppColors.color5,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.color4),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}
