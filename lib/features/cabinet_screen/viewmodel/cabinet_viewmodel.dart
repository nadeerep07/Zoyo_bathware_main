// cabinet_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:zoyo_bathware/core/models/category_model.dart';
import 'package:zoyo_bathware/core/models/product_model.dart';
import 'package:zoyo_bathware/database/data_operations/category_db.dart';

class CabinetViewModel extends ChangeNotifier {
  List<Product> filteredProducts = [];
  ValueNotifier<bool> isGridView = ValueNotifier<bool>(true);

  late Box<ProductCategory> _categoryBox;
  late Box<Product> _productBox;

  CabinetViewModel() {
    _init();
  }

  Future<void> _init() async {
    await openHiveBoxes();
    loadCabinetProducts();
  }

  Future<void> openHiveBoxes() async {
    _categoryBox = await Hive.openBox<ProductCategory>(categoryBox);
    _productBox = await Hive.openBox<Product>('products');
  }

  void loadCabinetProducts() {
    final allProducts = _productBox.values.toList();

    final cabinetCategory = _categoryBox.values.firstWhere(
      (category) => category.name.toLowerCase().trim() == 'cabinet',
      orElse: () =>
          ProductCategory(name: 'cabinet', imagePath: '', id: ''), // fallback
    );

    filteredProducts = allProducts
        .where((product) =>
            product.category.toString().trim() ==
            cabinetCategory.name.toString().trim())
        .toList();

    notifyListeners();
  }

  void toggleView() {
    isGridView.value = !isGridView.value;
  }
}
