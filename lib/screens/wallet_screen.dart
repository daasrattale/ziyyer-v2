import 'package:flutter/material.dart';
import 'package:ziyyer/constants/app_icons.dart';

import 'demo_screen.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoScreen(title: 'Wallet Screen', iconData: AppIcons.wallet);
  }
}

