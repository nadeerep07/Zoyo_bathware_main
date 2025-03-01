import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:zoyo_bathware/database/data_operations/cart_db.dart';
import 'package:zoyo_bathware/database/product_model.dart';

const String productBox = 'products';
final ValueNotifier<List<Product>> productsNotifier = ValueNotifier([]);

Future<void> addProduct(Product product) async {
  var box = Hive.box<Product>(productBox);

  bool productExists = box.values.any(
      (existingProduct) => existingProduct.productCode == product.productCode);

  if (productExists) {
    print('Product Code already exists!');
    return;
  }

  await box.put(product.id, product);
  getAllProducts();
  productsNotifier.notifyListeners();

  // cartNotifier.value.add(product);
  cartNotifier.notifyListeners();
}

Future<void> updateProduct(String productId, Product updatedProduct) async {
  var box = Hive.box<Product>(productBox);
  await box.put(productId, updatedProduct);
  getAllProducts();
  productsNotifier.notifyListeners();

  // Refresh cart and notify listeners
  cartNotifier.notifyListeners();
}

Future<void> getAllProducts() async {
  var box = Hive.box<Product>(productBox);
  //  WidgetsBinding.instance.addPostFrameCallback((_) {
  //   getAllProducts(); // Fetch products after the first frame
  // });
  productsNotifier.value = box.values.toList();
  productsNotifier.notifyListeners();
}

Future<void> deleteProduct(String productId) async {
  var box = Hive.box<Product>(productBox);
  await box.delete(productId);
  getAllProducts();
  productsNotifier.notifyListeners();
}

// Synchronous method to get all products
List<Product> getAllProductsSync() {
  var box = Hive.box<Product>(productBox);
  return box.values.toList();
}

// Future<void> returnProduct(String productId, int quantity) async {
//   final box = await Hive.openBox<Product>('products');
//   final product = box.get(productId);

//   if (product != null) {
//     product.quantity += quantity; // Increase the quantity for returned items
//     await box.put(productId, product);
//   }
// }
