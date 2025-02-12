import 'dart:io';

import 'package:flutter/material.dart';
import 'package:zoyo_bathware/database/product_model.dart';
import 'package:zoyo_bathware/services/app_colors.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Product> cartItems = []; // List to hold cart items
  double totalAmount = 0;

  // Function to calculate the total amount
  void calculateTotal() {
    totalAmount = cartItems.fold(
        0, (sum, item) => sum + (item.salesRate * item.quantity));
  }

  // Function to update the quantity
  void updateQuantity(Product product, int quantity) {
    setState(() {
      product.quantity = quantity;
      calculateTotal();
    });
  }

  // Function to remove an item from the cart
  void removeItem(Product product) {
    setState(() {
      cartItems.remove(product);
      calculateTotal();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: cartItems.isEmpty
            ? Center(
                child:
                    Text("Your cart is empty", style: TextStyle(fontSize: 18)))
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final product = cartItems[index];
                        return Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: Image.file(
                              File(product.imagePaths.first),
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                            title: Text(product.productName),
                            subtitle: Text(
                                '₹${product.salesRate} x ${product.quantity}'),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => removeItem(product),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total: ₹${totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Handle checkout process
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonColor,
                        ),
                        child: Text('Checkout'),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
