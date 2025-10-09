// ============================================
// Main Widget: grid_product_card.dart
// ============================================

import 'package:flutter/material.dart';
import 'package:zoyo_bathware/widgets/responsive.dart';

class SalePriceText extends StatelessWidget {
  final double salesRate;
  final Responsive responsive;

  const SalePriceText({
    super.key,
    required this.salesRate,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '₹${salesRate.toInt()}',
      style: TextStyle(
        fontSize: responsive.sp(14),
        fontWeight: FontWeight.w600,
      ),
    );
  }
}