// ============================================
// Main Widget: grid_product_card.dart
// ============================================

import 'package:flutter/material.dart';
import 'package:zoyo_bathware/widgets/responsive.dart';

class FavoriteButton extends StatelessWidget {
  final Responsive responsive;
  final bool isFavorite;
  final VoidCallback onToggle;

  const FavoriteButton({
    super.key,
    required this.responsive,
    required this.isFavorite,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: responsive.wp(1),
      right: responsive.wp(1),
      child: GestureDetector(
        onTap: onToggle,
        child: Container(
          padding: EdgeInsets.all(responsive.wp(1)),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha:0.1),
                blurRadius: 4,
                offset: const Offset(0, 1),
              )
            ],
          ),
          child: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : Colors.grey.shade600,
            size: responsive.sp(16),
          ),
        ),
      ),
    );
  }
}
