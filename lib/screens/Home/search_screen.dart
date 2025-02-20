import 'package:flutter/material.dart';
import 'package:zoyo_bathware/database/data_perations/category_db.dart';
import 'package:zoyo_bathware/database/data_perations/product_db.dart';
import 'package:zoyo_bathware/utilitis/product_card.dart';
import 'package:zoyo_bathware/utilitis/widgets/back_botton.dart';
import 'package:zoyo_bathware/database/product_model.dart';
import 'package:zoyo_bathware/services/app_colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _filteredProducts = [];
  List<String> _categories = ['All Categories'];
  String selectedCategory = 'All Categories';
  final double _minPrice = 0;
  final double _maxPrice = 40000;
  bool showOutOfStock = true;
  int _selectedSortOption = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getAllProducts();
      getAllCategory();
    });
  }

  void _filterProducts(String query) {
    List<Product> filteredList = productsNotifier.value.where((product) {
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

    setState(() {
      _filteredProducts = filteredList;
      _sortProducts();
    });
  }

  void _sortProducts() {
    List<Product> sortedProducts = List.from(_filteredProducts);
    switch (_selectedSortOption) {
      case 0:
        sortedProducts.sort((a, b) => a.productName.compareTo(b.productName));
        break;
      case 1:
        sortedProducts.sort((a, b) => a.salesRate.compareTo(b.salesRate));
        break;
      case 2:
        sortedProducts.sort((a, b) => b.salesRate.compareTo(a.salesRate));
        break;
    }
    setState(() {
      _filteredProducts = sortedProducts;
    });
  }

  Future<void> getAllCategory() async {
    await getAllCategories();
    if (categoriesNotifier.value.isNotEmpty) {
      setState(() {
        _categories = [
          'All Categories',
          ...categoriesNotifier.value.map((e) => e.name)
        ];
      });
    }
  }

// screen...................................................
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(child: _buildProductGrid()),
        ],
      ),
      bottomNavigationBar: ColoredBox(
          color: AppColors.primaryColor, child: _buildBottomNavigationBar()),
    );
  }
  // ..................................................................

  AppBar _buildAppBar() {
    return AppBar(
      leading: backButton(context),
      title: const Text("Search",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      centerTitle: true,
      backgroundColor: AppColors.primaryColor,
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        onChanged: _filterProducts,
        decoration: InputDecoration(
          hintText: "Search for Products",
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildProductGrid() {
    final displayedProducts =
        _filteredProducts.isNotEmpty || _searchController.text.isNotEmpty
            ? _filteredProducts
            : productsNotifier.value;

    if (displayedProducts.isEmpty) {
      return const Center(child: Text("No products found"));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.6,
      ),
      itemCount: displayedProducts.length,
      itemBuilder: (context, index) {
        return ProductCard(isGridView: true, product: displayedProducts[index]);
      },
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      selectedItemColor: AppColors.primaryColor,
      unselectedItemColor: Colors.grey,
      currentIndex: _selectedSortOption,
      onTap: (index) {
        setState(() {
          if (index < 3) {
            _selectedSortOption = index;
            _sortProducts();
          } else if (index == 3) {
            showOutOfStock = !showOutOfStock;
            _filterProducts(_searchController.text);
          } else if (index == 4) {
            _showCategorySelection();
          }
        });
      },
      items: [
        const BottomNavigationBarItem(
            icon: Icon(Icons.sort_by_alpha), label: "Name"),
        const BottomNavigationBarItem(
            icon: Icon(Icons.arrow_upward), label: "Price Low"),
        const BottomNavigationBarItem(
            icon: Icon(Icons.arrow_downward), label: "Price High"),
        BottomNavigationBarItem(
            icon:
                Icon(showOutOfStock ? Icons.visibility : Icons.visibility_off),
            label: "Stock"),
        const BottomNavigationBarItem(
            icon: Icon(Icons.category), label: "Category"),
      ],
    );
  }

  void _showCategorySelection() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        int totalProductCount = _getTotalProductCount();

        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Products: $totalProductCount',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    String category = _categories[index];

                    int productCount = _getProductCountForCategory(category);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = category;
                          _filterProducts(_searchController.text);
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(color: Colors.grey.shade300, width: 1),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              category,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // product counts
                            Text(
                              '($productCount)',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  int _getProductCountForCategory(String category) {
    return productsNotifier.value
        .where((product) => product.category == category)
        .length;
  }

  int _getTotalProductCount() {
    return productsNotifier.value.length;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
