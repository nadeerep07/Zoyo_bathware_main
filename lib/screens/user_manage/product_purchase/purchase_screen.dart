import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:zoyo_bathware/database/data_operations/product_db.dart';
import 'package:zoyo_bathware/database/product_model.dart';
import 'package:zoyo_bathware/services/app_colors.dart';
import 'package:intl/intl.dart' as intl;

const String productBox = 'products';
final ValueNotifier<List<Product>> productsNotifier = ValueNotifier([]);

class PurchaseProductScreen extends StatefulWidget {
  const PurchaseProductScreen({super.key});

  @override
  State<PurchaseProductScreen> createState() => _PurchaseProductScreenState();
}

class _PurchaseProductScreenState extends State<PurchaseProductScreen> {
  List<Product> products = [];
  Product? selectedProduct;
  int purchaseQuantity = 1;
  double purchaseRate = 0.0;
  double saleRate = 0.0;
  DateTime purchaseDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() async {
    var box = Hive.box<Product>(productBox);
    products = box.values.toList();
    setState(() {});
  }

  void _updateProduct() async {
    if (selectedProduct != null) {
      selectedProduct!.quantity += purchaseQuantity;
      selectedProduct!.purchaseRate = purchaseRate;
      selectedProduct!.salesRate = saleRate;
      selectedProduct!.purchaseDate.add(purchaseDate);

      await updateProduct(selectedProduct!.id!, selectedProduct!);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product updated successfully')),
      );

      setState(() {
        purchaseQuantity = 1;
        purchaseRate = 0.0;
        saleRate = 0.0;
        selectedProduct = null;
      });

      _loadProducts();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: purchaseDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != purchaseDate) {
      setState(() {
        purchaseDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text('Purchase Product'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth:
                    constraints.maxWidth > 600 ? 600 : constraints.maxWidth,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Autocomplete<Product>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text.isEmpty) {
                        return const Iterable<Product>.empty();
                      }
                      return products.where((Product product) =>
                          product.productName
                              .toLowerCase()
                              .contains(textEditingValue.text.toLowerCase()) ||
                          product.productCode
                              .toLowerCase()
                              .contains(textEditingValue.text.toLowerCase()));
                    },
                    displayStringForOption: (Product product) =>
                        "${product.productName} (${product.productCode})",
                    onSelected: (Product product) {
                      setState(() {
                        selectedProduct = product;
                      });
                    },
                    fieldViewBuilder:
                        (context, controller, focusNode, onEditingComplete) {
                      return TextField(
                        controller: controller,
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          labelText: 'Search Product by Name or Code',
                          border: OutlineInputBorder(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    initialValue: purchaseQuantity.toString(),
                    decoration: InputDecoration(
                      labelText: 'Purchase Quantity',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        purchaseQuantity = int.tryParse(value) ?? 1;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    initialValue: purchaseRate.toString(),
                    decoration: InputDecoration(
                      labelText: 'Purchase Rate (₹)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    onChanged: (value) {
                      setState(() {
                        purchaseRate = double.tryParse(value) ?? 0.0;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    initialValue: saleRate.toString(),
                    decoration: InputDecoration(
                      labelText: 'Sale Rate (₹)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    onChanged: (value) {
                      setState(() {
                        saleRate = double.tryParse(value) ?? 0.0;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: TextEditingController(
                          text: intl.DateFormat('yyyy-MM-dd')
                              .format(purchaseDate),
                        ),
                        decoration: InputDecoration(
                          labelText: 'Purchase Date',
                          border: OutlineInputBorder(),
                          hintText: intl.DateFormat('dd-MMM-yyyy')
                              .format(purchaseDate),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: _updateProduct,
                      child: Text('Update Product'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
