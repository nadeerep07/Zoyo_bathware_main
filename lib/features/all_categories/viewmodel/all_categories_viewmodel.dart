// all_categories_viewmodel.dart
import 'package:flutter/foundation.dart';
import 'package:zoyo_bathware/core/models/category_model.dart';
import 'package:zoyo_bathware/database/data_operations/category_db.dart';

class AllCategoriesViewModel extends ChangeNotifier {
  bool _isGridView = true;
  bool get isGridView => _isGridView;

  List<ProductCategory> _categories = [];
  List<ProductCategory> get categories => _categories
      .where((category) => category.name.toLowerCase().trim() != 'cabinet')
      .toList();

  AllCategoriesViewModel() {
    loadCategories();
  }

  void toggleView() {
    _isGridView = !_isGridView;
    notifyListeners();
  }

  void loadCategories() {
    // Listen to Hive categoriesNotifier
    categoriesNotifier.addListener(() {
      _categories = categoriesNotifier.value;
      notifyListeners();
    });

    // Initial load
    _categories = categoriesNotifier.value;
  }
}
