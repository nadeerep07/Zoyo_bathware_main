// ============================================
// Main Widget: grid_product_card.dart
// ============================================

import 'package:flutter/material.dart';
import 'package:zoyo_bathware/widgets/responsive.dart';

class DiscountBadge extends StatelessWidget {
  final Responsive responsive;
  final double discount;

  const DiscountBadge({
    super.key,
    required this.responsive,
    required this.discount,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: responsive.wp(1),
      left: responsive.wp(1),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: responsive.wp(1.5),
          vertical: responsive.hp(0.2),
        ),
        decoration: BoxDecoration(
          color: Colors.green.shade600,
          borderRadius: BorderRadius.circular(responsive.wp(1)),
        ),
        child: Text(
          '${discount.toInt()}% off',
          style: TextStyle(
            color: Colors.white,
            fontSize: responsive.sp(10),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
