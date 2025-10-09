import 'package:flutter/material.dart';
import 'package:zoyo_bathware/constants/app_colors.dart';
import 'package:zoyo_bathware/features/search_screen/viewmodel/search_viewmodel.dart';
import 'package:zoyo_bathware/widgets/responsive.dart';

class FilterToggle extends StatelessWidget {
  const FilterToggle({
    super.key,
    required Animation<double> fadeAnimation,
    required AnimationController filterController,
    required this.responsive,
    required this.viewModel,
  }) : _fadeAnimation = fadeAnimation, _filterController = filterController;

  final Animation<double> _fadeAnimation;
  final AnimationController _filterController;
  final Responsive responsive;
  final SearchViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: responsive.wp(4)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Found ${viewModel.productCount} products",
              style: TextStyle(
                fontSize: responsive.sp(14),
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: Material(
                color: viewModel.showFilters ? AppColors.primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(12),
                elevation: viewModel.showFilters ? 4 : 2,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    viewModel.toggleFilters();
                    if (viewModel.showFilters) {
                      _filterController.forward();
                    } else {
                      _filterController.reverse();
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.wp(4),
                      vertical: responsive.hp(1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.tune,
                          color: viewModel.showFilters ? Colors.white : AppColors.primaryColor,
                          size: responsive.sp(18),
                        ),
                        SizedBox(width: responsive.wp(2)),
                        Text(
                          "Filters",
                          style: TextStyle(
                            color: viewModel.showFilters ? Colors.white : AppColors.primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: responsive.sp(14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
