import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:zoyo_bathware/core/models/product_model.dart';
import 'package:zoyo_bathware/constants/app_colors.dart';
import 'package:zoyo_bathware/features/detail_screens/view/screens/details_screen.dart';
import '../responsive.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final Responsive responsive;

  const ProductCard({super.key, required this.product, required this.responsive});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ProductDetailScreen(productCode: product.id!)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(flex: 3, child: _productImage()),
            Flexible(flex: 2, child: _productDetails()),
          ],
        ),
      ),
    );
  }

  Widget _productImage() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        image: DecorationImage(image: FileImage(File(product.imagePaths.first)), fit: BoxFit.cover),
      ),
      child: Stack(
        children: [
          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withOpacity(0.1)]),
            ),
          ),
          // NEW Badge
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.secondaryColor, borderRadius: BorderRadius.circular(8)),
              child: Text('NEW', style: TextStyle(color: Colors.white, fontSize: kIsWeb ? 10 : responsive.sp(10), fontWeight: FontWeight.bold)),
            ),
          ),
          // Favorite Icon
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), shape: BoxShape.circle),
              child: Icon(Icons.favorite_outline, size: kIsWeb ? 16 : responsive.wp(4), color: Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _productDetails() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(product.productName, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: kIsWeb ? 15 : responsive.sp(13), fontWeight: FontWeight.bold, color: const Color(0xFF1E293B), height: 1.1)),
          ),
          const SizedBox(height: 4),
          Text('Code: ${product.productCode}', style: TextStyle(fontSize: kIsWeb ? 11 : responsive.sp(10), color: const Color(0xFF64748B), fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: Text('₹${product.salesRate.toStringAsFixed(0)}', style: TextStyle(fontSize: kIsWeb ? 15 : responsive.sp(13), fontWeight: FontWeight.bold, color: AppColors.primaryColor), overflow: TextOverflow.ellipsis)),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(color: AppColors.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                child: Center(child: Icon(Icons.arrow_forward_rounded, size: kIsWeb ? 14 : responsive.wp(3.5), color: AppColors.primaryColor)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
