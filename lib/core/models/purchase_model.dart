import 'package:hive/hive.dart';

part 'purchase_model.g.dart';

@HiveType(typeId: 5)
class Purchase extends HiveObject {
  @HiveField(0)
  String productId;

  @HiveField(1)
  String productName;

  @HiveField(2)
  int quantityPurchased;

  @HiveField(3)
  double purchaseRate;

  @HiveField(4)
  double salesRate;

  @HiveField(5)
  DateTime purchaseDate;

  Purchase({
    required this.productId,
    required this.productName,
    required this.quantityPurchased,
    required this.purchaseRate,
    required this.salesRate,
    required this.purchaseDate,
  });
}
