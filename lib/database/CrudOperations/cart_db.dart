import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:zoyo_bathware/database/cart_model.dart';
import 'package:zoyo_bathware/database/product_model.dart';

const String cartBox = 'carts';
final ValueNotifier<List<Product>> cartNotifier =
    ValueNotifier<List<Product>>([]);

Future<void> addToCart(Product product) async {
  var box = await Hive.openBox<Cart>(cartBox);

  // Check if the product is already in the cart
  final cartItem = box.values.firstWhere(
    (item) => item.productId == product.id,
    orElse: () => Cart(
      cartId: DateTime.now().toString(),
      productId: product.id!,
      quantity: 0,
      addedAt: DateTime.now(),
    ),
  );

  if (cartItem.quantity == 0) {
    // Add new item to the cart
    await box.add(Cart(
      cartId: DateTime.now().toString(),
      productId: product.id!,
      quantity: 1,
      addedAt: DateTime.now(),
    ));
  } else {
    // Update the quantity of the existing cart item
    cartItem.quantity += 1;
    await box.put(cartItem.cartId, cartItem);
  }

  // Update the cart list
  await getAllCart();
}

Future<void> getAllCart() async {
  var cartBox = await Hive.openBox<Cart>('carts');
  var productBox = await Hive.openBox<Product>('products');

  print("Cart box length: ${cartBox.length}");
  print("Cart box contents: ${cartBox.values}");

  cartNotifier.value = cartBox.values
      .map((cartItem) {
        // Fetch product from productBox using cartItem.productId
        Product? product = productBox.get(cartItem.productId);

        if (product == null) {
          // Log or handle missing product
          print("Product not found for productId: ${cartItem.productId}");
          return null; // Return null if product is not found
        }

        return Product(
          id: product.id,
          productCode: product.productCode,
          productName: product.productName,
          salesRate: product.salesRate,
          purchaseRate: product.purchaseRate,
          description: product.description,
          imagePaths: product.imagePaths,
          quantity: cartItem.quantity,
          size: product.size,
          type: product.type,
          category: product.category,
          createdAt: product.createdAt,
        );
      })
      .whereType<Product>() // Filter out null entries
      .toList();

  print("Updated cartNotifier value: ${cartNotifier.value.length}");

  cartNotifier.notifyListeners(); // Notify listeners to update UI
}

Future<void> updateCartNotifier() async {
  var cartBox = await Hive.openBox<Cart>('carts');
  var productBox = await Hive.openBox<Product>('products');

  // Ensure cartBox contains Cart objects and extract the data
  List<Cart> cartItems = cartBox.values.toList();

  // Map Cart items to Product details
  List<Product> updatedCart = cartItems
      .map((cartItem) {
        // Fetch the product using cartItem's productId
        Product? product = productBox.get(cartItem.productId);

        // Check if the product exists in the productBox
        if (product != null) {
          return Product(
            id: product.id,
            productCode: product.productCode,
            productName: product.productName,
            salesRate: product.salesRate,
            purchaseRate: product.purchaseRate,
            description: product.description,
            imagePaths: product.imagePaths,
            quantity: cartItem.quantity, // Using quantity from Cart object
            size: product.size,
            type: product.type,
            category: product.category,
            createdAt: product.createdAt,
          );
        } else {
          // Log if product not found in productBox for cartItem
          print("Product not found for ID: ${cartItem.productId}");
          return null;
        }
      })
      .whereType<Product>()
      .toList(); // Filter out null entries

  // Check the updated list before assigning it to cartNotifier
  print("Updated cartNotifier value length: ${updatedCart.length}");

  // Update the cartNotifier value with the mapped products
  cartNotifier.value = updatedCart;

  // Notify listeners to update the UI
  cartNotifier.notifyListeners();
}

// Function to update the quantity of the product
void updateQuantity(Product product, int change) async {
  var box = await Hive.openBox<Cart>('carts');

  // Check if the item already exists in the cart
  final existingCartItemKey = box.keys.firstWhere(
    (key) {
      final cartItem = box.get(key) as Cart;
      return cartItem.productId == product.id;
    },
    orElse: () => null, // Return null if no item exists
  );

  if (existingCartItemKey != null) {
    // Item already exists, update the quantity
    var cartItem = box.get(existingCartItemKey) as Cart;
    cartItem.quantity += change;

    if (cartItem.quantity <= 0) {
      // If quantity is less than or equal to 0, remove the item
      await box.delete(existingCartItemKey);
    } else {
      // Otherwise, update the cart item with the new quantity
      await box.put(existingCartItemKey, cartItem);
    }
  } else {
    // Item doesn't exist, add it as a new item to the cart
    var newCartItem = Cart(
        cartId: DateTime.now().millisecondsSinceEpoch.toString(),
        productId: product.id!,
        quantity: 1,
        addedAt: DateTime.now()); // Add the item with quantity 1
    await box.add(newCartItem);
  }

  // Refresh the cart and update cartNotifier
  await getAllCart();
}

// Function to remove item from cart
void removeItem(Product product) async {
  var box = await Hive.openBox<Cart>('carts');
  final cartItemKey = box.keys.firstWhere((key) {
    final cartItem = box.get(key) as Cart;
    return cartItem.productId == product.id;
  });
  await box.delete(cartItemKey);

  // Refresh the cart and update cartNotifier
  await getAllCart();
}
