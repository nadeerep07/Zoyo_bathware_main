import 'dart:io';
import 'package:flutter/material.dart';
import 'package:zoyo_bathware/database/data_perations/cart_db.dart';
import 'package:zoyo_bathware/database/product_model.dart';
import 'package:zoyo_bathware/services/app_colors.dart';
import 'package:intl/intl.dart';

class BillingScreen extends StatefulWidget {
  const BillingScreen({super.key});

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  double totalAmount = 0;
  double discount = 0;
  int billNumber = 1; // Replace with logic to fetch last stored bill number
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController discountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchLastBillNumber();
  }

  void fetchLastBillNumber() {
    // TODO: Fetch last stored bill number from persistent storage (Hive/SQLite)
    // Example: billNumber = getLastStoredBillNumber() + 1;
    setState(() {
      billNumber += 1;
    });
  }

  void calculateTotal() {
    totalAmount = cartNotifier.value.fold(
        0, (sum, product) => sum + (product.salesRate * product.quantity));
  }

  void clearCart() {
    cartNotifier.value.clear();
    calculateTotal();
    setState(() {});
  }

  void showCustomerDetailsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Enter Customer Details"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: customerNameController,
                decoration: InputDecoration(
                  labelText: "Customer Name",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Phone Number",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Billing',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: billingScreenMethod(),
    );
  }

  Widget billingScreenMethod() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Bill No: $billNumber",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(
                      "Date: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}",
                      style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ValueListenableBuilder<List<Product>>(
              valueListenable: cartNotifier,
              builder: (context, cartItems, _) {
                calculateTotal();
                return cartItems.isEmpty
                    ? Center(child: Text("No products added"))
                    : ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final product = cartItems[index];
                          return Card(
                            elevation: 2,
                            margin: EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              leading: Image.file(
                                  File(product.imagePaths.first),
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover),
                              title: Text(product.productName,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                  "₹${product.salesRate} x ${product.quantity}"),
                              trailing: Text(
                                  "₹${(product.salesRate * product.quantity).toStringAsFixed(2)}"),
                            ),
                          );
                        },
                      );
              },
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: clearCart,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(vertical: 16)),
                  child: Text('Cancel', style: TextStyle(fontSize: 16)),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: showCustomerDetailsDialog,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 16)),
                  child: Text('Order', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
