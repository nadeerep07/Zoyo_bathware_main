import 'dart:io';
import 'package:flutter/material.dart';
import 'package:zoyo_bathware/database/CrudOperations/category_db.dart';
import 'package:zoyo_bathware/utilitis/product_card.dart';
import 'package:zoyo_bathware/utilitis/widgets/back_botton.dart';
import 'package:zoyo_bathware/database/product_model.dart';
import 'package:zoyo_bathware/database/CrudOperations/data_services.dart';
import 'package:zoyo_bathware/services/app_colors.dart';
import 'package:zoyo_bathware/database/category_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _filteredProducts = [];

  // New Filter Variables
  String selectedCategory = 'All Categories';
  double _minPrice = 0;
  double _maxPrice = 25000; // Set default max price as per your data
  bool showOutOfStock = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getAllProducts(); // Fetch products after the first frame
      CategoryDatabaseHelper.getAllCategories(); // Fetch categories on init
    });
  }

  void _filterProducts(String query) {
    setState(() {
      _filteredProducts = productsNotifier.value.where((product) {
        final nameLower = product.productName.toLowerCase();
        final codeLower = product.productCode.toLowerCase();
        final searchLower = query.toLowerCase();

        bool matchesSearch =
            nameLower.contains(searchLower) || codeLower.contains(searchLower);

        bool matchesCategory = selectedCategory == 'All Categories' ||
            product.category == selectedCategory;

        bool matchesPrice =
            product.salesRate >= _minPrice && product.salesRate <= _maxPrice;

        bool matchesStock = !showOutOfStock || product.quantity > 0;

        return matchesSearch && matchesCategory && matchesPrice && matchesStock;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: backButton(context),
        title: const Text(
          "Search",
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        actions: [
          TextButton(
            onPressed: () {
              _searchController.clear();
              _filterProducts('');
            },
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _filterProducts,
                decoration: const InputDecoration(
                  hintText: "Search for Products",
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ),
          // Filters UI
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Category Filter
                ValueListenableBuilder<List<Category>>(
                  valueListenable: CategoryDatabaseHelper.categoriesNotifier,
                  builder: (context, categories, _) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: DropdownButton<String>(
                        value: selectedCategory,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedCategory = newValue!;
                            _filterProducts(_searchController.text);
                          });
                        },
                        isExpanded: true,
                        underline: Container(),
                        icon: const Icon(Icons.arrow_drop_down,
                            color: Colors.black),
                        items: ['All Categories']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList() +
                            categories
                                .map<DropdownMenuItem<String>>((category) {
                              return DropdownMenuItem<String>(
                                value: category.name,
                                child: Text(category.name),
                              );
                            }).toList(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Price Range Filter
                Column(
                  children: [
                    const Text(
                      'Price Range',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    RangeSlider(
                      values: RangeValues(_minPrice, _maxPrice),
                      min: 0,
                      max: 25000,
                      divisions: 10,
                      labels: RangeLabels('₹$_minPrice', '₹$_maxPrice'),
                      onChanged: (RangeValues values) {
                        setState(() {
                          _minPrice = values.start;
                          _maxPrice = values.end;
                          _filterProducts(_searchController.text);
                        });
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('₹${_minPrice.toInt()}'),
                        Text('₹${_maxPrice.toInt()}'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Out of Stock Filter
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Show Out of Stock",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    Switch(
                      value: showOutOfStock,
                      onChanged: (bool value) {
                        setState(() {
                          showOutOfStock = value;
                          _filterProducts(_searchController.text);
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<List<Product>>(
              valueListenable: productsNotifier,
              builder: (context, products, _) {
                final displayedProducts = _searchController.text.isEmpty
                    ? products
                    : _filteredProducts;

                if (displayedProducts.isEmpty) {
                  return const Center(
                    child: Text("No products found"),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.6,
                    crossAxisSpacing: 0.5,
                    mainAxisSpacing: 0.5,
                  ),
                  itemCount: displayedProducts.length,
                  itemBuilder: (context, index) {
                    final product = displayedProducts[index];
                    return ProductCard(product: product);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
