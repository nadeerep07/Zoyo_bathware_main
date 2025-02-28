import 'dart:io';
import 'package:flutter/material.dart';
import 'package:zoyo_bathware/database/product_model.dart';

class ProductList extends StatelessWidget {
  final List<Product> products;
  final void Function(Product) onAdd;

  const ProductList({required this.products, required this.onAdd, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ListTile(
          leading: Image.file(
            File(product.imagePaths.first),
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
          title: Text(product.productName),
          subtitle: Text("₹${product.salesRate}"),
          trailing: IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => onAdd(product),
          ),
        );
      },
    );
  }
}
