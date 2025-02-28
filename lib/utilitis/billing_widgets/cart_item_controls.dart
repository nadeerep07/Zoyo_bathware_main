import 'package:flutter/material.dart';
import 'package:zoyo_bathware/database/product_model.dart';

class CartItemControls extends StatelessWidget {
  final Product product;
  final void Function(Product) onRemove;
  final void Function(int) onQuantityChange;

  const CartItemControls({
    required this.product,
    required this.onRemove,
    required this.onQuantityChange,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 50,
          height: 40,
          child: TextField(
            keyboardType: TextInputType.number,
            controller:
                TextEditingController(text: product.quantity.toString()),
            onSubmitted: (value) {
              final newQuantity = int.tryParse(value) ?? product.quantity;
              product.quantity = newQuantity.clamp(1, 100);
              onQuantityChange(
                  newQuantity); // Notify that quantity has changed.
            },
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.remove_circle, color: Colors.red),
          onPressed: () => onRemove(product),
        ),
      ],
    );
  }
}
