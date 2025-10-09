import 'package:flutter/material.dart';
import 'package:zoyo_bathware/constants/app_colors.dart';
import 'package:zoyo_bathware/features/search_screen/view/widegts/price_label.dart';
import 'package:zoyo_bathware/features/search_screen/viewmodel/search_viewmodel.dart';
import 'package:zoyo_bathware/widgets/responsive.dart';

class PriceRangeFilter extends StatelessWidget {
  const PriceRangeFilter({
    super.key,
    required this.context,
    required TextEditingController searchController,
    required this.responsive,
    required this.viewModel,
  }) : _searchController = searchController;

  final BuildContext context;
  final TextEditingController _searchController;
  final Responsive responsive;
  final SearchViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Price Range",
          style: TextStyle(
            fontSize: responsive.sp(16),
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: responsive.hp(1)),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.primaryColor,
            inactiveTrackColor: AppColors.primaryColor.withValues(alpha:0.3),
            thumbColor: AppColors.primaryColor,
            overlayColor: AppColors.primaryColor.withValues(alpha:0.2),
            valueIndicatorColor: AppColors.primaryColor,
          ),
          child: RangeSlider(
            values: viewModel.priceRange,
            min: viewModel.minPrice,
            max: viewModel.maxPrice,
            divisions: 100,
            labels: RangeLabels(
              "₹${viewModel.priceRange.start.toStringAsFixed(0)}",
              "₹${viewModel.priceRange.end.toStringAsFixed(0)}",
            ),
            onChanged: (RangeValues values) {
              viewModel.updatePriceRange(values, _searchController.text);
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PriceLabel(responsive: responsive, price: viewModel.priceRange.start),
            PriceLabel(responsive: responsive, price: viewModel.priceRange.end),
          ],
        ),
      ],
    );
  }
}
