// product_detail_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:zoyo_bathware/core/models/product_model.dart';
import 'package:zoyo_bathware/database/data_operations/cart_db.dart';

class ProductDetailViewModel extends ChangeNotifier {
  final String productCode;
  Product? product;
  bool isFavorite = false;
  bool isAddingToCart = false;
  int currentImageIndex = 0;

  static const String productBox = 'products';

  ProductDetailViewModel({required this.productCode}) {
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    var box = await Hive.openBox<Product>(productBox);
    product = box.get(productCode);
    notifyListeners();
  }

  void toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  void updateImageIndex(int index) {
    currentImageIndex = index;
    notifyListeners();
  }

  Future<void> addToCart() async {
    if (product == null || isAddingToCart || product!.quantity == 0) return;

    isAddingToCart = true;
    notifyListeners();

    updateQuantity(product!, 1);

    isAddingToCart = false;
    notifyListeners();
  }

  bool get isOutOfStock => product?.quantity == 0;
}
