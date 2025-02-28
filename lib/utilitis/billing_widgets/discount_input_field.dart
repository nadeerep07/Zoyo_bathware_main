import 'package:flutter/material.dart';

class DiscountInputField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChange;

  const DiscountInputField({
    required this.controller,
    required this.onChange,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
          labelText: "Discount Amount", border: OutlineInputBorder()),
      onChanged: onChange,
    );
  }
}
