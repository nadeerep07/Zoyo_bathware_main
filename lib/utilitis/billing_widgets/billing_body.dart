import 'package:flutter/material.dart';
import 'package:zoyo_bathware/database/product_model.dart';
import 'package:zoyo_bathware/utilitis/billing_widgets/action_buttons.dart';
import 'package:zoyo_bathware/utilitis/billing_widgets/cart_items_list.dart';
import 'package:zoyo_bathware/utilitis/billing_widgets/customer_details_card.dart';
import 'package:zoyo_bathware/utilitis/billing_widgets/discount_input_field.dart';
import 'package:zoyo_bathware/utilitis/billing_widgets/product_list.dart';
import 'package:zoyo_bathware/utilitis/billing_widgets/total_amount_summary.dart';

class BillingBody extends StatelessWidget {
  final TextEditingController searchController;
  final List<Product> filteredProducts;
  final String formattedBillNumber;
  final TextEditingController customerNameController;
  final TextEditingController phoneController;
  final ValueNotifier<List<Product>> cartNotifier;
  final TextEditingController discountController;
  final double totalAmount;
  final double discount;
  final Function() onClearSearch;
  final Function(Product) onAddProduct;
  final Function(Product) onRemoveProduct;
  final Function(String) onDiscountChange;
  final Function() onCancel;
  final Function() onPurchase;

  const BillingBody({
    super.key,
    required this.searchController,
    required this.filteredProducts,
    required this.formattedBillNumber,
    required this.customerNameController,
    required this.phoneController,
    required this.cartNotifier,
    required this.discountController,
    required this.totalAmount,
    required this.discount,
    required this.onClearSearch,
    required this.onAddProduct,
    required this.onRemoveProduct,
    required this.onDiscountChange,
    required this.onCancel,
    required this.onPurchase,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search Products',
                hintText: 'Enter product name or code',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchController.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: onClearSearch,
                      ),
              ),
              onChanged: (value) {},
            ),

            const SizedBox(height: 16),

            // Product List
            if (searchController.text.isNotEmpty)
              ProductList(
                products: filteredProducts,
                onAdd: onAddProduct,
              ),
            const SizedBox(height: 16),

            // Customer Details
            CustomerDetailsCard(
              billNumber: formattedBillNumber,
              customerNameController: customerNameController,
              phoneController: phoneController,
            ),
            const SizedBox(height: 16),

            // Cart Items List
            CartItemsList(
              cartItems: cartNotifier.value,
              onRemove: onRemoveProduct,
              onQuantityChange: (newQuantity) {
                cartNotifier.notifyListeners();
              },
            ),
            const SizedBox(height: 16),

            // Discount Input
            DiscountInputField(
              controller: discountController,
              onChange: onDiscountChange,
            ),
            const SizedBox(height: 16),

            // Total Amount Summary
            TotalAmountSummary(
              totalAmount: totalAmount,
              discount: discount,
            ),
            const SizedBox(height: 16),

            // Action Buttons
            ActionButtons(
              onCancel: onCancel,
              onPurchase: onPurchase,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
