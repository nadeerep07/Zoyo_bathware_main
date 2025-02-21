import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:zoyo_bathware/database/category_model.dart';
import 'package:zoyo_bathware/database/data_operations/category_db.dart';
import 'package:zoyo_bathware/database/product_model.dart';
import 'package:zoyo_bathware/screens/billing_section/billing_screen.dart';
import 'package:zoyo_bathware/screens/home/home_screen.dart';
import 'package:zoyo_bathware/screens/all_categories/all_categories.dart';
import 'package:zoyo_bathware/screens/user_manage/manage_screen.dart';
import 'package:zoyo_bathware/services/app_colors.dart';
import 'package:zoyo_bathware/utilitis/product_card.dart';
import 'package:zoyo_bathware/utilitis/widgets/back_botton.dart';
import 'package:zoyo_bathware/utilitis/widgets/bottom_navigation.dart';

class CabinetScreen extends StatefulWidget {
  const CabinetScreen({
    super.key,
  });

  @override
  State<CabinetScreen> createState() => _CabinetScreenState();
}

class _CabinetScreenState extends State<CabinetScreen> {
  int _selectedIndex = 2; // Set Manage as the selected tab

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AllCategories()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CabinetScreen()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ManageScreen()),
        );
        break;
      default:
        break;
    }
  }

  List<Product> filteredProducts = [];
  ValueNotifier<bool> isGridView = ValueNotifier<bool>(true);

  late Box<Category> _categoryBox;
  late Box<Product> _productBox;

  @override
  void initState() {
    super.initState();
    openHiveBoxes().then((_) {
      loadCabinetProducts();
    });
  }

  Future<void> openHiveBoxes() async {
    print("Opening Hive boxes...");
    _categoryBox = await Hive.openBox<Category>(categoryBox);
    _productBox = await Hive.openBox<Product>('products');
    print("Hive boxes opened successfully!");
  }

  void loadCabinetProducts() {
    print("Fetching products for Cabinet category...");
    final allProducts = _productBox.values.toList();
    for (var product in allProducts) {
      print(
          "Product: '${product.productName}', Category ID: ${product.category}");
    }

    final cabinetCategory = _categoryBox.values.firstWhere(
      (category) => category.name.toLowerCase().trim() == 'cabinet',
    ); // Find the cabinet category
    for (var category in _categoryBox.values) {
      print("Category: '${category.name}', ID: ${category.id}");
    }

    filteredProducts = allProducts.where((product) {
      return product.category.toString().trim() ==
          cabinetCategory.name.toString().trim();
    }).toList();

    print("Filtered products count: ${filteredProducts.length}");

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print("Building UI with ${filteredProducts.length} products.");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        leading: backButton(context),
        title: Text('Cabinets'),
        actions: [
          IconButton(
            icon: Icon(Icons.view_list),
            onPressed: () {
              isGridView.value = !isGridView.value;
            },
          ),
        ],
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
            : ValueListenableBuilder<bool>(
                valueListenable: isGridView,
                builder: (context, isGrid, _) {
                  return isGrid
                      ? GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.63,
                          ),
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            return ProductCard(
                              product: filteredProducts[index],
                              isGridView: true,
                            );
                          },
                        )
                      : ListView.builder(
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            return ProductCard(
                              product: filteredProducts[index],
                              isGridView: false,
                            );
                          },
                        );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => BillingScreen()));
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.shopping_cart, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
