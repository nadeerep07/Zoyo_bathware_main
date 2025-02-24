import 'dart:io';
import 'package:flutter/material.dart';
import 'package:zoyo_bathware/database/data_operations/cart_db.dart';
import 'package:zoyo_bathware/database/product_model.dart';
import 'package:zoyo_bathware/screens/detail_screens/details_screen.dart';
import 'package:zoyo_bathware/services/app_colors.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final bool isGridView;

  const ProductCard(
      {super.key, required this.product, required this.isGridView});

  @override
  Widget build(BuildContext context) {
    double cardHeight = 250.0;
    double imageHeight = isGridView ? 100.0 : 100.0;
    double margin = isGridView ? 8.0 : 10.0;
    double textFontSize = isGridView ? 16.0 : 14.0;
    double buttonHeight = isGridView ? 15.0 : 45.0;

    bool isOutOfStock = product.quantity == 0;

    if (isGridView) {
      return GestureDetector(
        onTap: () {
          if (!isOutOfStock) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailScreen(
                  productCode: product.id!,
                ),
              ),
            );
            print('image is passing : ${product.imagePaths}');
          }
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: margin, horizontal: 10),
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
                        width: 120,
                        height: imageHeight,
                        color: Colors.grey[300],
                        child: const Center(
                          child:
                              Icon(Icons.image, size: 50, color: Colors.grey),
                        ),
                      ),
              ),
              Text(
                product.productName,
                style: TextStyle(
                  fontSize: textFontSize,
                  fontWeight: FontWeight.w900,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    "ZRP:${product.salesRate}",
                    style: TextStyle(
                      fontSize: textFontSize,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                isOutOfStock
                    ? 'Out of Stock'
                    : 'Available: ${product.quantity}',
                style: TextStyle(
                  fontSize: 14,
                  color: isOutOfStock ? Colors.red : Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
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
                        fontSize: 13,
                        color: isOutOfStock
                            ? Colors.grey
                            : Colors.orange.shade800),
                  ),
                  onPressed: isOutOfStock
                      ? null
                      : () {
                          updateQuantity(product, 1);
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
          if (!isOutOfStock) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ProductDetailScreen(productCode: product.id!),
              ),
            );
          }
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: margin, horizontal: 10),
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
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: product.imagePaths.isNotEmpty
                  ? Image.file(
                      File(product.imagePaths.first),
                      width: 60,
                      height: 80.0,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 60,
                      height: 80.0,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.image, size: 30, color: Colors.grey),
                      ),
                    ),
            ),
            title: Text(
              product.productName,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w900,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "ZRP: ${product.salesRate}",
                  style: TextStyle(
                    fontSize: 14.0,
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
                    fontSize: 12.0,
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
                    },
            ),
          ),
        ),
      );
    }
  }
}
