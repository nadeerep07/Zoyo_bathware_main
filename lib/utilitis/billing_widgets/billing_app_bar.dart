import 'package:flutter/material.dart';
import 'package:zoyo_bathware/services/app_colors.dart';

class BillingAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BillingAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title:
          const Text('Billing', style: TextStyle(fontWeight: FontWeight.bold)),
      backgroundColor: AppColors.primaryColor,
      elevation: 0,
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
