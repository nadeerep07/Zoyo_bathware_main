import 'package:hive/hive.dart';
import 'package:zoyo_bathware/core/models/product_model.dart';
import 'package:zoyo_bathware/core/models/purchase_model.dart';


Future<void> addPurchase(Product product, int quantity) async {
  final purchaseBox = await Hive.openBox<Purchase>('purchases');
  final newPurchase = Purchase(
    productId: product.id!,
    productName: product.productName,
    quantityPurchased: quantity,
    purchaseRate: product.purchaseRate,
    salesRate: product.salesRate,
    purchaseDate: DateTime.now(),
  );

  await purchaseBox.add(newPurchase);
}
