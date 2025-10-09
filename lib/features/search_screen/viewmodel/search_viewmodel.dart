import 'package:flutter/material.dart';
import 'package:zoyo_bathware/core/models/product_model.dart';
import 'package:zoyo_bathware/database/data_operations/category_db.dart';
import 'package:zoyo_bathware/database/data_operations/product_db.dart';

class SearchViewModel extends ChangeNotifier {
  // Private state
  List<Product> _filteredProducts = [];
  List<String> _categories = ['All Categories'];
  String _selectedCategory = 'All Categories';
  final double _minPrice = 0;
  final double _maxPrice = 40000;
  RangeValues _priceRange = const RangeValues(0, 40000);
  bool _showOutOfStock = true;
  int _selectedSortOption = 0;
  bool _showFilters = false;
  bool _isLoading = true;

  // Getters
  List<Product> get filteredProducts => _filteredProducts;
  List<String> get categories => _categories;
  String get selectedCategory => _selectedCategory;
  double get minPrice => _minPrice;
  double get maxPrice => _maxPrice;
  RangeValues get priceRange => _priceRange;
  bool get showOutOfStock => _showOutOfStock;
  int get selectedSortOption => _selectedSortOption;
  bool get showFilters => _showFilters;
  bool get isLoading => _isLoading;

  int get productCount => _filteredProducts.isEmpty 
      ? productsNotifier.value.length 
      : _filteredProducts.length;

  List<Product> get displayedProducts => 
      _filteredProducts.isNotEmpty ? _filteredProducts : productsNotifier.value;

  // Initialization
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    await getAllProducts();
    await _loadCategories();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadCategories() async {
    await getAllCategories();
    if (categoriesNotifier.value.isNotEmpty) {
      _categories = [
        'All Categories',
        ...categoriesNotifier.value.map((e) => e.name)
      ];
      notifyListeners();
    }
  }

  // Filter operations
  void filterProducts(String query) {
    List<Product> filteredList = productsNotifier.value.where((product) {
      final nameLower = product.productName.toLowerCase();
      final codeLower = product.productCode.toLowerCase();
      final searchLower = query.toLowerCase();

      bool matchesSearch =
          nameLower.contains(searchLower) || codeLower.contains(searchLower);
      bool matchesCategory = _selectedCategory == 'All Categories' ||
          product.category == _selectedCategory;
      bool matchesPrice = product.salesRate >= _priceRange.start &&
          product.salesRate <= _priceRange.end;
      bool matchesStock = !_showOutOfStock || product.quantity > 0;

      return matchesSearch && matchesCategory && matchesPrice && matchesStock;
    }).toList();

    _filteredProducts = filteredList;
    _sortProducts();
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
    _filteredProducts = sortedProducts;
    notifyListeners();
  }

  // UI state updates
  void toggleFilters() {
    _showFilters = !_showFilters;
    notifyListeners();
  }

  void updatePriceRange(RangeValues values, String searchQuery) {
    _priceRange = values;
    notifyListeners();
    filterProducts(searchQuery);
  }

  void updateCategory(String category, String searchQuery) {
    _selectedCategory = category;
    notifyListeners();
    filterProducts(searchQuery);
  }

  void updateSortOption(int option) {
    _selectedSortOption = option;
    _sortProducts();
  }

  void toggleShowOutOfStock(bool value, String searchQuery) {
    _showOutOfStock = value;
    notifyListeners();
    filterProducts(searchQuery);
  }

  // Category helpers
  int getProductCountForCategory(String category) {
    if (category == 'All Categories') {
      return productsNotifier.value.length;
    }
    return productsNotifier.value
        .where((product) => product.category == category)
        .length;
  }

  int getTotalProductCount() {
    return productsNotifier.value.length;
  }
}