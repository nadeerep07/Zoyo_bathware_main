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
  double _minPrice = 0;
  double _maxPrice = 25000;
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
        return ListView.builder(
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_categories[index]),
              onTap: () {
                setState(() {
                  selectedCategory = _categories[index];
                  _filterProducts(_searchController.text);
                });
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
