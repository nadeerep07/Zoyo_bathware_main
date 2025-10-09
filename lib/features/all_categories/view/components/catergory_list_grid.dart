// components/category_list_grid.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:zoyo_bathware/core/models/category_model.dart';
import 'package:zoyo_bathware/widgets/custom_widgets/category_card.dart';

class CategoryListGrid extends StatelessWidget {
  final List<ProductCategory> categories;
  final bool isGridView;

  const CategoryListGrid({
    super.key,
    required this.categories,
    required this.isGridView,
  });

  @override
  Widget build(BuildContext context) {
    return isGridView
        ? LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = kIsWeb ? 5 : 2;
              double aspectRatio = constraints.maxWidth < 600 ? 0.9 : 1.3;

              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: aspectRatio,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return CategoryCard(
                    category: categories[index],
                    isGridView: true,
                  );
                },
              );
            },
          )
        : ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return CategoryCard(
                category: categories[index],
                isGridView: false,
              );
            },
          );
  }
}
