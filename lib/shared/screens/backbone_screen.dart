import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:ziyyer/config/app_constants.dart';
import 'package:ziyyer/config/app_icons.dart';
import 'package:ziyyer/theme.dart';
import 'package:ziyyer/widgets/add_expense_btn.dart';

class BackboneScreen extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const BackboneScreen({super.key, required this.navigationShell});

  @override
  State<BackboneScreen> createState() => _BackboneScreenState();
}

class _BackboneScreenState extends State<BackboneScreen> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final isLandscape = screenWidth > screenHeight;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final bottomSafe = MediaQuery.of(context).padding.bottom;

    final horizontalMargin = screenWidth * 0.04;

    final containerPadding = EdgeInsets.symmetric(horizontal: screenWidth * 0.02, vertical: screenHeight * 0.008);

    final maxWidth = screenWidth > 600 ? 600.0 : screenWidth - (horizontalMargin * 2);

    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: BottomBar(
        layout: BottomBarLayout(
          width: maxWidth,
          respectSafeArea: false,
          borderRadius: BorderRadius.circular(AppConstants.maxBorderRadius),
          offset: 20,
        ),
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.only(top: 16, bottom: bottomSafe + bottomInset + 30),
            child: widget.navigationShell,
          ),
        ),
        motion: const BottomBarMotion.cupertino(
          preset: BottomBarCupertinoMotion.interactive,
          duration: Duration(milliseconds: 360),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface(context),
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                offset: const Offset(0, -5),
                color: AppColors.textPrimary(context).withAlpha(15),
              ),
            ],
            borderRadius: BorderRadius.circular(AppConstants.maxBorderRadius),
            border: Border.all(color: AppColors.card(context)),
          ),
          child: Padding(
            padding: containerPadding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _NavItem(
                  icon: AppIcons.home,
                  label: 'Home',
                  isSelected: widget.navigationShell.currentIndex == 0,
                  onTap: () => widget.navigationShell.goBranch(0, initialLocation: true),
                  screenWidth: screenWidth,
                  isLandscape: isLandscape,
                ),
                _NavItem(
                  icon: AppIcons.history,
                  label: 'History',
                  isSelected: widget.navigationShell.currentIndex == 1,
                  onTap: () => widget.navigationShell.goBranch(1, initialLocation: true),
                  screenWidth: screenWidth,
                  isLandscape: isLandscape,
                ),
                AddExpenseButton(onPressed: () => widget.navigationShell.goBranch(4, initialLocation: true)),
                _NavItem(
                  icon: AppIcons.insights,
                  label: 'Insight',
                  isSelected: widget.navigationShell.currentIndex == 2,
                  onTap: () => widget.navigationShell.goBranch(2, initialLocation: true),
                  screenWidth: screenWidth,
                  isLandscape: isLandscape,
                ),
                _NavItem(
                  icon: AppIcons.settings,
                  label: 'Settings',
                  isSelected: widget.navigationShell.currentIndex == 3,
                  onTap: () => widget.navigationShell.goBranch(3, initialLocation: true),
                  screenWidth: screenWidth,
                  isLandscape: isLandscape,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final double screenWidth;
  final bool isLandscape;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.screenWidth,
    required this.isLandscape,
  });

  @override
  Widget build(BuildContext context) {
    final selectedColor = AppColors.accentColor(context);
    final unselectedColor = AppColors.textHint(context);

    final iconSize = screenWidth * 0.06;
    final fontSize = isSelected ? screenWidth * 0.03 : screenWidth * 0.0275;
    final horizontalPadding = screenWidth * 0.04;
    final verticalPadding = screenWidth * 0.02;
    final spacing = screenWidth * 0.015;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                icon,
                key: ValueKey(isSelected),
                size: iconSize,
                color: isSelected ? selectedColor : unselectedColor,
              ),
            ),
            SizedBox(height: spacing),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style:
                  (isSelected ? Theme.of(context).textTheme.labelLarge : Theme.of(context).textTheme.labelSmall)
                      ?.copyWith(
                        fontSize: fontSize,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected ? selectedColor : unselectedColor,
                      ) ??
                  TextStyle(
                    fontSize: fontSize,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? selectedColor : unselectedColor,
                  ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
