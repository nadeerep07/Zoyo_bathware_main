// ============================================
// Main Widget: grid_product_card.dart
// ============================================

import 'package:flutter/material.dart';
import 'package:zoyo_bathware/widgets/responsive.dart';

class ProductNameText extends StatelessWidget {
  final String productName;
  final Responsive responsive;

  const ProductNameText({
    super.key,
    required this.productName,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      productName,
      style: TextStyle(
        fontSize: responsive.sp(12),
        color: Colors.black87,
        fontWeight: FontWeight.w500,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
