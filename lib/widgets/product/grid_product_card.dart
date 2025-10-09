import 'dart:io';
import 'package:flutter/material.dart';
import 'package:zoyo_bathware/core/models/product_model.dart';
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
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 2, offset: const Offset(0, 1))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _GridImageSection(),
            _GridDetailsSection(),
          ],
        ),
      ),
    );
  }

  Widget _GridImageSection() {
    return Container(
      height: responsive.hp(18),
      width: double.infinity,
      padding: EdgeInsets.all(responsive.wp(2)),
      child: Stack(
        children: [
          Center(
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
                    child: Icon(Icons.image_outlined,
                        size: responsive.sp(32), color: Colors.grey.shade400),
                  ),
          ),
          // Favorite Button
          Positioned(
            top: responsive.wp(1),
            right: responsive.wp(1),
            child: GestureDetector(
              onTap: onFavoriteToggle,
              child: Container(
                padding: EdgeInsets.all(responsive.wp(1)),
                decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 1))
                ]),
                child: Icon(isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey.shade600, size: responsive.sp(16)),
              ),
            ),
          ),
          // Discount Badge
          if (discount > 0 && !isOutOfStock)
            Positioned(
              top: responsive.wp(1),
              left: responsive.wp(1),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: responsive.wp(1.5), vertical: responsive.hp(0.2)),
                decoration: BoxDecoration(color: Colors.green.shade600, borderRadius: BorderRadius.circular(responsive.wp(1))),
                child: Text('${discount.toInt()}% off', style: TextStyle(color: Colors.white, fontSize: responsive.sp(10), fontWeight: FontWeight.w600)),
              ),
            ),
          // Out of Stock Overlay
          if (isOutOfStock)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.8), borderRadius: BorderRadius.circular(responsive.wp(1))),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: responsive.wp(3), vertical: responsive.hp(0.5)),
                    decoration: BoxDecoration(color: Colors.red.shade600, borderRadius: BorderRadius.circular(responsive.wp(1))),
                    child: Text('Out of Stock', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: responsive.sp(10))),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _GridDetailsSection() {
    return Padding(
      padding: EdgeInsets.all(responsive.wp(2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Zoyo Bathware', style: TextStyle(fontSize: responsive.sp(10), color: Colors.grey.shade600)),
          SizedBox(height: responsive.hp(0.5)),
          Text(product.productName,
              style: TextStyle(fontSize: responsive.sp(12), color: Colors.black87, fontWeight: FontWeight.w500),
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
          SizedBox(height: responsive.hp(0.5)),
          Row(
            children: [
              if (discount > 0 && !isOutOfStock)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: responsive.wp(1), vertical: responsive.hp(0.2)),
                  margin: EdgeInsets.only(right: responsive.wp(1)),
                  decoration: BoxDecoration(color: Colors.green.shade600, borderRadius: BorderRadius.circular(responsive.wp(1))),
                  child: Text('${discount.toInt()}%', style: TextStyle(color: Colors.white, fontSize: responsive.sp(9))),
                ),
              if (discount > 0 && !isOutOfStock)
                Text('₹${(product.salesRate * 1.3).toInt()}',
                    style: TextStyle(fontSize: responsive.sp(10), color: Colors.grey.shade500, decoration: TextDecoration.lineThrough)),
            ],
          ),
          SizedBox(height: responsive.hp(0.2)),
          Text('₹${product.salesRate.toInt()}', style: TextStyle(fontSize: responsive.sp(14), fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
