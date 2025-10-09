// ============================================
// Main Widget: grid_product_card.dart
// ============================================
import 'package:flutter/material.dart';
import 'package:zoyo_bathware/core/models/product_model.dart';
import 'package:zoyo_bathware/widgets/product/product_details_section.dart';
import 'package:zoyo_bathware/widgets/product/product_image_section.dart';

import '../responsive.dart';

class GridProductCard extends StatelessWidget {
  final Product product;
  final Responsive responsive;
  final double discount;
  final bool isOutOfStock;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onTap;

  const GridProductCard({
    super.key,
    required this.product,
    required this.responsive,
    required this.discount,
    required this.isOutOfStock,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(responsive.wp(1)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(responsive.wp(2)),
          border: Border.all(color: Colors.grey.shade300, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .04),
              blurRadius: 2,
              offset: const Offset(0, 1),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fixed height for image section
            ProductImageSection(
              product: product,
              responsive: responsive,
              discount: discount,
              isOutOfStock: isOutOfStock,
              isFavorite: isFavorite,
              onFavoriteToggle: onFavoriteToggle,
            ),
            // Expanded to fill remaining space and prevent overflow
            Expanded(
              child: ProductDetailsSection(
                product: product,
                responsive: responsive,
                discount: discount,
                isOutOfStock: isOutOfStock,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
