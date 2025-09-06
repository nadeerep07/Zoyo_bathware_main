import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:zoyo_bathware/database/product_model.dart';
import 'package:zoyo_bathware/features/all_categories/all_categories_screen.dart';
import 'package:zoyo_bathware/features/detail_screens/details_screen.dart';
import 'package:zoyo_bathware/services/app_colors.dart';
import 'package:zoyo_bathware/utilitis/responsive.dart';

class NewArrivalsWidget extends StatelessWidget {
  final ValueNotifier<List<Product>> productsNotifier;

  const NewArrivalsWidget({super.key, required this.productsNotifier});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'New Arrivals',
                        style: TextStyle(
                          fontSize: kIsWeb ? 24 : responsive.sp(20),
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1E293B),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Latest products from our collection',
                        style: TextStyle(
                          fontSize: kIsWeb ? 16 : responsive.sp(14),
                          color: const Color(0xFF64748B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AllCategories(),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: kIsWeb ? 20 : responsive.wp(4),
                        vertical: kIsWeb ? 12 : responsive.hp(1.2),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'View All',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: kIsWeb ? 16 : responsive.sp(14),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: kIsWeb ? 18 : responsive.sp(16),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Products Grid
          ValueListenableBuilder<List<Product>>(
            valueListenable: productsNotifier,
            builder: (context, products, child) {
              if (products.isEmpty) {
                return Container(
                  height: responsive.hp(25),
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.shopping_bag_outlined,
                            size: kIsWeb ? 48 : responsive.wp(12),
                            color: Colors.grey.shade400,
                          ),
                        ),
                        SizedBox(height: responsive.hp(2)),
                        Text(
                          'No products found',
                          style: TextStyle(
                            fontSize: kIsWeb ? 18 : responsive.sp(16),
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: responsive.hp(0.5)),
                        Text(
                          'Check back later for new arrivals',
                          style: TextStyle(
                            fontSize: kIsWeb ? 14 : responsive.sp(12),
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: kIsWeb ? 3 : 2,
                    crossAxisSpacing: kIsWeb ? 20 : 12,
                    mainAxisSpacing: kIsWeb ? 20 : 12,
                    childAspectRatio: kIsWeb ? 0.85 : 0.75,
                  ),
                  itemCount: products.length > 6 ? 6 : products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return _buildProductCard(context, product, responsive);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

Widget _buildProductCard(
      BuildContext context, Product product, Responsive responsive) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(productCode: product.id!),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.shade100,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  image: DecorationImage(
                    image: FileImage(File(product.imagePaths.first)),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    // Gradient overlay for better text readability
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.1),
                          ],
                        ),
                      ),
                    ),
                    // New Badge
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryColor,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          'NEW',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: kIsWeb ? 10 : responsive.sp(10),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    // Favorite Icon
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.favorite_outline,
                          size: kIsWeb ? 16 : responsive.wp(4),
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Product Details - Fixed Section
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8), // Reduced padding from 12 to 8
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name - Takes available space
                    Expanded(
                      flex: 2,
                      child: Text(
                        product.productName,
                        style: TextStyle(
                          fontSize: kIsWeb ? 15 : responsive.sp(13), // Slightly reduced
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1E293B),
                          height: 1.1, // Reduced line height
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    
                    // Small spacing
                    const SizedBox(height: 2),
                    
                    // Product Code - Fixed height
                    Text(
                      'Code: ${product.productCode}',
                      style: TextStyle(
                        fontSize: kIsWeb ? 11 : responsive.sp(10), // Slightly reduced
                        color: const Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                        height: 1.0,
                      ),
                    ),
                    
                    // Small spacing
                    const SizedBox(height: 4),
                    
                    // Price and Arrow Row - Fixed height
                    SizedBox(
                      height: 24, // Fixed height for this row
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              '₹${product.salesRate.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: kIsWeb ? 15 : responsive.sp(13), // Slightly reduced
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                                height: 1.0,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            width: 24, // Fixed width
                            height: 24, // Fixed height
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6), // Slightly smaller radius
                            ),
                            child: Center(
                              child: Icon(
                                Icons.arrow_forward_rounded,
                                size: kIsWeb ? 14 : responsive.wp(3.5), // Slightly smaller
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }}
