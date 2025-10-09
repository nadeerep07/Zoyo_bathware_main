// product_detail_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:zoyo_bathware/features/billing_section/view/screens/billing_screen.dart';
import 'package:zoyo_bathware/features/detail_screens/viewmodel/product_detail_viewmodel.dart';
import 'package:zoyo_bathware/widgets/responsive.dart';

class ProductDetailScreen extends StatelessWidget {
  final String productCode;

  const ProductDetailScreen({Key? key, required this.productCode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return ChangeNotifierProvider(
      create: (_) => ProductDetailViewModel(productCode: productCode),
      child: Consumer<ProductDetailViewModel>(
        builder: (context, vm, _) {
          final product = vm.product;

          if (product == null) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          bool isOutOfStock = vm.isOutOfStock;

          return Scaffold(
            backgroundColor: Colors.grey.shade50,
            body: CustomScrollView(
              slivers: [
                // App Bar with Images
                SliverAppBar(
                  expandedHeight: responsive.hp(40),
                  pinned: true,
                  backgroundColor: Colors.white,
                  flexibleSpace: FlexibleSpaceBar(
                    background: product.imagePaths.isNotEmpty
                        ? CarouselSlider(
                            options: CarouselOptions(
                              height: responsive.hp(40),
                              autoPlay: true,
                              enlargeCenterPage: true,
                              viewportFraction: 0.85,
                              onPageChanged: (index, reason) =>
                                  vm.updateImageIndex(index),
                            ),
                            items: product.imagePaths.map((path) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.file(
                                  File(path),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              );
                            }).toList(),
                          )
                        : const Center(child: Icon(Icons.image, size: 100)),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(
                        vm.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: vm.isFavorite ? Colors.red : Colors.black,
                      ),
                      onPressed: () => vm.toggleFavorite(),
                    ),
                  ],
                ),

                // Content
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(responsive.wp(4)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.productName,
                          style: TextStyle(
                              fontSize: responsive.sp(24),
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '₹ ${product.salesRate.toStringAsFixed(0)}',
                          style: TextStyle(
                              fontSize: responsive.sp(20),
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                        ),
                        SizedBox(height: responsive.hp(2)),

                        // Details
                        _buildDetailRow('Code', product.productCode),
                        _buildDetailRow('Material', product.type),
                        _buildDetailRow('Dimensions', product.size),
                        _buildDetailRow(
                          'Availability',
                          isOutOfStock
                              ? 'Out of Stock'
                              : '${product.quantity} items',
                          valueStyle: isOutOfStock
                              ? const TextStyle(
                                  color: Colors.red, fontWeight: FontWeight.bold)
                              : const TextStyle(
                                  color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                        _buildDetailRow('Manufacturer', 'Zoyo Bathware'),

                        SizedBox(height: responsive.hp(3)),

                        // Description
                        Text(
                          'Description',
                          style: TextStyle(
                              fontSize: responsive.sp(18),
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          product.description,
                          style: TextStyle(
                            fontSize: responsive.sp(16),
                            color: Colors.grey.shade600,
                          ),
                        ),

                        SizedBox(height: responsive.hp(3)),

                        // Add to Cart Button
                        SizedBox(
                          width: double.infinity,
                          height: responsive.hp(7),
                          child: ElevatedButton.icon(
                            icon: vm.isAddingToCart
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                        color: Colors.white, strokeWidth: 2),
                                  )
                                : const Icon(Icons.shopping_cart_outlined),
                            label: Text(isOutOfStock
                                ? 'Out of Stock'
                                : 'Add to Cart'),
                            onPressed: isOutOfStock
                                ? null
                                : () async {
                                    await vm.addToCart();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            '${product.productName} added to cart!'),
                                        action: SnackBarAction(
                                          label: 'View Cart',
                                          onPressed: () {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      const BillingScreen()),
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value,
      {TextStyle? valueStyle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: valueStyle ?? const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
