// ============================================
// Main Widget: grid_product_card.dart
// ============================================

import 'package:flutter/material.dart';
import 'package:zoyo_bathware/core/models/product_model.dart';
import 'package:zoyo_bathware/widgets/product/brand_label.dart';
import 'package:zoyo_bathware/widgets/product/price_row.dart';
import 'package:zoyo_bathware/widgets/product/product_name_text.dart';
import 'package:zoyo_bathware/widgets/responsive.dart';

class ProductDetailsSection extends StatelessWidget {
  final Product product;
  final Responsive responsive;
  final double discount;
  final bool isOutOfStock;

  const ProductDetailsSection({
    super.key,
    required this.product,
    required this.responsive,
    required this.discount,
    required this.isOutOfStock,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(responsive.wp(2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          BrandLabel(responsive: responsive),
          SizedBox(height: responsive.hp(0.3)),
          ProductNameText(
            productName: product.productName,
            responsive: responsive,
          ),
          SizedBox(height: responsive.hp(0.3)),
          PriceRow(
            salesRate: product.salesRate,
            discount: discount,
            isOutOfStock: isOutOfStock,
            responsive: responsive,
          ),
        ],
      ),
    );
  }
}
