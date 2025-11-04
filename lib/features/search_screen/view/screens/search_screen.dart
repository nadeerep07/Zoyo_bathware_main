import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zoyo_bathware/constants/app_colors.dart';
import 'package:zoyo_bathware/features/search_screen/view/widegts/aminated_product_grid.dart';
import 'package:zoyo_bathware/features/search_screen/view/widegts/animated_app_bar.dart';
import 'package:zoyo_bathware/features/search_screen/view/widegts/animated_filter.dart';
import 'package:zoyo_bathware/features/search_screen/view/widegts/animated_search_bar.dart';
import 'package:zoyo_bathware/features/search_screen/view/widegts/filter_toggle.dart';
import 'package:zoyo_bathware/features/search_screen/viewmodel/search_viewmodel.dart';
import 'package:zoyo_bathware/widgets/responsive.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();

  // Animation Controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _searchBarController;
  late AnimationController _filterController;

  // Animations
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _searchBarAnimation;
  late Animation<double> _filterAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SearchViewModel>().initialize();
      _startAnimations();
    });
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _searchBarController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _filterController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );
    _searchBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _searchBarController, curve: Curves.easeOutBack),
    );
    _filterAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _filterController, curve: Curves.easeInOut),
    );
  }

  void _startAnimations() {
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _slideController.forward();
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      _scaleController.forward();
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      _searchBarController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Consumer<SearchViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return CustomScrollView(
            slivers: [
              AnimatedAppBar(
                  fadeAnimation: _fadeAnimation,
                  scaleAnimation: _scaleAnimation,
                  context: context,
                  responsive: responsive),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    AnimatedSearchBar(
                        slideAnimation: _slideAnimation,
                        searchBarAnimation: _searchBarAnimation,
                        searchController: _searchController,
                        responsive: responsive,
                        viewModel: viewModel),
                    FilterToggle(
                        fadeAnimation: _fadeAnimation,
                        filterController: _filterController,
                        responsive: responsive,
                        viewModel: viewModel),
                    if (viewModel.showFilters)
                      AnimatedFilter(
                          filterAnimation: _filterAnimation,
                          filterController: _filterController,
                          context: context,
                          searchController: _searchController,
                          responsive: responsive,
                          viewModel: viewModel),
                  ],
                ),
              ),
              AminatedProductGrid(
                  fadeAnimation: _fadeAnimation,
                  slideController: _slideController,
                  scaleController: _scaleController,
                  responsive: responsive,
                  viewModel: viewModel),
            ],
          );
        },
      ),
      floatingActionButton: _buildFloatingActionButton(responsive),
    );
  }

  Widget _buildFloatingActionButton(Responsive responsive) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FloatingActionButton.extended(
        onPressed: _showCategorySelection,
        backgroundColor: AppColors.primaryColor,
        elevation: 8,
        label: Text(
          "Categories",
          style: TextStyle(
            fontSize: responsive.sp(14),
            fontWeight: FontWeight.w600,
          ),
        ),
        icon: Icon(
          Icons.category_outlined,
          size: responsive.sp(18),
        ),
      ),
    );
  }

  void _showCategorySelection() {
    final viewModel = context.read<SearchViewModel>();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    height: 4,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Categories',
                          style: TextStyle(
                            fontSize: Responsive(context).sp(20),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color:
                                AppColors.primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            '${viewModel.getTotalProductCount()} Products',
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: Responsive(context).sp(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Consumer<SearchViewModel>(
                      builder: (context, vm, child) {
                        return ListView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: vm.categories.length,
                          itemBuilder: (context, index) {
                            String category = vm.categories[index];
                            int productCount =
                                vm.getProductCountForCategory(category);
                            bool isSelected = vm.selectedCategory == category;

                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.only(bottom: 12),
                              child: Material(
                                color: isSelected
                                    ? AppColors.primaryColor
                                    : Colors.grey[50],
                                borderRadius: BorderRadius.circular(16),
                                elevation: isSelected ? 4 : 0,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: () {
                                    vm.updateCategory(
                                        category, _searchController.text);
                                    Navigator.pop(context);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? Colors.white
                                                : AppColors.primaryColor,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Text(
                                            category,
                                            style: TextStyle(
                                              color: isSelected
                                                  ? Colors.white
                                                  : Colors.grey[800],
                                              fontWeight: FontWeight.w600,
                                              fontSize:
                                                  Responsive(context).sp(16),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? Colors.white
                                                    .withValues(alpha: 0.2)
                                                : AppColors.primaryColor
                                                    .withValues(alpha: 0.1),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            '$productCount',
                                            style: TextStyle(
                                              color: isSelected
                                                  ? Colors.white
                                                  : AppColors.primaryColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  Responsive(context).sp(12),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _searchBarController.dispose();
    _filterController.dispose();
    super.dispose();
  }
}
