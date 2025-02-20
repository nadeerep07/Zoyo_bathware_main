import 'package:flutter/material.dart';
import 'package:zoyo_bathware/database/category_model.dart';
import 'package:zoyo_bathware/database/data_perations/category_db.dart';
import 'package:zoyo_bathware/screens/billing_section/billing_screen.dart';
import 'package:zoyo_bathware/screens/home/home_screen.dart';
import 'package:zoyo_bathware/screens/user_manage/manage_screen.dart';
import 'package:zoyo_bathware/screens/cabinet_screen/cabinet_screen.dart';
import 'package:zoyo_bathware/services/app_colors.dart';
import 'package:zoyo_bathware/utilitis/widgets/back_botton.dart';
import 'package:zoyo_bathware/utilitis/widgets/bottom_navigation.dart';
import 'package:zoyo_bathware/utilitis/widgets/category_card.dart';

class AllCategories extends StatefulWidget {
  const AllCategories({super.key});

  @override
  State<AllCategories> createState() => _AllCategoriesState();
}

class _AllCategoriesState extends State<AllCategories> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AllCategories()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CabinetScreen()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ManageScreen()),
        );
        break;
      default:
        break;
    }
  }

  bool isGridView = true;

  @override
  void initState() {
    super.initState();
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
                  final filteredCategories = categories
                      .where((category) =>
                          category.name.toLowerCase().trim() != 'cabinet')
                      .toList();
                  if (filteredCategories.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
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

                  return isGridView
                      ? LayoutBuilder(
                          builder: (context, constraints) {
                            double aspectRatio =
                                constraints.maxWidth < 600 ? 0.9 : 1.3;
                            return GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: aspectRatio,
                              ),
                              itemCount: filteredCategories.length,
                              itemBuilder: (context, index) {
                                final category = filteredCategories[index];
                                return CategoryCard(
                                  category: category,
                                  isGridView: isGridView, // Pass the view mode
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
                              isGridView: isGridView, // Pass the view mode
                            );
                          },
                        );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => BillingScreen()));
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.shopping_cart, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
