import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zoyo_bathware/database/purchase_model.dart';
import 'package:zoyo_bathware/database/product_model.dart';
import 'package:intl/intl.dart';
import 'package:zoyo_bathware/services/app_colors.dart';

class PurchasedProductsScreen extends StatefulWidget {
  const PurchasedProductsScreen({super.key});

  @override
  _PurchasedProductsScreenState createState() =>
      _PurchasedProductsScreenState();
}

class _PurchasedProductsScreenState extends State<PurchasedProductsScreen> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchased Products'),
        backgroundColor: AppColors.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null) {
                setState(() {
                  _selectedDate = pickedDate;
                });
              }
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: Hive.openBox<Purchase>('purchases'),
        builder: (context, AsyncSnapshot<Box<Purchase>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          Box<Purchase> purchaseBox = snapshot.data!;
          List<Purchase> allPurchases = purchaseBox.values.toList();
          final productBox = Hive.box<Product>('products');

          // Filter purchases by selected date
          List<Purchase> filteredPurchases = allPurchases.where((purchase) {
            return _selectedDate == null ||
                DateFormat('yyyy-MM-dd').format(purchase.purchaseDate) ==
                    DateFormat('yyyy-MM-dd').format(_selectedDate!);
          }).toList();

          if (filteredPurchases.isEmpty) {
            return const Center(child: Text('No purchase history found'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: filteredPurchases.length,
              itemBuilder: (context, index) {
                Purchase purchase = filteredPurchases[index];
                Product? updatedProduct =
                    productBox.get(purchase.productId); // Get updated product

                return Card(
                  elevation: 8,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.shopping_bag,
                            size: 30,
                            color: Colors.deepPurple,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                updatedProduct?.productName ??
                                    purchase
                                        .productName, // Show updated or old name
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                  'Purchased Quantity: ${purchase.quantityPurchased}',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black54)),
                              Text('Purchase Rate: ₹${purchase.purchaseRate}',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black54)),
                              Text(
                                  'Sale Rate (Updated): ₹${updatedProduct?.salesRate ?? purchase.salesRate}',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black54)),
                              Text(
                                  'Purchase Date: ${DateFormat('yyyy-MM-dd').format(purchase.purchaseDate)}',
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.black45)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
