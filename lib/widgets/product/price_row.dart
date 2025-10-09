// ============================================
// Main Widget: grid_product_card.dart
// ============================================

import 'package:flutter/material.dart';
import 'package:zoyo_bathware/widgets/product/discount_chip.dart';
import 'package:zoyo_bathware/widgets/product/original_price_text.dart';
import 'package:zoyo_bathware/widgets/product/sale_price_text.dart';
import 'package:zoyo_bathware/widgets/responsive.dart';

class PriceRow extends StatelessWidget {
  final double salesRate;
  final double discount;
  final bool isOutOfStock;
  final Responsive responsive;

  const PriceRow({
    super.key,
    required this.salesRate,
    required this.discount,
    required this.isOutOfStock,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (discount > 0 && !isOutOfStock) ...[
          Row(
            children: [
              DiscountChip(
                responsive: responsive,
                discount: discount,
              ),
              SizedBox(width: responsive.wp(1)),
              OriginalPriceText(
                originalPrice: salesRate * 1.3,
                responsive: responsive,
              ),
            ],
          ),
          SizedBox(height: responsive.hp(0.2)),
        ],
        SalePriceText(
          salesRate: salesRate,
          responsive: responsive,
        ),
      ],
    );
  }
}
