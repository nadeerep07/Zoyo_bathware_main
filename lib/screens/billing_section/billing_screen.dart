import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:zoyo_bathware/database/cart_model.dart';
import 'package:zoyo_bathware/database/data_perations/billing_db.dart';
import 'package:zoyo_bathware/database/data_perations/cart_db.dart';
import 'package:zoyo_bathware/database/product_model.dart';
import 'package:zoyo_bathware/services/app_colors.dart';
import 'package:zoyo_bathware/services/invoice_generator.dart';

class BillingScreen extends StatefulWidget {
  const BillingScreen({super.key});

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  double totalAmount = 0;
  double discount = 0;
  int billNumber = 1;
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  List<Product> allProducts = [];
  List<Product> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _loadBillNumber();
    fetchProducts();

    cartNotifier.addListener(() {
      if (mounted) {
        calculateTotal();
        setState(() {});
      }
    });
  }

  Future<void> _loadBillNumber() async {
    billNumber = await loadBillNumber();
    setState(() {});
  }

  @override
  void dispose() {
    cartNotifier.removeListener(() {});
    customerNameController.dispose();
    phoneController.dispose();
    discountController.dispose();
    searchController.dispose();
    super.dispose();
  }

  Future<void> generateAndPrintBill() async {
    final formattedBillNumber = billNumber.toString().padLeft(5, '0');

    await generateInvoicePdf(
      billNumber: billNumber,
      customerName: customerNameController.text,
      phone: phoneController.text,
      totalAmount: totalAmount,
      discount: discount,
      cartProducts: cartNotifier.value,
    );

    // Prepare invoice items for saving
    List<Map<String, dynamic>> invoiceItems = List.generate(
      cartNotifier.value.length,
      (index) {
        final product = cartNotifier.value[index];
        return {
          'sno': index + 1,
          'productName': product.productName,
          'rate': product.salesRate,
          'quantity': product.quantity,
          'total': (product.salesRate * product.quantity).toStringAsFixed(2),
        };
      },
    );

    // Save invoice in Hive
    await saveInvoice(
      billNumber: formattedBillNumber,
      customerName: customerNameController.text,
      phoneNumber: phoneController.text,
      date: DateTime.now().toIso8601String(),
      items: invoiceItems,
      subtotal: totalAmount,
      discount: discount,
      total: totalAmount - discount,
    );

    // Update the product quantities in the product model (subtract purchased quantity)
    final productBox = await Hive.openBox<Product>('products');
    for (var cartProduct in cartNotifier.value) {
      final productKey = cartProduct.id;
      Product? product = productBox.get(productKey);
      if (product != null) {
        int purchased = cartProduct.quantity;
        int currentStock = product.quantity;
        int newStock =
            (currentStock - purchased) >= 0 ? currentStock - purchased : 0;
        product.quantity = newStock;
        await productBox.put(productKey, product);
      }
    }

    // Clear cart and increment bill number
    await clearCart();
    setState(() {
      billNumber++;
    });
    await updateBillNumber(billNumber);
  }

  void fetchProducts() async {
    var box = await Hive.openBox<Product>('products');
    setState(() {
      allProducts = box.values.toList();
      filteredProducts = List.from(allProducts);
    });
  }

  void calculateTotal() {
    totalAmount = cartNotifier.value.fold(
        0, (sum, product) => sum + (product.salesRate * product.quantity));
  }

  Future<void> clearCart() async {
    var box = await Hive.openBox<Cart>('carts');
    await box.clear();
    cartNotifier.value.clear();
    calculateTotal();
    setState(() {});
  }

  void filterProducts(String query) {
    setState(() {
      filteredProducts = allProducts
          .where((product) =>
              product.productName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void removeProduct(Product product) {
    setState(() {
      cartNotifier.value.remove(product);
      calculateTotal();
    });
  }

  void addProduct(Product product) {
    setState(() {
      final existingProductIndex =
          cartNotifier.value.indexWhere((p) => p.id == product.id);
      if (existingProductIndex != -1) {
        cartNotifier.value[existingProductIndex].quantity = 1;
      } else {
        product.quantity = 1;
        cartNotifier.value.add(product);
      }
      calculateTotal();
    });
  }

  @override
  Widget build(BuildContext context) {
    final formattedBillNumber = billNumber.toString().padLeft(4, '0');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Billing',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Customer Details Card
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Bill No: $formattedBillNumber",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          Text(
                              "Date: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}",
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: customerNameController,
                        decoration: const InputDecoration(
                          labelText: "Customer Name",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: "Phone Number",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Cart Items List
              ValueListenableBuilder<List<Product>>(
                valueListenable: cartNotifier,
                builder: (context, cartItems, _) {
                  calculateTotal();
                  return cartItems.isEmpty
                      ? const Center(child: Text("No products added"))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            final product = cartItems[index];
                            return // Inside the ListTile for each cart item:
                                Card(
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              child: ListTile(
                                leading: Image.file(
                                  File(product.imagePaths.first),
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                                title: Text(
                                  product.productName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text("₹${product.salesRate}"),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // TextField to input quantity
                                    SizedBox(
                                      width: 50,
                                      height: 40,
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        controller: TextEditingController(
                                            text: product.quantity.toString()),
                                        onSubmitted: (value) {
                                          final newQuantity =
                                              int.tryParse(value) ??
                                                  product.quantity;
                                          setState(() {
                                            product.quantity =
                                                newQuantity.clamp(1, 100);
                                            calculateTotal();
                                          });
                                        },
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 8),
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(Icons.remove_circle,
                                          color: Colors.red),
                                      onPressed: () {
                                        setState(() {
                                          removeProduct(product);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                },
              ),
              const SizedBox(height: 16),
              // Discount Input Field
              TextField(
                controller: discountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Discount Amount",
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    discount = double.tryParse(value) ?? 0;
                  });
                },
              ),
              const SizedBox(height: 16),
              // Subtotal and Total Card
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(" Total Amount",
                              style: TextStyle(fontSize: 16)),
                          Text("₹${totalAmount.toStringAsFixed(2)}",
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Discount",
                              style: TextStyle(fontSize: 16)),
                          Text("₹${discount.toStringAsFixed(2)}",
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(" Grand Total",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          Text(
                              "₹${(totalAmount - discount).toStringAsFixed(2)}",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Buttons Row
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: clearCart,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child:
                          const Text('Cancel', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: generateAndPrintBill,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Purchase',
                          style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
