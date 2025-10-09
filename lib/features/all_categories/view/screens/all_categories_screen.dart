// all_categories_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zoyo_bathware/constants/app_colors.dart';
import 'package:zoyo_bathware/features/all_categories/view/components/catergory_list_grid.dart';
import 'package:zoyo_bathware/features/all_categories/view/components/no_categories.dart';
import 'package:zoyo_bathware/features/all_categories/viewmodel/all_categories_viewmodel.dart';
import 'package:zoyo_bathware/widgets/custom_widgets/back_botton.dart';


class AllCategoriesScreen extends StatelessWidget {
  const AllCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AllCategoriesViewModel(),
      child: Consumer<AllCategoriesViewModel>(
        builder: (context, viewModel, child) {
          final categories = viewModel.categories;

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
                    viewModel.isGridView ? Icons.view_list : Icons.grid_view,
                    size: 28,
                  ),
                  onPressed: viewModel.toggleView,
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: categories.isEmpty
                  ? const NoCategoriesWidget()
                  : CategoryListGrid(
                      categories: categories,
                      isGridView: viewModel.isGridView,
                    ),
            ),
          );
        },
      ),
    );
  }
}
