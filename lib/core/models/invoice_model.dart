import 'package:hive/hive.dart';

part 'invoice_model.g.dart';

@HiveType(typeId: 4)
class Invoice extends HiveObject {
  @HiveField(0)
  final int billNumber;

  @HiveField(1)
  final String customerName;

  @HiveField(2)
  final String phoneNumber;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final List<Map<String, dynamic>> items; // List of cart item details

  @HiveField(5)
  final double subtotal;

  @HiveField(6)
  final double discount;

  @HiveField(7)
  final double total;

  Invoice({
    required this.billNumber,
    required this.customerName,
    required this.phoneNumber,
    required this.date,
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.total,
  });
}
