import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:zoyo_bathware/database/product_model.dart';
import 'package:zoyo_bathware/utilitis/custom_classes/product_controllers.dart';
import 'package:zoyo_bathware/utilitis/custom_widgets/text_form_field.dart';

class ProductDetailsSection extends StatelessWidget {
  final ProductControllers controllers;

  const ProductDetailsSection({
    Key? key,
    required this.controllers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          controller: controllers.productCode,
          labelText: 'Product Code',
          prefixIcon: Icons.code,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Product Code is required';
            }

            var box = Hive.box<Product>('products');
            bool productExists =
                box.values.any((product) => product.productCode == value);

            if (productExists) {
              return 'Product Code already exists!';
            }

            return null;
          },
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: controllers.productName,
          labelText: 'Product Name',
          prefixIcon: Icons.shopping_bag,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: controllers.size,
          labelText: 'Size',
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: controllers.type,
          labelText: 'Type',
          prefixIcon: Icons.type_specimen,
        ),
      ],
    );
  }
}
