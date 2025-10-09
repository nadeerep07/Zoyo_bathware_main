// billing_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zoyo_bathware/database/data_operations/cart_db.dart';
import 'package:zoyo_bathware/features/billing_section/viewmodel/billing_viewmodel.dart';
import 'package:zoyo_bathware/features/billing_section/view/widgets/billing_app_bar.dart';
import 'package:zoyo_bathware/features/billing_section/view/widgets/billing_body.dart';

class BillingScreen extends StatelessWidget {
  const BillingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BillingViewModel(),
      child: Consumer<BillingViewModel>(
        builder: (context, viewModel, child) {
          final formattedBillNumber = viewModel.billNumber.toString().padLeft(4, '0');

          return Scaffold(
            appBar: const BillingAppBar(),
            body: BillingBody(
              searchController: viewModel.searchController,
              filteredProducts: viewModel.filteredProducts,
              formattedBillNumber: formattedBillNumber,
              customerNameController: viewModel.customerNameController,
              phoneController: viewModel.phoneController,
              cartNotifier: cartNotifier,
              discountController: viewModel.discountController,
              totalAmount: viewModel.totalAmount,
              discount: viewModel.discount,
              onClearSearch: viewModel.clearSearch,
              onAddProduct: viewModel.addProduct,
              onRemoveProduct: viewModel.removeProduct,
              onDiscountChange: viewModel.updateDiscount,
              onCancel: viewModel.clearCart,
              onPurchase: viewModel.generateAndPrintBill,
            ),
          );
        },
      ),
    );
  }
}
