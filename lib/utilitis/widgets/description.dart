import 'package:flutter/material.dart';
import 'package:zoyo_bathware/utilitis/custom_classes/product_controllers.dart';
import 'package:zoyo_bathware/utilitis/widgets/text_form_field.dart';

class DescriptionSection extends StatelessWidget {
  final ProductControllers controllers;

  const DescriptionSection({
    Key? key,
    required this.controllers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controllers.description,
      labelText: 'Description',
      prefixIcon: Icons.description,
      maxLines: 3,
    );
  }
}
