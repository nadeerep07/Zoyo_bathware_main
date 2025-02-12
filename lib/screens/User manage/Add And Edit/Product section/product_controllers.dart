// product_add_edit.dart

import 'package:flutter/material.dart';
import 'package:zoyo_bathware/database/product_model.dart';

class ProductControllers {
  final productCode = TextEditingController();
  final productName = TextEditingController();
  final size = TextEditingController();
  final type = TextEditingController();
  final quantity = TextEditingController();
  final purchaseRate = TextEditingController();
  final salesRate = TextEditingController();
  final description = TextEditingController();

  void populateFromProduct(Product product) {
    productCode.text = product.productCode;
    productName.text = product.productName;
    size.text = product.size;
    type.text = product.type;
    quantity.text = product.quantity.toString();
    purchaseRate.text = product.purchaseRate.toString();
    salesRate.text = product.salesRate.toString();
    description.text = product.description;
  }

  void dispose() {
    productCode.dispose();
    productName.dispose();
    size.dispose();
    type.dispose();
    quantity.dispose();
    purchaseRate.dispose();
    salesRate.dispose();
    description.dispose();
  }
}
