import 'dart:io';
import 'package:flutter/material.dart';
import 'package:zoyo_bathware/database/product_model.dart';
import 'package:zoyo_bathware/utilitis/billing_widgets/cart_item_controls.dart';

class CartItemTile extends StatelessWidget {
  final Product product;
  final void Function(Product) onRemove;
  final void Function(int) onQuantityChange;

  const CartItemTile({
    required this.product,
    required this.onRemove,
    required this.onQuantityChange,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Image.file(
          File(product.imagePaths.first),
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(product.productName,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("₹${product.salesRate}"),
        trailing: CartItemControls(
          product: product,
          onRemove: onRemove,
          onQuantityChange: onQuantityChange,
        ),
      ),
    );
  }
}
