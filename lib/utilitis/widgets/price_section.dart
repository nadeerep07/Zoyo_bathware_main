import 'package:flutter/material.dart';
import 'package:zoyo_bathware/screens/user_manage/add_edit/product section/product_controllers.dart';
import 'package:zoyo_bathware/utilitis/widgets/text_form_field.dart';

class PriceSection extends StatelessWidget {
  final ProductControllers controllers;

  const PriceSection({
    Key? key,
    required this.controllers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          controller: controllers.quantity,
          labelText: 'Quantity',
          prefixIcon: Icons.production_quantity_limits,
          isNumeric: true,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: controllers.purchaseRate,
          labelText: 'Purchase Rate',
          isNumeric: true,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: controllers.salesRate,
          labelText: 'Sales Rate',
          isNumeric: true,
        ),
      ],
    );
  }
}
