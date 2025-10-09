import 'package:flutter/material.dart';
import 'package:zoyo_bathware/constants/app_colors.dart';
import 'package:zoyo_bathware/widgets/responsive.dart';

class PriceLabel extends StatelessWidget {
  const PriceLabel({
    super.key,
    required this.responsive,
    required this.price,
  });

  final Responsive responsive;
  final double price;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.wp(3),
        vertical: responsive.hp(0.5),
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha:0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        "₹${price.toStringAsFixed(0)}",
        style: TextStyle(
          fontSize: responsive.sp(12),
          fontWeight: FontWeight.w600,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }
}
