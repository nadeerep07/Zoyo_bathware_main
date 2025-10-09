import 'package:flutter/material.dart';
import 'package:zoyo_bathware/constants/app_colors.dart';
import 'package:zoyo_bathware/features/search_screen/viewmodel/search_viewmodel.dart';
import 'package:zoyo_bathware/widgets/responsive.dart';

class AnimatedSearchBar extends StatelessWidget {
  const AnimatedSearchBar({
    super.key,
    required Animation<Offset> slideAnimation,
    required Animation<double> searchBarAnimation,
    required TextEditingController searchController,
    required this.responsive,
    required this.viewModel,
  }) : _slideAnimation = slideAnimation, _searchBarAnimation = searchBarAnimation, _searchController = searchController;

  final Animation<Offset> _slideAnimation;
  final Animation<double> _searchBarAnimation;
  final TextEditingController _searchController;
  final Responsive responsive;
  final SearchViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _searchBarAnimation,
        child: Container(
          margin: EdgeInsets.all(responsive.wp(4)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha:0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Material(
            elevation: 0,
            borderRadius: BorderRadius.circular(20),
            child: TextField(
              controller: _searchController,
              onChanged: (query) => viewModel.filterProducts(query),
              style: TextStyle(fontSize: responsive.sp(16)),
              decoration: InputDecoration(
                hintText: "Search for amazing products...",
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: responsive.sp(14),
                ),
                prefixIcon: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withValues(alpha:0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.search,
                    color: AppColors.primaryColor,
                    size: responsive.sp(20),
                  ),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          viewModel.filterProducts('');
                        },
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha:0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.clear,
                            color: Colors.grey,
                            size: responsive.sp(18),
                          ),
                        ),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: responsive.wp(4),
                  vertical: responsive.hp(2),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
