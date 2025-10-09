// ============================================
// Main Widget: grid_product_card.dart
// ============================================

import 'package:flutter/material.dart';
import 'package:zoyo_bathware/widgets/responsive.dart';

class OriginalPriceText extends StatelessWidget {
  final double originalPrice;
  final Responsive responsive;

  const OriginalPriceText({
    super.key,
    required this.originalPrice,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '₹${originalPrice.toInt()}',
      style: TextStyle(
        fontSize: responsive.sp(10),
        color: Colors.grey.shade500,
        decoration: TextDecoration.lineThrough,
      ),
    );
  }
}
