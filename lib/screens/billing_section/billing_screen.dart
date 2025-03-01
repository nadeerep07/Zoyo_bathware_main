import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:zoyo_bathware/database/cart_model.dart';
import 'package:zoyo_bathware/database/data_operations/billing_db.dart';
import 'package:zoyo_bathware/database/data_operations/cart_db.dart';
import 'package:zoyo_bathware/database/product_model.dart';
import 'package:zoyo_bathware/utilitis/billing_widgets/cart_items_list.dart';
import 'package:zoyo_bathware/utilitis/billing_widgets/customer_details_card.dart';
import 'package:zoyo_bathware/utilitis/billing_widgets/discount_input_field.dart';
import 'package:zoyo_bathware/utilitis/billing_widgets/product_list.dart';
import 'package:zoyo_bathware/utilitis/billing_widgets/search_bar.dart'
    as custom;
import 'package:zoyo_bathware/utilitis/billing_widgets/total_amount_summary.dart';
import 'package:zoyo_bathware/services/app_colors.dart';
import 'package:zoyo_bathware/services/invoice_generator.dart';
import 'package:zoyo_bathware/utilitis/billing_widgets/action_buttons.dart';

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
    _loadBillNumberAndProducts();

    cartNotifier.addListener(() {
      if (mounted) {
        calculateTotal();
        setState(() {});
      }
    });

    searchController.addListener(() {
      filterProducts(searchController.text);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    calculateTotal();
  }

  Future<void> _loadBillNumberAndProducts() async {
    billNumber = await loadBillNumber();
    await fetchProducts();
    calculateTotal();
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

    await saveInvoiceData(formattedBillNumber);
    await updateProductStock();
    await clearCart();

    clearInputFields();
    incrementBillNumber();
  }

  Future<void> saveInvoiceData(String formattedBillNumber) async {
    List<Map<String, dynamic>> invoiceItems = cartNotifier.value.map((product) {
      double profit = (product.salesRate * product.quantity) -
          (product.purchaseRate * product.quantity);

      return {
        'sno': product.id,
        'productName': product.productName,
        'rate': product.salesRate,
        'purchaseRate': product.purchaseRate, // Include purchase rate
        'quantity': product.quantity,
        'total': (product.salesRate * product.quantity).toStringAsFixed(2),
        'profit': profit, // Include profit
      };
    }).toList();

    double totalProfit = invoiceItems.fold(
      0,
      (sum, item) => sum + (item['profit'] as double),
    );

    await saveInvoice(
      billNumber: formattedBillNumber,
      customerName: customerNameController.text,
      phoneNumber: phoneController.text,
      date: DateTime.now().toIso8601String(),
      items: invoiceItems,
      subtotal: totalAmount,
      discount: discount,
      total: totalAmount - discount,
      profit: totalProfit, // Include total profit
    );
  }

  Future<void> updateProductStock() async {
    final productBox = await Hive.openBox<Product>('products');
    for (var cartProduct in cartNotifier.value) {
      Product? product = productBox.get(cartProduct.id);
      if (product != null) {
        product.quantity = (product.quantity - cartProduct.quantity)
            .clamp(0, product.quantity);
        await productBox.put(product.id, product);
      }
    }
  }

  void clearInputFields() {
    customerNameController.clear();
    phoneController.clear();
    discountController.clear();
  }

  void incrementBillNumber() async {
    setState(() {
      billNumber++;
    });
    await updateBillNumber(billNumber);
  }

  Future<void> fetchProducts() async {
    var box = await Hive.openBox<Product>('products');
    setState(() {
      allProducts = box.values.toList();
      filteredProducts = List.from(allProducts);
    });
  }

  void calculateTotal() {
    totalAmount = cartNotifier.value.fold(
      0,
      (sum, product) => sum + (product.salesRate * product.quantity),
    );
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
      filteredProducts = allProducts.where((product) {
        return product.productCode
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            product.productName.toLowerCase().contains(query.toLowerCase());
      }).toList();
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
        cartNotifier.value[existingProductIndex].quantity++;
      } else {
        Product newProduct = Product(
          id: product.id,
          productName: product.productName,
          productCode: product.productCode,
          salesRate: product.salesRate,
          quantity: 1,
          imagePaths: List.from(product.imagePaths),
          size: '',
          type: '',
          purchaseRate: 0.0,
          description: '',
          category: '',
          purchaseDate: [],
        );

        // Add product to the cart
        cartNotifier.value.add(newProduct);
        cartNotifier.notifyListeners();
      }

      calculateTotal();
    });
  }

  void updateDiscount(String value) {
    final inputDiscount = double.tryParse(value) ?? 0;

    if (inputDiscount < 0) {
      _showSnackbar("Discount cannot be negative.");
      discountController.text = discount.toString();
    } else if (inputDiscount > totalAmount) {
      _showSnackbar("Discount cannot exceed total amount.");
      discountController.text = discount.toString();
    } else {
      setState(() {
        discount = inputDiscount;
      });
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void clearSearch() {
    searchController.clear();
    setState(() {
      filteredProducts = List.from(allProducts);
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
              // Search Bar
              custom.SearchBar(
                  controller: searchController, onClear: clearSearch),
              const SizedBox(height: 16),

              if (searchController.text.isNotEmpty)
                ProductList(
                  products: filteredProducts,
                  onAdd: addProduct,
                ),
              const SizedBox(height: 16),

              // Customer Details input here
              CustomerDetailsCard(
                billNumber: formattedBillNumber,
                customerNameController: customerNameController,
                phoneController: phoneController,
              ),
              const SizedBox(height: 16),

              // Added Items List
              CartItemsList(
                cartItems: cartNotifier.value,
                onRemove: removeProduct,
                onQuantityChange: (newQuantity) {
                  setState(() {
                    calculateTotal();
                  });
                },
              ),
              const SizedBox(height: 16),

              DiscountInputField(
                controller: discountController,
                onChange: updateDiscount,
              ),
              const SizedBox(height: 16),

              TotalAmountSummary(totalAmount: totalAmount, discount: discount),
              const SizedBox(height: 16),

              ActionButtons(
                onCancel: clearCart,
                onPurchase: generateAndPrintBill,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
