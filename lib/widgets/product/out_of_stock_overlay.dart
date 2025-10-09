// ============================================
// Main Widget: grid_product_card.dart
// ============================================

import 'package:flutter/material.dart';
import 'package:zoyo_bathware/widgets/responsive.dart';

class OutOfStockOverlay extends StatelessWidget {
  final Responsive responsive;

  const OutOfStockOverlay({
    super.key,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha:0.8),
          borderRadius: BorderRadius.circular(responsive.wp(1)),
        ),
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: responsive.wp(3),
              vertical: responsive.hp(0.5),
            ),
            decoration: BoxDecoration(
              color: Colors.red.shade600,
              borderRadius: BorderRadius.circular(responsive.wp(1)),
            ),
            child: Text(
              'Out of Stock',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: responsive.sp(10),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
