import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:zoyo_bathware/database/product_model.dart';
import 'package:zoyo_bathware/screens/all_categories/all_categories_screen.dart';
import 'package:zoyo_bathware/screens/detail_screens/details_screen.dart';
import 'package:zoyo_bathware/services/app_colors.dart';

class NewArrivalsWidget extends StatelessWidget {
  final ValueNotifier<List<Product>> productsNotifier;

  const NewArrivalsWidget({super.key, required this.productsNotifier});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Adjust sizes for web
    final isWeb = kIsWeb;
    final itemWidth = isWeb ? screenWidth * 0.3 : screenWidth * 0.45;
    final imageHeight = isWeb ? screenHeight * 0.3 : screenHeight * 0.2;
    final fontSize = isWeb ? screenWidth * 0.02 : screenWidth * 0.05;
    final priceFontSize = isWeb ? screenWidth * 0.015 : screenWidth * 0.04;
    final viewportFraction = isWeb ? 0.3 : 0.64;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'New Arrivals',
              style: TextStyle(
                fontSize: isWeb ? screenWidth * 0.025 : screenWidth * 0.06,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AllCategories()),
                );
              },
              child: Text(
                'View All',
                style: TextStyle(
                  color: AppColors.buttonColor,
                  fontSize: isWeb ? screenWidth * 0.015 : screenWidth * 0.04,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: screenHeight * 0.02),
        SizedBox(
          height: imageHeight + 50, // Adjust height dynamically
          child: ValueListenableBuilder<List<Product>>(
            valueListenable: productsNotifier,
            builder: (context, products, child) {
              if (products.isEmpty) {
                return const Center(child: Text('No products found'));
              } else {
                return CarouselSlider.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index, realIndex) {
                    final product = products[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailScreen(productCode: product.id!),
                          ),
                        );
                      },
                      child: SizedBox(
                        width: itemWidth,
                        child: Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Stack(
                              children: [
                                Image.file(
                                  File(product.imagePaths.first),
                                  fit: BoxFit.cover,
                                  height: imageHeight,
                                  width: double.infinity,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.black.withOpacity(0.4),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: screenHeight * 0.01,
                                  left: screenWidth * 0.04,
                                  right: screenWidth * 0.04,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.productName,
                                        style: TextStyle(
                                          fontSize: fontSize,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: screenHeight * 0.001),
                                      Text(
                                        'Code: ${product.productCode}',
                                        style: TextStyle(
                                          fontSize: priceFontSize,
                                          color: Colors.white70,
                                        ),
                                      ),
                                      SizedBox(height: screenHeight * 0.001),
                                      Text(
                                        'ZRP: ₹${product.salesRate.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: priceFontSize,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.secondaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  options: CarouselOptions(
                    height: imageHeight + 50,
                    enlargeCenterPage: false,
                    autoPlay: false,
                    aspectRatio: 16 / 9,
                    viewportFraction: viewportFraction,
                    enableInfiniteScroll: true,
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
