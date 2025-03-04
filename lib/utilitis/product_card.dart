import 'dart:io';
import 'package:flutter/material.dart';
import 'package:zoyo_bathware/database/data_operations/cart_db.dart';
import 'package:zoyo_bathware/database/product_model.dart';
import 'package:zoyo_bathware/screens/billing_section/billing_screen.dart';
import 'package:zoyo_bathware/screens/detail_screens/details_screen.dart';
import 'package:zoyo_bathware/services/app_colors.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final bool isGridView;

  const ProductCard({
    super.key,
    required this.product,
    required this.isGridView,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive dimensions
    double cardHeight = screenHeight * 0.2;
    double imageHeight = isGridView ? screenHeight * 0.1 : screenHeight * 0.1;
    double margin = isGridView ? screenWidth * 0.02 : screenWidth * 0.03;
    double textFontSize = isGridView ? screenWidth * 0.04 : screenWidth * 0.035;
    double buttonHeight =
        isGridView ? screenHeight * 0.01 : screenHeight * 0.02;

    bool isOutOfStock = product.quantity == 0;

    void _showSnackBar() {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${product.productName} added to cart!',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          action: SnackBarAction(
            label: 'View Cart',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => BillingScreen()),
              );
            },
          ),
        ),
      );
    }

    if (isGridView) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailScreen(
                productCode: product.id!,
              ),
            ),
          );
          print('image is passing : ${product.imagePaths}');
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: margin, horizontal: margin),
          padding: EdgeInsets.all(margin),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 5,
                spreadRadius: 1,
                offset: const Offset(0, 2),
              )
            ],
          ),
          height: cardHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: product.imagePaths.isNotEmpty
                    ? Image.file(
                        File(product.imagePaths.first),
                        width: double.infinity,
                        height: imageHeight,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: double.infinity,
                        height: imageHeight,
                        color: Colors.grey[300],
                        child: const Center(
                          child:
                              Icon(Icons.image, size: 50, color: Colors.grey),
                        ),
                      ),
              ),
              const SizedBox(height: 6),
              Text(
                product.productName,
                style: TextStyle(
                  fontSize: textFontSize * 0.85,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                "Code: ${product.productCode}",
                style: TextStyle(
                  fontSize: textFontSize * 0.8,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                "ZRP: ₹${product.salesRate}",
                style: TextStyle(
                  fontSize: textFontSize,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                isOutOfStock
                    ? 'Out of Stock'
                    : 'Available: ${product.quantity}',
                style: TextStyle(
                  fontSize: textFontSize * 0.8,
                  color: isOutOfStock ? Colors.red : Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: EdgeInsets.symmetric(vertical: buttonHeight),
                    side: BorderSide(
                        color: isOutOfStock
                            ? Colors.grey
                            : Colors.orange.shade800),
                  ),
                  icon: Icon(Icons.shopping_cart,
                      color:
                          isOutOfStock ? Colors.grey : Colors.orange.shade800,
                      size: 18),
                  label: Text(
                    isOutOfStock ? "Out of Stock" : "Add to Cart",
                    style: TextStyle(
                        fontSize: textFontSize * 0.8,
                        color: isOutOfStock
                            ? Colors.grey
                            : Colors.orange.shade800),
                  ),
                  onPressed: isOutOfStock
                      ? null
                      : () {
                          updateQuantity(product, 1);
                          _showSnackBar(); // Show SnackBar
                        },
                ),
              ),
            ],
          ),
        ),
      );
    } else {
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
        child: Container(
          margin: EdgeInsets.symmetric(vertical: margin, horizontal: margin),
          padding: EdgeInsets.all(margin),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 5,
                spreadRadius: 1,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: product.imagePaths.isNotEmpty
                  ? Image.file(
                      File(product.imagePaths.first),
                      width: screenWidth * 0.2,
                      height: screenHeight * 0.1,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: screenWidth * 0.2,
                      height: screenHeight * 0.1,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.image, size: 30, color: Colors.grey),
                      ),
                    ),
            ),
            title: Text(
              product.productName,
              style: TextStyle(
                fontSize: textFontSize,
                fontWeight: FontWeight.w900,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "ZRP: ₹${product.salesRate}",
                  style: TextStyle(
                    fontSize: textFontSize,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isOutOfStock
                      ? 'Out of Stock'
                      : 'Available: ${product.quantity}',
                  style: TextStyle(
                    fontSize: textFontSize * 0.8,
                    color: isOutOfStock ? Colors.red : Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.shopping_cart,
                  color: isOutOfStock ? Colors.grey : Colors.orange.shade800),
              onPressed: isOutOfStock
                  ? null
                  : () {
                      updateQuantity(product, 1);
                      _showSnackBar(); // Show SnackBar
                    },
            ),
          ),
        ),
      );
    }
  }
}
