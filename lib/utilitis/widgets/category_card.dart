import 'dart:io';

import 'package:flutter/material.dart';
import 'package:zoyo_bathware/navigationSCreens/category_to_all_product.dart';
import 'package:zoyo_bathware/database/category_model.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final bool isGridView; // New parameter to track the view mode

  const CategoryCard(
      {super.key, required this.category, required this.isGridView});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to CategoryToAllProduct and pass the selected category
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryToAllProduct(category: category),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: isGridView
              // Layout for GridView
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (category.imagePath.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(category.imagePath),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      )
                    else
                      const Icon(Icons.category, size: 60, color: Colors.grey),
                    const SizedBox(height: 8),
                    Text(
                      category.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
              // Layout for ListView
              : Row(
                  children: [
                    if (category.imagePath.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(category.imagePath),
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      )
                    else
                      const Icon(Icons.category, size: 60, color: Colors.grey),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        category.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
