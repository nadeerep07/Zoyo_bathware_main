import 'package:flutter/material.dart';
import 'package:zoyo_bathware/constants/app_colors.dart';
import 'package:zoyo_bathware/features/search_screen/viewmodel/search_viewmodel.dart';
import 'package:zoyo_bathware/widgets/responsive.dart';

class SortAndStockOption extends StatelessWidget {
  const SortAndStockOption({
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
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Sort by",
                style: TextStyle(
                  fontSize: responsive.sp(14),
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: responsive.hp(0.5)),
              DropdownButtonFormField<int>(
                value: viewModel.selectedSortOption,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: responsive.wp(3),
                    vertical: responsive.hp(1),
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: 0, child: Text("Name A-Z")),
                  DropdownMenuItem(value: 1, child: Text("Price Low-High")),
                  DropdownMenuItem(value: 2, child: Text("Price High-Low")),
                ],
                onChanged: (value) {
                  if (value != null) {
                    viewModel.updateSortOption(value);
                  }
                },
              ),
            ],
          ),
        ),
        SizedBox(width: responsive.wp(4)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Show out of stock",
              style: TextStyle(
                fontSize: responsive.sp(14),
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: responsive.hp(1)),
            Switch(
              value: viewModel.showOutOfStock,
              onChanged: (value) {
                viewModel.toggleShowOutOfStock(value, _searchController.text);
              },
              activeColor: AppColors.primaryColor,
            ),
          ],
        ),
      ],
    );
  }
}
