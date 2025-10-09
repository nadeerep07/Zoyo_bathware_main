import 'dart:io';
import 'package:flutter/material.dart';
import 'package:zoyo_bathware/core/models/product_model.dart';
import '../responsive.dart';

class ListProductCard extends StatelessWidget {
  final Product product;
  final Responsive responsive;
  final double discount;
  final bool isOutOfStock;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onTap;

  const ListProductCard({
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
        margin: EdgeInsets.symmetric(vertical: responsive.hp(0.5), horizontal: responsive.wp(2)),
        padding: EdgeInsets.all(responsive.wp(2)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(responsive.wp(2)),
          border: Border.all(color: Colors.grey.shade300, width: 0.5),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 3, offset: const Offset(0, 1))],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              width: responsive.wp(22),
              height: responsive.wp(22),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(responsive.wp(2)), border: Border.all(color: Colors.grey.shade200)),
              child: product.imagePaths.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(responsive.wp(2)),
                      child: Image.file(File(product.imagePaths.first), fit: BoxFit.contain),
                    )
                  : Container(
                      color: Colors.grey.shade100,
                      child: Icon(Icons.image_outlined, size: responsive.sp(24), color: Colors.grey.shade400),
                    ),
            ),
            SizedBox(width: responsive.wp(3)),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.productName,
                      style: TextStyle(fontSize: responsive.sp(14), fontWeight: FontWeight.w500, color: Colors.black87),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  SizedBox(height: responsive.hp(0.5)),
                  Text("Code: ${product.productCode}", style: TextStyle(fontSize: responsive.sp(11), color: Colors.grey.shade600)),
                  SizedBox(height: responsive.hp(0.5)),

                  // Discount Row
                  Row(
                    children: [
                      if (discount > 0 && !isOutOfStock)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: responsive.wp(1), vertical: responsive.hp(0.2)),
                          margin: EdgeInsets.only(right: responsive.wp(1)),
                          decoration: BoxDecoration(color: Colors.green.shade600, borderRadius: BorderRadius.circular(responsive.wp(1))),
                          child: Text('${discount.toInt()}%', style: TextStyle(color: Colors.white, fontSize: responsive.sp(10))),
                        ),
                      if (discount > 0 && !isOutOfStock)
                        Text('₹${(product.salesRate * 1.3).toInt()}',
                            style: TextStyle(fontSize: responsive.sp(12), color: Colors.grey.shade500, decoration: TextDecoration.lineThrough)),
                    ],
                  ),

                  SizedBox(height: responsive.hp(0.2)),
                  Text('₹${product.salesRate.toInt()}', style: TextStyle(fontSize: responsive.sp(16), fontWeight: FontWeight.w600)),
                ],
              ),
            ),

            // Favorite Icon
            SizedBox(width: responsive.wp(2)),
            GestureDetector(
              onTap: onFavoriteToggle,
              child: Icon(isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.grey.shade400, size: responsive.sp(20)),
            ),
          ],
        ),
      ),
    );
  }
}
