import 'package:flutter/material.dart';
import 'package:zoyo_bathware/features/search_screen/viewmodel/search_viewmodel.dart';
import 'package:zoyo_bathware/widgets/product/product_card.dart';
import 'package:zoyo_bathware/widgets/responsive.dart';

class AminatedProductGrid extends StatelessWidget {
  const AminatedProductGrid({
    super.key,
    required Animation<double> fadeAnimation,
    required AnimationController slideController,
    required AnimationController scaleController,
    required this.responsive,
    required this.viewModel,
  }) : _fadeAnimation = fadeAnimation, _slideController = slideController, _scaleController = scaleController;

  final Animation<double> _fadeAnimation;
  final AnimationController _slideController;
  final AnimationController _scaleController;
  final Responsive responsive;
  final SearchViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final displayedProducts = viewModel.displayedProducts;

    if (displayedProducts.isEmpty) {
      return SliverFillRemaining(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: responsive.sp(64),
                  color: Colors.grey[400],
                ),
                SizedBox(height: responsive.hp(2)),
                Text(
                  "No products found",
                  style: TextStyle(
                    fontSize: responsive.sp(18),
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: responsive.hp(1)),
                Text(
                  "Try adjusting your filters",
                  style: TextStyle(
                    fontSize: responsive.sp(14),
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.all(responsive.wp(4)),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: responsive.width > 600 ? 3 : 2,
          childAspectRatio: 0.64,
          crossAxisSpacing: responsive.wp(0.1),
          mainAxisSpacing: responsive.hp(0.2),
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.3),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: _slideController,
                    curve: Interval(
                      (index * 0.1).clamp(0.0, 1.0),
                      1.0,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
                ),
                child: ScaleTransition(
                  scale: Tween<double>(
                    begin: 0.8,
                    end: 1.0,
                  ).animate(
                    CurvedAnimation(
                      parent: _scaleController,
                      curve: Interval(
                        (index * 0.1).clamp(0.0, 1.0),
                        1.0,
                        curve: Curves.elasticOut,
                      ),
                    ),
                  ),
                  child: ProductCard(
                    isGridView: true,
                    product: displayedProducts[index],
                  ),
                ),
              ),
            );
          },
          childCount: displayedProducts.length,
        ),
      ),
    );
  }
}