import 'package:flutter/material.dart';
import 'package:zoyo_bathware/database/CrudOperations/category_db.dart';
import 'package:zoyo_bathware/database/category_model.dart';
import 'package:zoyo_bathware/utilitis/widgets/back_botton.dart';
import 'package:zoyo_bathware/utilitis/widgets/category_card.dart';

class AllCategories extends StatefulWidget {
  const AllCategories({super.key});

  @override
  State<AllCategories> createState() => _AllCategoriesState();
}

class _AllCategoriesState extends State<AllCategories> {
  @override
  void initState() {
    super.initState();
    // Fetch categories when the widget initializes
    CategoryDatabaseHelper.getAllCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: backButton(context),
        title: const Text("All Categories"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              // Prevents GridView from overflowing
              child: ValueListenableBuilder<List<Category>>(
                valueListenable: CategoryDatabaseHelper.categoriesNotifier,
                builder: (context, categories, child) {
                  if (categories.isEmpty) {
                    return const Center(
                      child: Text(
                        "No categories found",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      double aspectRatio = constraints.maxWidth < 600
                          ? 1
                          : 1.3; // Adjust for larger screens
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // 2 items per row
                          crossAxisSpacing: 16, // Horizontal spacing
                          mainAxisSpacing: 16, // Vertical spacing
                          childAspectRatio: aspectRatio, // Dynamic aspect ratio
                        ),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          return CategoryCard(category: category);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
