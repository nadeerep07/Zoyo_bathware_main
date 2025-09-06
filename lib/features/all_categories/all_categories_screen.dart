import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:zoyo_bathware/database/category_model.dart';
import 'package:zoyo_bathware/database/data_operations/category_db.dart';
import 'package:zoyo_bathware/features/billing_section/billing_screen.dart';
import 'package:zoyo_bathware/features/cabinet_screen/cabinet_screen.dart';
import 'package:zoyo_bathware/features/home_screen/view/screens/home_screen.dart';
import 'package:zoyo_bathware/features/user_manage/manage_screen.dart';


import 'package:zoyo_bathware/services/app_colors.dart';
import 'package:zoyo_bathware/utilitis/custom_widgets/back_botton.dart';
import 'package:zoyo_bathware/utilitis/custom_widgets/bottom_navigation.dart';
import 'package:zoyo_bathware/utilitis/custom_widgets/category_card.dart';

class AllCategories extends StatefulWidget {
  const AllCategories({super.key});

  @override
  State<AllCategories> createState() => _AllCategoriesState();
}

class _AllCategoriesState extends State<AllCategories> {

  bool isGridView = true;

  @override
  void initState() {
    super.initState();
    // Load categories from Hive.
    getAllCategories();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: backButton(context),
        title: const Text(
          "All Categories",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        elevation: 5,
        actions: [
          IconButton(
            color: AppColors.buttonColor,
            icon: Icon(
              isGridView ? Icons.view_list : Icons.grid_view,
              size: 28,
            ),
            onPressed: () {
              setState(() {
                isGridView = !isGridView;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ValueListenableBuilder<List<Category>>(
                valueListenable: categoriesNotifier,
                builder: (context, categories, child) {
                  // Filter out any category with name 'cabinet'
                  final filteredCategories = categories
                      .where((category) =>
                          category.name.toLowerCase().trim() != 'cabinet')
                      .toList();
                  if (filteredCategories.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.category_outlined,
                            size: 80,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "No categories found",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  // Show grid view if isGridView is true; otherwise list view.
                  return isGridView
                      ? LayoutBuilder(
                          builder: (context, constraints) {
                            int crossAxisCount = kIsWeb ? 5 : 2;
                            double aspectRatio =
                                constraints.maxWidth < 600 ? 0.9 : 1.3;
                            return GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: aspectRatio,
                              ),
                              itemCount: filteredCategories.length,
                              itemBuilder: (context, index) {
                                final category = filteredCategories[index];
                                return CategoryCard(
                                  category: category,
                                  isGridView: isGridView,
                                );
                              },
                            );
                          },
                        )
                      : ListView.builder(
                          itemCount: filteredCategories.length,
                          itemBuilder: (context, index) {
                            final category = filteredCategories[index];
                            return CategoryCard(
                              category: category,
                              isGridView: isGridView,
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
