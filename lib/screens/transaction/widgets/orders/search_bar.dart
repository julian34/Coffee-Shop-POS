import 'package:flutter/material.dart';
import 'package:pos_coffee_shop/core/theme.dart';

class SearchBarWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  _SearchBarWidgetState createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
        controller: widget.controller,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.color5,
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 15),
            child: SvgCustomApp.getIcon('search', h: 20),
          ),
          prefixIconConstraints: BoxConstraints(maxWidth: 50, maxHeight: 50),
          hintText: "Search",
          hintStyle: TextStyle(color: AppColors.primary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
