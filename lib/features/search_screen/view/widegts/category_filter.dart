import 'package:flutter/material.dart';
import 'package:zoyo_bathware/constants/app_colors.dart';
import 'package:zoyo_bathware/features/search_screen/viewmodel/search_viewmodel.dart';
import 'package:zoyo_bathware/widgets/responsive.dart';

class CategoryFilter extends StatelessWidget {
  const CategoryFilter({
    super.key,
    required TextEditingController searchController,
    required this.responsive,
    required this.viewModel, 
  }) : _searchController = searchController;

  final TextEditingController _searchController;
  final Responsive responsive;
  final SearchViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Category",
          style: TextStyle(
            fontSize: responsive.sp(16),
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: responsive.hp(1)),
        SizedBox(
          height: responsive.hp(5),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: viewModel.categories.length,
            itemBuilder: (context, index) {
              final category = viewModel.categories[index];
              final isSelected = viewModel.selectedCategory == category;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.only(right: responsive.wp(2)),
                child: Material(
                  color: isSelected ? AppColors.primaryColor : Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                  elevation: isSelected ? 4 : 0,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      viewModel.updateCategory(category, _searchController.text);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.wp(4),
                        vertical: responsive.hp(1),
                      ),
                      child: Center(
                        child: Text(
                          category,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey[700],
                            fontWeight: FontWeight.w600,
                            fontSize: responsive.sp(12),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
