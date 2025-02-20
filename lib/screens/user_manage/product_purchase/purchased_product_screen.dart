import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zoyo_bathware/database/product_model.dart';
import 'package:intl/intl.dart';
import 'package:zoyo_bathware/services/app_colors.dart';

const String productBox = 'products';

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
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Product>(productBox).listenable(),
        builder: (context, Box<Product> box, _) {
          List<Product> allProducts = box.values.toList();
          List<Product> purchasedProducts = allProducts
              .where((product) => product.purchaseDate.isNotEmpty)
              .where((product) =>
                  _selectedDate == null ||
                  product.purchaseDate.any((date) =>
                      DateFormat('yyyy-MM-dd').format(date) ==
                      DateFormat('yyyy-MM-dd')
                          .format(_selectedDate ?? DateTime.now())))
              .toList();

          if (purchasedProducts.isEmpty) {
            return const Center(child: Text('No purchased products found'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: purchasedProducts.length,
              itemBuilder: (context, index) {
                Product product = purchasedProducts[index];
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
                                product.productName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text('Purchased Quantity: ${product.quantity}',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black54)),
                              Text('Purchase Rate: ₹${product.purchaseRate}',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black54)),
                              Text('Sale Rate: ₹${product.salesRate}',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black54)),
                              Text(
                                  'Purchase Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate ?? DateTime.now())}',
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
