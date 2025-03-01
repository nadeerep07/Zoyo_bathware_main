import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:zoyo_bathware/database/product_model.dart';
import 'package:zoyo_bathware/services/app_colors.dart';
import 'package:zoyo_bathware/utilitis/custom_widgets/back_botton.dart';

const String productBox = 'products';

enum StockFilter { all, outOfStock, lowStock, highStock }

class StockManagementScreen extends StatefulWidget {
  const StockManagementScreen({super.key});

  @override
  _StockManagementScreenState createState() => _StockManagementScreenState();
}

class _StockManagementScreenState extends State<StockManagementScreen> {
  TextEditingController searchController = TextEditingController();
  List<Product> products = [];
  List<Product> filteredProducts = [];
  StockFilter selectedFilter = StockFilter.all;

  @override
  void initState() {
    super.initState();
    var box = Hive.box<Product>(productBox);
    products = box.values.toList();
    products.sort((a, b) => a.quantity.compareTo(b.quantity));
    filteredProducts = List.from(products);
  }

  void filterSearch(String query) {
    List<Product> tempList = products.where((product) {
      return product.productName.toLowerCase().contains(query.toLowerCase());
    }).toList();
    applyStockFilter(tempList);
  }

  void applyStockFilter([List<Product>? list]) {
    // Use provided list or current filteredProducts from search.
    List<Product> tempList = list ?? List.from(products);
    switch (selectedFilter) {
      case StockFilter.outOfStock:
        tempList = tempList.where((p) => p.quantity == 0).toList();
        break;
      case StockFilter.lowStock:
        tempList =
            tempList.where((p) => p.quantity > 0 && p.quantity <= 10).toList();
        break;
      case StockFilter.highStock:
        tempList = tempList.where((p) => p.quantity > 10).toList();
        break;
      case StockFilter.all:
        // no additional filtering
        break;
    }
    setState(() {
      filteredProducts = tempList;
    });
  }

  void onFilterChanged(StockFilter? filter) {
    if (filter == null) return;
    setState(() {
      selectedFilter = filter;
    });
    // Reapply both search and stock filter
    filterSearch(searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: backButton(context),
        title: const Text("Stock Management"),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Field
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search product...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0)),
              ),
              onChanged: filterSearch,
            ),
            const SizedBox(height: 10),
            // Dropdown for stock filter
            Row(
              children: [
                const Text("Filter by Stock: "),
                const SizedBox(width: 8),
                DropdownButton<StockFilter>(
                  value: selectedFilter,
                  items: const [
                    DropdownMenuItem(
                      value: StockFilter.all,
                      child: Text("All"),
                    ),
                    DropdownMenuItem(
                      value: StockFilter.outOfStock,
                      child: Text("Out of Stock"),
                    ),
                    DropdownMenuItem(
                      value: StockFilter.lowStock,
                      child: Text("Low Stock"),
                    ),
                    DropdownMenuItem(
                      value: StockFilter.highStock,
                      child: Text("High Stock"),
                    ),
                  ],
                  onChanged: onFilterChanged,
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Product list
            Expanded(
              child: ListView.separated(
                itemCount: filteredProducts.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      child: const Icon(Icons.inventory, color: Colors.blue),
                    ),
                    title: Text(product.productName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Display product code
                        Text("Code: ${product.productCode}"),
                        // Display quantity
                        Text("Quantity: ${product.quantity}"),
                      ],
                    ),
                    trailing: Text(
                      product.quantity == 0
                          ? "Out of Stock"
                          : product.quantity <= 10
                              ? "Low Stock"
                              : "High Stock",
                      style: TextStyle(
                        color: product.quantity == 0
                            ? Colors.red
                            : product.quantity <= 10
                                ? Colors.orange
                                : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
