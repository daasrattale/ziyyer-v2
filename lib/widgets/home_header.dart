import 'package:flutter/material.dart';
import 'package:ziyyer/config/theme.dart';
import 'package:ziyyer/constants/app_icons.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  final VoidCallback onNotificationTap;

  const HomeHeader({super.key, required this.userName, required this.onNotificationTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Greeting and Name Column
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textSecondary(context), letterSpacing: 0.3),
              ),
              const SizedBox(height: 4),
              Text(
                userName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary(context), // Deep dark color for strong contrast
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),

          // Notification Button
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surface(context),
              border: Border.all(color: AppColors.background(context), width: 1),
            ),
            child: IconButton(
              icon: Icon(AppIcons.notification, size: 20, color: AppColors.textPrimary(context)),
              onPressed: onNotificationTap,
              splashRadius: 24,
              constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
            ),
          ),
        ],
      ),
    );
  }
}
