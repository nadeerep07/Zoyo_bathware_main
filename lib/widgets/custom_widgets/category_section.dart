import 'package:flutter/material.dart';
import 'package:zoyo_bathware/core/models/category_model.dart';

class CategorySection extends StatelessWidget {
  final List<ProductCategory> categories;
  final String? selectedCategory;
  final Function(String?) onChanged;

  const CategorySection({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: selectedCategory,
      decoration: const InputDecoration(
        labelText: 'Category',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: categories
          .map((category) => DropdownMenuItem<String>(
                value: category.name,
                child: Text(category.name),
              ))
          .toList(),
      onChanged: onChanged,
      validator: (value) =>
          value == null || value.isEmpty ? 'Please select a category' : null,
    );
  }
}
