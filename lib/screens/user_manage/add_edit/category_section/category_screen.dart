import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zoyo_bathware/database/category_model.dart';
import 'package:zoyo_bathware/database/data_operations/category_db.dart';
import 'package:zoyo_bathware/utilitis/widgets/category_dialog.dart';
import 'package:zoyo_bathware/services/app_colors.dart';
import 'package:zoyo_bathware/utilitis/widgets/back_botton.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late Box<Category> categoryBox;

  @override
  void initState() {
    super.initState();
    openHiveBox();
  }

  Future<void> openHiveBox() async {
    categoryBox = await Hive.openBox<Category>('categories');
    setState(() {});
    getAllCategories();
  }

  void showCategoryDialog({Category? category, int? index}) {
    showDialog(
      context: context,
      builder: (context) => CategoryDialog(category: category, index: index),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: backButton(context),
        title: const Text("Categories",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primaryColor,
      ),
      body: ValueListenableBuilder<List<Category>>(
        valueListenable: categoriesNotifier,
        builder: (context, categories, _) {
          if (categories.isEmpty) {
            return const Center(
                child: Text("No categories added",
                    style: TextStyle(fontSize: 18, color: Colors.grey)));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 columns in grid
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.76, // Aspect ratio of the card
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: GestureDetector(
                  onTap: () =>
                      showCategoryDialog(category: category, index: index),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                        child: Image.file(
                          File(category.imagePath),
                          width: double.infinity,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            category.name,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            // Delete button redesigned
                            GestureDetector(
                              onTap: () => _showDeleteConfirmationDialog(
                                  context, category),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: const [
                                    Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: 18,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'Delete',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showCategoryDialog(),
        backgroundColor: Colors.deepPurple, // Floating action button color
        child: const Icon(
          Icons.add,
          color: AppColors.backgroundColor,
        ),
      ),
    );
  }

  Future<bool> _isCategoryUsed(String categoryId) async {
    if (!Hive.isBoxOpen('produtcs')) {
      return false;
    }
    final productBox = Hive.box('products');
    for (var product in productBox.values) {
      if (product.categoryId == categoryId) {
        return true; // Found a product using this category
      }
    }
    return false;
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, Category category) async {
    bool isCategoryUsed = await _isCategoryUsed(category.id);

    if (isCategoryUsed) {
      _showCategoryInUseDialog(context);
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: Text("Are you sure you want to delete '${category.name}'?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                deleteCategory(category.id);
                Navigator.of(context).pop(); // Close dialog after deleting
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showCategoryInUseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Cannot Delete"),
          content: const Text(
            "This category is linked to a product and cannot be deleted.",
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Close the dialog
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
