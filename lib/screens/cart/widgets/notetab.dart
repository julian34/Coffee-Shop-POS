import 'package:flutter/material.dart';
import 'package:pos_coffee_shop/core/theme.dart';

class NoteTab extends StatefulWidget {
  const NoteTab({super.key});

  @override
  _NoteTabWidgetState createState() => _NoteTabWidgetState();
}

class _NoteTabWidgetState extends State<NoteTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order Menu',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Sora',
                ),
              ),
              Container(
                child: ElevatedButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      SvgCustomApp.getIcon("notebook", c: AppColors.color3),
                      SizedBox(width: 10),
                      Text(
                        "Add Note",
                        style: TextStyle(color: AppColors.color3),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }
}
