// home_viewmodel.dart
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:zoyo_bathware/core/models/product_model.dart';

class HomeViewModel extends ChangeNotifier {
  List<Product> newArrivals = [];
  List<String> carouselImages = [];

  bool isLoading = true;

  HomeViewModel() {
    refreshData();
  }

  Future<void> fetchNewArrivals() async {
    final box = await Hive.openBox<Product>('products');
    final products = box.values.toList();

    products.sort((a, b) => b.purchaseDate.first.compareTo(a.purchaseDate.first));
    newArrivals = products.take(6).toList();
    notifyListeners();
  }

  Future<void> fetchCarouselImages() async {
    final box = await Hive.openBox<String>('carousel_images');
    carouselImages = box.values.toList();
    notifyListeners();
  }

  Future<void> refreshData() async {
    isLoading = true;
    notifyListeners();

    await Future.wait([
      fetchNewArrivals(),
      fetchCarouselImages(),
    ]);

    isLoading = false;
    notifyListeners();
  }
}
