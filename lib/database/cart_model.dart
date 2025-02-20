import 'package:hive/hive.dart';

part 'cart_model.g.dart';

@HiveType(typeId: 2)
class Cart {
  @HiveField(0)
  final String cartId;

  @HiveField(1)
  final String productId;

  @HiveField(2)
  int quantity;

  @HiveField(3)
  DateTime addedAt;

  Cart({
    required this.cartId,
    required this.productId,
    required this.quantity,
    required this.addedAt,
  });
}
