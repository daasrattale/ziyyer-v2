import 'package:flutter/material.dart';
import 'package:ziyyer/config/theme.dart';

class DemoScreen extends StatelessWidget {
  final String title;
  final IconData iconData;
  const DemoScreen({super.key, required this.title, required this.iconData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          Icon(iconData, size: 50, color: AppColors.accent(context)),
          SizedBox(height: 20),
          Text(title, style: TextStyle(fontWeight: FontWeight.bold))]),
      ),
    );
  }
}
