import 'dart:io';

import 'package:flutter/material.dart';
import 'package:zoyo_bathware/database/CrudOperations/cart_db.dart';
import 'package:zoyo_bathware/database/product_model.dart';
import 'package:zoyo_bathware/services/app_colors.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double totalAmount = 0;

  // Function to calculate the total amount
  void calculateTotal() {
    totalAmount = cartNotifier.value.fold(
        0, (sum, product) => sum + (product.salesRate * product.quantity));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Cart', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ValueListenableBuilder<List<Product>>(
          valueListenable: cartNotifier,
          builder: (context, cartItems, _) {
            calculateTotal();

            return cartItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart_outlined,
                            size: 80, color: Colors.grey[400]),
                        SizedBox(height: 16),
                        Text("Your cart is empty",
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey[600])),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            final product = cartItems[index];
                            return Dismissible(
                              key: Key(product.id!),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(right: 20),
                                color: Colors.red,
                                child: Icon(Icons.delete, color: Colors.white),
                              ),
                              onDismissed: (direction) {
                                removeItem(product);
                              },
                              child: Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                margin: EdgeInsets.symmetric(vertical: 8),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.file(
                                          File(product.imagePaths.first),
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(product.productName,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                          SizedBox(height: 4),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 12,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                                Icons.remove_circle_outline,
                                                color: Colors.red),
                                            onPressed: () {
                                              updateQuantity(product, -1);
                                            },
                                          ),
                                          Text(product.quantity.toString(),
                                              style: TextStyle(fontSize: 16)),
                                          IconButton(
                                            icon: Icon(Icons.add_circle_outline,
                                                color: Colors.green),
                                            onPressed: () {
                                              updateQuantity(product, 1);
                                            },
                                          ),
                                        ],
                                      ),
                                      Text(
                                          '₹${product.salesRate.toStringAsFixed(2)}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600])),
                                      SizedBox(height: 8),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total:',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '₹${totalAmount.toStringAsFixed(2)}',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryColor),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle checkout process
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text('Proceed to Checkout',
                              style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  );
          },
        ),
      ),
    );
  }

  // // Function to remove item from cart
  // void removeItem(Product product) async {
  //   var box = await Hive.openBox<Cart>('carts');
  //   final cartItemKey = box.keys.firstWhere((key) {
  //     final cartItem = box.get(key) as Cart;
  //     return cartItem.productId == product.id;
  //   });
  //   await box.delete(cartItemKey);

  //   // Refresh the cart and update cartNotifier
  //   await getAllCart();
  // }

  // // Function to update the quantity of the product
  // void updateQuantity(Product product, int change) async {
  //   var box = await Hive.openBox<Cart>('carts');

  //   // Check if the item already exists in the cart
  //   final existingCartItemKey = box.keys.firstWhere(
  //     (key) {
  //       final cartItem = box.get(key) as Cart;
  //       return cartItem.productId == product.id;
  //     },
  //     orElse: () => null, // Return null if no item exists
  //   );

  //   if (existingCartItemKey != null) {
  //     // Item already exists, update the quantity
  //     var cartItem = box.get(existingCartItemKey) as Cart;
  //     cartItem.quantity += change;

  //     if (cartItem.quantity <= 0) {
  //       // If quantity is less than or equal to 0, remove the item
  //       await box.delete(existingCartItemKey);
  //     } else {
  //       // Otherwise, update the cart item with the new quantity
  //       await box.put(existingCartItemKey, cartItem);
  //     }
  //   } else {
  //     // Item doesn't exist, add it as a new item to the cart
  //     var newCartItem = Cart(
  //         cartId: DateTime.now().millisecondsSinceEpoch.toString(),
  //         productId: product.id!,
  //         quantity: 1,
  //         addedAt: DateTime.now()); // Add the item with quantity 1
  //     await box.add(newCartItem);
  //   }

  //   // Refresh the cart and update cartNotifier
  //   await getAllCart();
  // }

  // // Function to get all cart items and update cartNotifier
  // Future<void> getAllCart() async {
  //   var cartBox = await Hive.openBox<Cart>('carts');
  //   var productBox = await Hive.openBox<Product>('products');

  //   print("Cart box length: ${cartBox.length}");
  //   print("Cart box contents: ${cartBox.values}");

  //   cartNotifier.value = cartBox.values
  //       .map((cartItem) {
  //         Product? product = productBox.get(cartItem.productId);

  //         if (product == null) {
  //           print("Product not found for productId: ${cartItem.productId}");
  //           return null;
  //         }

  //         return Product(
  //           id: product.id,
  //           productCode: product.productCode,
  //           productName: product.productName,
  //           salesRate: product.salesRate,
  //           purchaseRate: product.purchaseRate,
  //           description: product.description,
  //           imagePaths: product.imagePaths,
  //           quantity: cartItem.quantity,
  //           size: product.size,
  //           type: product.type,
  //           category: product.category,
  //           createdAt: product.createdAt,
  //         );
  //       })
  //       .whereType<Product>()
  //       .toList();

  //   print("Updated cartNotifier value: ${cartNotifier.value.length}");

  //   // Update cartNotifier and notify listeners to refresh the UI
  //   cartNotifier.notifyListeners();
  // }
}
