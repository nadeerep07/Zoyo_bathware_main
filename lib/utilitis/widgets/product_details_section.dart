import 'package:flutter/material.dart';
import 'package:zoyo_bathware/screens/user_manage/add_edit/product section/product_controllers.dart';
import 'package:zoyo_bathware/utilitis/widgets/text_form_field.dart';

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
