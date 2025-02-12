import 'dart:io';
import 'package:flutter/material.dart';
import 'package:zoyo_bathware/database/product_model.dart';
import 'package:zoyo_bathware/services/app_colors.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 5,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: product.imagePaths.isNotEmpty
                ? Image.file(
                    File(product.imagePaths.first),
                    width: double.infinity,
                    height: 120,
                    fit: BoxFit.contain,
                  )
                : Container(
                    width: 120,
                    height: 120,
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.image, size: 50, color: Colors.grey),
                    ),
                  ),
          ),

          // Product Name

          Text(
            product.productName,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 4),

          // Price, Discount & Quantity
          Row(
            children: [
              Text(
                "ZRP:${product.salesRate}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Quantity
          Text(
            'Available: ${product.quantity}',
            style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500),
          ),

          const SizedBox(height: 10),

          // Add to Cart Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
                side: BorderSide(color: Colors.orange.shade800),
              ),
              icon: Icon(Icons.shopping_cart,
                  color: Colors.orange.shade800, size: 18),
              label: Text(
                "Add to Cart",
                style: TextStyle(fontSize: 13, color: Colors.orange.shade800),
              ),
              onPressed: () {
                // Add to cart functionality
              },
            ),
          ),
        ],
      ),
    );
  }
}
