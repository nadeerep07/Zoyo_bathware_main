import 'package:flutter/material.dart';
import 'package:zoyo_bathware/database/category_model.dart';

class CategorySection extends StatelessWidget {
  final List<Category> categories;
  final String? selectedCategory;
  final Function(String?) onChanged;

  const CategorySection({
    Key? key,
    required this.categories,
    required this.selectedCategory,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedCategory,
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
