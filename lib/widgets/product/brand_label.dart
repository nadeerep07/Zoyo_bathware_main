// ============================================
// Main Widget: grid_product_card.dart
// ============================================

import 'package:flutter/material.dart';
import 'package:zoyo_bathware/widgets/responsive.dart';

class BrandLabel extends StatelessWidget {
  final Responsive responsive;

  const BrandLabel({
    super.key,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      'Zoyo Bathware',
      style: TextStyle(
        fontSize: responsive.sp(10),
        color: Colors.grey.shade600,
      ),
    );
  }
}
