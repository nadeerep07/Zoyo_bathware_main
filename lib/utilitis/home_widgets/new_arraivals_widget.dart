import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
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

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'New Arrivals',
              style: TextStyle(
                fontSize: screenWidth * 0.06,
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
                  fontSize: screenWidth * 0.05,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: screenHeight * 0.02),
        SizedBox(
          height: screenHeight * 0.25,
          child: ValueListenableBuilder<List<Product>>(
            valueListenable: productsNotifier,
            builder: (context, products, child) {
              if (products.isEmpty) {
                return const Center(child: CircularProgressIndicator());
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
                        width: screenWidth * 0.6,
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
                                  height: screenHeight * 0.2,
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
                                          fontSize: screenWidth * 0.05,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: screenHeight * 0.001),
                                      Text(
                                        'Code: ${product.productCode}',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          color: Colors.white70,
                                        ),
                                      ),
                                      SizedBox(height: screenHeight * 0.001),
                                      Text(
                                        'ZRP: ₹${product.salesRate.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
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
                    height: screenHeight * 0.25,
                    enlargeCenterPage: true,
                    autoPlay: false,
                    aspectRatio: 16 / 9,
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
