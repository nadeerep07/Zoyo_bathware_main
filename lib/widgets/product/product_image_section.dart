// ============================================
// Main Widget: grid_product_card.dart
// ============================================

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:zoyo_bathware/core/models/product_model.dart';
import 'package:zoyo_bathware/widgets/product/discount_badge.dart';
import 'package:zoyo_bathware/widgets/product/favorite_button.dart';
import 'package:zoyo_bathware/widgets/product/out_of_stock_overlay.dart';
import 'package:zoyo_bathware/widgets/responsive.dart';

class ProductImageSection extends StatelessWidget {
  final Product product;
  final Responsive responsive;
  final double discount;
  final bool isOutOfStock;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const ProductImageSection({
    super.key,
    required this.product,
    required this.responsive,
    required this.discount,
    required this.isOutOfStock,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: responsive.hp(18),
      width: double.infinity,
      padding: EdgeInsets.all(responsive.wp(2)),
      child: Stack(
        children: [
          _buildProductImage(),
          FavoriteButton(
            responsive: responsive,
            isFavorite: isFavorite,
            onToggle: onFavoriteToggle,
          ),
          if (discount > 0 && !isOutOfStock)
            DiscountBadge(
              responsive: responsive,
              discount: discount,
            ),
          if (isOutOfStock)
            OutOfStockOverlay(responsive: responsive),
        ],
      ),
    );
  }

  Widget _buildProductImage() {
    return Center(
      child: product.imagePaths.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(responsive.wp(1)),
              child: Image.file(
                File(product.imagePaths.first),
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.contain,
              ),
            )
          : Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(responsive.wp(1)),
              ),
              child: Icon(
                Icons.image_outlined,
                size: responsive.sp(32),
                color: Colors.grey.shade400,
              ),
            ),
    );
  }
}
