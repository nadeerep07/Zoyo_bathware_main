import 'package:flutter/material.dart';
import 'package:zoyo_bathware/database/CrudOperations/data_services.dart';
import 'package:zoyo_bathware/database/category_model.dart';
import 'package:zoyo_bathware/database/product_model.dart';
import 'package:zoyo_bathware/utilitis/product_card.dart';
import 'package:zoyo_bathware/utilitis/widgets/back_botton.dart';

class CategoryToAllProduct extends StatefulWidget {
  final Category category;

  const CategoryToAllProduct({super.key, required this.category});

  @override
  State<CategoryToAllProduct> createState() => _CategoryToAllProductState();
}

class _CategoryToAllProductState extends State<CategoryToAllProduct> {
  List<Product> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    // Get all products and filter based on the selected category
    filteredProducts = getAllProductsSync()
        .where((product) => product.category == widget.category.name)
        .toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: backButton(context),
        title: Text(widget.category.name),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: filteredProducts.isEmpty
            ? const Center(
                child: Text(
                  "No products found in this category",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.6, // Slightly taller cards
                ),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  return ProductCard(product: filteredProducts[index]);
                },
              ),
      ),
    );
  }
}
