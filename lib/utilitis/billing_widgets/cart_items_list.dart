import 'package:flutter/material.dart';
import 'package:zoyo_bathware/database/product_model.dart';
import 'package:zoyo_bathware/utilitis/billing_widgets/cart_item_tile.dart';

class CartItemsList extends StatelessWidget {
  final List<Product> cartItems;
  final void Function(Product) onRemove;
  final void Function(int) onQuantityChange;

  const CartItemsList({
    required this.cartItems,
    required this.onRemove,
    required this.onQuantityChange,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Product>>(
      valueListenable: ValueNotifier(cartItems),
      builder: (context, cartItems, _) {
        if (cartItems.isEmpty) {
          return const Center(child: Text("No products added"));
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cartItems.length,
          itemBuilder: (context, index) {
            final product = cartItems[index];
            return CartItemTile(
              product: product,
              onRemove: onRemove,
              onQuantityChange: onQuantityChange,
            );
          },
        );
      },
    );
  }
}
