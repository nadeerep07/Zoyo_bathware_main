// category_product_viewmodel.dart
import 'package:flutter/foundation.dart';
import 'package:zoyo_bathware/core/models/product_model.dart';
import 'package:zoyo_bathware/database/data_operations/product_db.dart';

class CategoryProductViewModel extends ChangeNotifier {
  final String categoryName;
  List<Product> products = [];
  bool isGridView = true;

  CategoryProductViewModel({required this.categoryName}) {
    loadProducts();
  }

  void loadProducts() {
    final allProducts = getAllProductsSync();
    products = allProducts
        .where((product) => product.category == categoryName)
        .toList();
    notifyListeners();
  }

  void toggleView() {
    isGridView = !isGridView;
    notifyListeners();
  }
}
