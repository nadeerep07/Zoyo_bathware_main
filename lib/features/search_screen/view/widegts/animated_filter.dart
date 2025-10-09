import 'package:flutter/material.dart';
import 'package:zoyo_bathware/features/search_screen/view/widegts/category_filter.dart';
import 'package:zoyo_bathware/features/search_screen/view/widegts/price_range_filter.dart';
import 'package:zoyo_bathware/features/search_screen/view/widegts/sort_and_stock_option.dart';
import 'package:zoyo_bathware/features/search_screen/viewmodel/search_viewmodel.dart';
import 'package:zoyo_bathware/widgets/responsive.dart';

class AnimatedFilter extends StatelessWidget {
  const AnimatedFilter({
    super.key,
    required Animation<double> filterAnimation,
    required AnimationController filterController,
    required this.context,
    required TextEditingController searchController,
    required this.responsive,
    required this.viewModel,
  }) : _filterAnimation = filterAnimation, _filterController = filterController, _searchController = searchController;

  final Animation<double> _filterAnimation;
  final AnimationController _filterController;
  final BuildContext context;
  final TextEditingController _searchController;
  final Responsive responsive;
  final SearchViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _filterAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -0.5),
          end: Offset.zero,
        ).animate(_filterController),
        child: Container(
          margin: EdgeInsets.all(responsive.wp(4)),
          padding: EdgeInsets.all(responsive.wp(4)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PriceRangeFilter(context: context, searchController: _searchController, responsive: responsive, viewModel: viewModel),
              SizedBox(height: responsive.hp(2)),
              CategoryFilter(searchController: _searchController, responsive: responsive, viewModel: viewModel, ),
              SizedBox(height: responsive.hp(2)),
              SortAndStockOption(searchController: _searchController, responsive: responsive, viewModel: viewModel,),
            ],
          ),
        ),
      ),
    );
  }
}
