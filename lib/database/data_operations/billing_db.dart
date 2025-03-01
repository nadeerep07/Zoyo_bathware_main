import 'package:hive/hive.dart';

Future<int> loadBillNumber() async {
  var settingsBox = await Hive.openBox('settings');
  return settingsBox.get('billNumber', defaultValue: 1);
}

Future<void> updateBillNumber(int billNumber) async {
  var settingsBox = await Hive.openBox('settings');
  await settingsBox.put('billNumber', billNumber);
}

Future<void> saveInvoice({
  required String billNumber,
  required String customerName,
  required String phoneNumber,
  required String date,
  required List<Map<String, dynamic>> items,
  required double subtotal,
  required double discount,
  required double total,
  required double profit, // Add profit field
}) async {
  var invoiceBox = await Hive.openBox('invoices');
  await invoiceBox.add({
    'billNumber': billNumber,
    'customerName': customerName,
    'phoneNumber': phoneNumber,
    'date': date,
    'items': items,
    'subtotal': subtotal,
    'discount': discount,
    'total': total,
    'profit': profit, // Store profit
  });
}
