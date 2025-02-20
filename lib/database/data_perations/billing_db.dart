import 'package:hive/hive.dart';

/// Loads the bill number from Hive.
Future<int> loadBillNumber() async {
  var settingsBox = await Hive.openBox('settings');
  return settingsBox.get('billNumber', defaultValue: 1);
}

/// Updates the bill number in Hive.
Future<void> updateBillNumber(int billNumber) async {
  var settingsBox = await Hive.openBox('settings');
  await settingsBox.put('billNumber', billNumber);
}

/// Saves invoice details to Hive.
Future<void> saveInvoice({
  required String billNumber,
  required String customerName,
  required String phoneNumber,
  required String date,
  required List<Map<String, dynamic>> items,
  required double subtotal,
  required double discount,
  required double total,
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
  });
}
