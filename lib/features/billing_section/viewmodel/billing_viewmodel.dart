// billing_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:zoyo_bathware/constants/invoice_generator.dart';
import 'package:zoyo_bathware/core/models/cart_model.dart';
import 'package:zoyo_bathware/core/models/product_model.dart';
import 'package:zoyo_bathware/database/data_operations/billing_db.dart';
import 'package:zoyo_bathware/database/data_operations/cart_db.dart';

class BillingViewModel extends ChangeNotifier {
  double totalAmount = 0;
  double discount = 0;
  int billNumber = 1;

  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  List<Product> allProducts = [];
  List<Product> filteredProducts = [];

  BillingViewModel() {
    _init();
  }

  void _init() async {
    await _loadBillNumberAndProducts();
    cartNotifier.addListener(_onCartChange);
    searchController.addListener(() => filterProducts(searchController.text));
  }

  Future<void> _loadBillNumberAndProducts() async {
    billNumber = await loadBillNumber();
    await fetchProducts();
    calculateTotal();
    notifyListeners();
  }

  void _onCartChange() {
    calculateTotal();
    notifyListeners();
  }

  void calculateTotal() {
    totalAmount = cartNotifier.value.fold(
      0,
      (sum, product) => sum + (product.salesRate * product.quantity),
    );
  }

  Future<void> fetchProducts() async {
    var box = await Hive.openBox<Product>('products');
    allProducts = box.values.toList();
    filteredProducts = List.from(allProducts);
    notifyListeners();
  }

  void filterProducts(String query) {
    filteredProducts = allProducts.where((product) {
      return product.productCode.toLowerCase().contains(query.toLowerCase()) ||
          product.productName.toLowerCase().contains(query.toLowerCase());
    }).toList();
    notifyListeners();
  }

  void clearSearch() {
    searchController.clear();
    filteredProducts = List.from(allProducts);
    notifyListeners();
  }

  void addProduct(Product product) {
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
      cartNotifier.value.add(newProduct);
      cartNotifier.notifyListeners();
    }
    calculateTotal();
    notifyListeners();
  }

  void removeProduct(Product product) {
    cartNotifier.value.remove(product);
    calculateTotal();
    notifyListeners();
  }

  void updateDiscount(String value) {
    final inputDiscount = double.tryParse(value) ?? 0;

    if (inputDiscount < 0 || inputDiscount > totalAmount) return;

    discount = inputDiscount;
    notifyListeners();
  }

  Future<void> clearCart() async {
    var box = await Hive.openBox<Cart>('carts');
    await box.clear();
    cartNotifier.value.clear();
    calculateTotal();
    notifyListeners();
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

    await _saveInvoiceData(formattedBillNumber);
    await _updateProductStock();
    await clearCart();
    _clearInputFields();
    _incrementBillNumber();
  }

  Future<void> _saveInvoiceData(String formattedBillNumber) async {
    List<Map<String, dynamic>> invoiceItems = cartNotifier.value.map((product) {
      double profit = (product.salesRate * product.quantity) -
          (product.purchaseRate * product.quantity) -
          discount;

      return {
        'sno': product.id,
        'productName': product.productName,
        'rate': product.salesRate,
        'purchaseRate': product.purchaseRate,
        'quantity': product.quantity,
        'total': (product.salesRate * product.quantity).toStringAsFixed(2),
        'profit': profit,
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
      profit: totalProfit,
    );
  }

  Future<void> _updateProductStock() async {
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

  void _clearInputFields() {
    customerNameController.clear();
    phoneController.clear();
    discountController.clear();
  }

  void _incrementBillNumber() async {
    billNumber++;
    await updateBillNumber(billNumber);
    notifyListeners();
  }

  @override
  void dispose() {
    cartNotifier.removeListener(_onCartChange);
    customerNameController.dispose();
    phoneController.dispose();
    discountController.dispose();
    searchController.dispose();
    super.dispose();
  }
}
