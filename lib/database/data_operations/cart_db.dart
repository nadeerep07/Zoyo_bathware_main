import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:zoyo_bathware/database/cart_model.dart';
import 'package:zoyo_bathware/database/product_model.dart';

const String cartBox = 'carts';
final ValueNotifier<List<Product>> cartNotifier =
    ValueNotifier<List<Product>>([]);

Future<void> addToCart(Product product) async {
  var box = await Hive.openBox<Cart>(cartBox);

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
    await box.add(Cart(
      cartId: DateTime.now().toString(),
      productId: product.id!,
      quantity: 1,
      addedAt: DateTime.now(),
    ));
  } else {
    cartItem.quantity += 1;
    await box.put(cartItem.cartId, cartItem);
  }

  await getAllCart();
}

Future<void> getAllCart() async {
  var cartBox = await Hive.openBox<Cart>('carts');
  var productBox = await Hive.openBox<Product>('products');

  print("Cart box length: ${cartBox.length}");
  print("Cart box contents: ${cartBox.values}");

  cartNotifier.value = cartBox.values
      .map((cartItem) {
        Product? product = productBox.get(cartItem.productId);

        if (product == null) {
          print("Product not found for productId: ${cartItem.productId}");
          return null;
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
          purchaseDate: product.purchaseDate,
        );
      })
      .whereType<Product>() // Filter out null entries
      .toList();

  print("Updated  value: ${cartNotifier.value.length}");

  cartNotifier.notifyListeners();
}

Future<void> updateCartNotifier() async {
  var cartBox = await Hive.openBox<Cart>('carts');
  var productBox = await Hive.openBox<Product>('products');

  List<Cart> cartItems = cartBox.values.toList();

  List<Product> updatedCart = cartItems
      .map((cartItem) {
        Product? product = productBox.get(cartItem.productId);

        if (product != null) {
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
            purchaseDate: product.purchaseDate,
          );
        } else {
          print("Product not found for ID: ${cartItem.productId}");
          return null;
        }
      })
      .whereType<Product>()
      .toList(); // Filter out null entries

  print("Updated cartNotifier value length: ${updatedCart.length}");

  cartNotifier.value = updatedCart;

  cartNotifier.notifyListeners();
}

void updateQuantity(Product product, int change) async {
  var box = await Hive.openBox<Cart>('carts');

  final existingCartItemKey = box.keys.firstWhere(
    (key) {
      final cartItem = box.get(key) as Cart;
      return cartItem.productId == product.id;
    },
    orElse: () => null,
  );

  if (existingCartItemKey != null) {
    var cartItem = box.get(existingCartItemKey) as Cart;
    cartItem.quantity += change;

    if (cartItem.quantity <= 0) {
      await box.delete(existingCartItemKey);
    } else {
      await box.put(existingCartItemKey, cartItem);
    }
  } else {
    var newCartItem = Cart(
        cartId: DateTime.now().millisecondsSinceEpoch.toString(),
        productId: product.id!,
        quantity: 1,
        addedAt: DateTime.now());
    await box.add(newCartItem);
  }

  await getAllCart();
}

void removeItem(Product product) async {
  var box = await Hive.openBox<Cart>('carts');
  final cartItemKey = box.keys.firstWhere((key) {
    final cartItem = box.get(key) as Cart;
    return cartItem.productId == product.id;
  });
  await box.delete(cartItemKey);

  await getAllCart();
}
