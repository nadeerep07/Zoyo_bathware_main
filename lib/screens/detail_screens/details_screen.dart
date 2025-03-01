import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:zoyo_bathware/database/data_operations/cart_db.dart';
import 'package:zoyo_bathware/database/product_model.dart';
import 'package:zoyo_bathware/screens/billing_section/billing_screen.dart';
import 'package:zoyo_bathware/utilitis/custom_classes/detail_row.dart';

const String productBox = 'products';

class ProductDetailScreen extends StatelessWidget {
  final String productCode;

  const ProductDetailScreen({Key? key, required this.productCode})
      : super(key: key);

  void _showCustomSnackBar(BuildContext context, Product product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.productName} added to cart!'),
        backgroundColor: Colors.green,
        action: SnackBarAction(
          label: 'View Cart',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => BillingScreen()));
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var box = Hive.box<Product>(productBox);
    final Product? product = box.get(productCode);

    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Product Details')),
        body: Center(
          child: Text('Product Not Found!',
              style: TextStyle(fontSize: 24, color: Colors.red)),
        ),
      );
    }

    bool isOutOfStock = product.quantity == 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.productName),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.black),
            onPressed: () {
              // Share product functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Product shared!')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {
              // Add to favorites functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Added to favorites!')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Carousel
              if (product.imagePaths.isNotEmpty)
                CarouselSlider(
                  options: CarouselOptions(
                    height: 300,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    viewportFraction: 0.9,
                    aspectRatio: 16 / 9,
                  ),
                  items: product.imagePaths.map((imagePath) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(File(imagePath),
                          fit: BoxFit.cover, width: double.infinity),
                    );
                  }).toList(),
                ),
              const SizedBox(height: 20),

              // Product Name & Price
              Text(
                product.productName,
                style:
                    const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '₹ ${product.salesRate.toStringAsFixed(2)}',
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
              const SizedBox(height: 16),

              // Additional Product Details
              const Text(
                'Product Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              detail_row(label: 'Code', value: product.productCode),
              detail_row(label: 'Material', value: product.type),
              detail_row(label: 'Dimensions', value: product.size),
              detail_row(
                label: 'Availability',
                value:
                    isOutOfStock ? 'Out of Stock' : product.quantity.toString(),
                valueStyle: isOutOfStock ? TextStyle(color: Colors.red) : null,
              ),
              detail_row(label: 'Manufacturer', value: 'Zoyo Bathware'),
              const SizedBox(height: 20),

              // Product Description
              const Text(
                'Description',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                product.description,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // Add to Cart Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isOutOfStock
                      ? null
                      : () async {
                          // addToCart(product);
                          updateQuantity(product, 1);
                          log('product added: ${product}');
                          _showCustomSnackBar(context, product);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isOutOfStock ? Colors.grey : Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    isOutOfStock ? 'Out of Stock' : 'Add to Cart',
                    style: TextStyle(
                        fontSize: 18,
                        color: isOutOfStock ? Colors.black : Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
