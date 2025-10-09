// ============================================
// Main Widget: grid_product_card.dart
// ============================================

import 'package:flutter/material.dart';
import 'package:zoyo_bathware/widgets/responsive.dart';

class DiscountChip extends StatelessWidget {
  final Responsive responsive;
  final double discount;

  const DiscountChip({
    super.key,
    required this.responsive,
    required this.discount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.wp(1),
        vertical: responsive.hp(0.2),
      ),
      decoration: BoxDecoration(
        color: Colors.green.shade600,
        borderRadius: BorderRadius.circular(responsive.wp(1)),
      ),
      child: Text(
        '${discount.toInt()}%',
        style: TextStyle(
          color: Colors.white,
          fontSize: responsive.sp(9),
        ),
      ),
    );
  }
}
