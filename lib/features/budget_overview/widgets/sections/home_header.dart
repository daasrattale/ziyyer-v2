import 'package:flutter/material.dart';
import 'package:ziyyer/theme.dart';
import 'package:ziyyer/config/app_constants.dart';
import 'package:ziyyer/config/app_icons.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  final VoidCallback onNotificationTap;

  const HomeHeader({super.key, required this.userName, required this.onNotificationTap});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.screenMargin, vertical: AppConstants.spacingMedium),
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
                style: textTheme.labelLarge?.copyWith(color: AppColors.textSecondary(context), fontWeight: FontWeight.w500, letterSpacing: 0.3),
              ),
              const SizedBox(height: AppConstants.spacingExtraSmall),
              Text(
                userName,
                style: textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary(context), letterSpacing: -0.5),
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
