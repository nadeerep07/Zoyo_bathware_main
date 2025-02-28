import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onClear;

  const SearchBar({required this.controller, required this.onClear, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: "Search Products",
        prefixIcon: const Icon(Icons.search),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(icon: const Icon(Icons.clear), onPressed: onClear)
            : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
