import 'package:flutter/material.dart';
import 'package:zoyo_bathware/database/data_operations/category_db.dart';
import 'package:zoyo_bathware/database/data_operations/product_db.dart';
 import 'package:zoyo_bathware/utilitis/product_card.dart';
import 'package:zoyo_bathware/utilitis/custom_widgets/back_botton.dart';
import 'package:zoyo_bathware/database/product_model.dart';
import 'package:zoyo_bathware/services/app_colors.dart';

// Responsive class
class Responsive {
  final BuildContext context;
  final Size size;
  final TextScaler textScaler;

  Responsive(this.context)
      : size = MediaQuery.of(context).size,
        textScaler = MediaQuery.of(context).textScaler;

  double wp(double percent) => size.width * percent / 100;
  double hp(double percent) => size.height * percent / 100;
  double sp(double fontSize) => textScaler.scale(fontSize);
  double get width => size.width;
  double get height => size.height;
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _filteredProducts = [];
  List<String> _categories = ['All Categories'];
  String selectedCategory = 'All Categories';
  final double _minPrice = 0;
  final double _maxPrice = 40000;
  RangeValues _priceRange = const RangeValues(0, 40000);
  bool showOutOfStock = true;
  int _selectedSortOption = 0;
  bool _showFilters = false;

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
      getAllProducts();
      getAllCategory();
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
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));
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

  void _filterProducts(String query) {
    List<Product> filteredList = productsNotifier.value.where((product) {
      final nameLower = product.productName.toLowerCase();
      final codeLower = product.productCode.toLowerCase();
      final searchLower = query.toLowerCase();

      bool matchesSearch =
          nameLower.contains(searchLower) || codeLower.contains(searchLower);
      bool matchesCategory = selectedCategory == 'All Categories' ||
          product.category == selectedCategory;
      bool matchesPrice = product.salesRate >= _priceRange.start &&
          product.salesRate <= _priceRange.end;
      bool matchesStock = !showOutOfStock || product.quantity > 0;

      return matchesSearch && matchesCategory && matchesPrice && matchesStock;
    }).toList();

    setState(() {
      _filteredProducts = filteredList;
      _sortProducts();
    });
  }

  void _sortProducts() {
    List<Product> sortedProducts = List.from(_filteredProducts);
    switch (_selectedSortOption) {
      case 0:
        sortedProducts.sort((a, b) => a.productName.compareTo(b.productName));
        break;
      case 1:
        sortedProducts.sort((a, b) => a.salesRate.compareTo(b.salesRate));
        break;
      case 2:
        sortedProducts.sort((a, b) => b.salesRate.compareTo(a.salesRate));
        break;
    }
    setState(() {
      _filteredProducts = sortedProducts;
    });
  }

  Future<void> getAllCategory() async {
    await getAllCategories();
    if (categoriesNotifier.value.isNotEmpty) {
      setState(() {
        _categories = [
          'All Categories',
          ...categoriesNotifier.value.map((e) => e.name)
        ];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          _buildAnimatedAppBar(responsive),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildAnimatedSearchBar(responsive),
                _buildFilterToggle(responsive),
                if (_showFilters) _buildAnimatedFilters(responsive),
              ],
            ),
          ),
          _buildAnimatedProductGrid(responsive),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(responsive),
    );
  }

  Widget _buildAnimatedAppBar(Responsive responsive) {
    return SliverAppBar(
      expandedHeight: responsive.hp(12),
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: AppColors.primaryColor,
      leading: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: backButton(context),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: FadeTransition(
          opacity: _fadeAnimation,
          child: Text(
            "Search Products",
            style: TextStyle(
              fontSize: responsive.sp(20),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        centerTitle: true,
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryColor,
                AppColors.primaryColor.withOpacity(0.8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedSearchBar(Responsive responsive) {
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
                color: Colors.black.withOpacity(0.1),
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
              onChanged: _filterProducts,
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
                    color: AppColors.primaryColor.withOpacity(0.1),
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
                          _filterProducts('');
                        },
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
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

  Widget _buildFilterToggle(Responsive responsive) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: responsive.wp(4)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Found ${_filteredProducts.isEmpty && _searchController.text.isEmpty ? productsNotifier.value.length : _filteredProducts.length} products",
              style: TextStyle(
                fontSize: responsive.sp(14),
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: Material(
                color: _showFilters ? AppColors.primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(12),
                elevation: _showFilters ? 4 : 2,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    setState(() {
                      _showFilters = !_showFilters;
                    });
                    if (_showFilters) {
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
                          color: _showFilters ? Colors.white : AppColors.primaryColor,
                          size: responsive.sp(18),
                        ),
                        SizedBox(width: responsive.wp(2)),
                        Text(
                          "Filters",
                          style: TextStyle(
                            color: _showFilters ? Colors.white : AppColors.primaryColor,
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

  Widget _buildAnimatedFilters(Responsive responsive) {
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
              _buildPriceRangeFilter(responsive),
              SizedBox(height: responsive.hp(2)),
              _buildCategoryFilter(responsive),
              SizedBox(height: responsive.hp(2)),
              _buildSortAndStockOptions(responsive),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceRangeFilter(Responsive responsive) {
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
            inactiveTrackColor: AppColors.primaryColor.withOpacity(0.3),
            thumbColor: AppColors.primaryColor,
            overlayColor: AppColors.primaryColor.withOpacity(0.2),
            valueIndicatorColor: AppColors.primaryColor,
          ),
          child: RangeSlider(
            values: _priceRange,
            min: _minPrice,
            max: _maxPrice,
            divisions: 100,
            labels: RangeLabels(
              "₹${_priceRange.start.toStringAsFixed(0)}",
              "₹${_priceRange.end.toStringAsFixed(0)}",
            ),
            onChanged: (RangeValues values) {
              setState(() {
                _priceRange = values;
              });
              _filterProducts(_searchController.text);
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: responsive.wp(3),
                vertical: responsive.hp(0.5),
              ),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "₹${_priceRange.start.toStringAsFixed(0)}",
                style: TextStyle(
                  fontSize: responsive.sp(12),
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: responsive.wp(3),
                vertical: responsive.hp(0.5),
              ),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "₹${_priceRange.end.toStringAsFixed(0)}",
                style: TextStyle(
                  fontSize: responsive.sp(12),
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryFilter(Responsive responsive) {
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
        Container(
          height: responsive.hp(5),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              final isSelected = selectedCategory == category;
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
                      setState(() {
                        selectedCategory = category;
                        _filterProducts(_searchController.text);
                      });
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

  Widget _buildSortAndStockOptions(Responsive responsive) {
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
                value: _selectedSortOption,
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
                  setState(() {
                    _selectedSortOption = value!;
                    _sortProducts();
                  });
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
              value: showOutOfStock,
              onChanged: (value) {
                setState(() {
                  showOutOfStock = value;
                  _filterProducts(_searchController.text);
                });
              },
              activeColor: AppColors.primaryColor,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAnimatedProductGrid(Responsive responsive) {
    final displayedProducts =
        _filteredProducts.isNotEmpty || _searchController.text.isNotEmpty
            ? _filteredProducts
            : productsNotifier.value;

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
          childAspectRatio: 0.55,
          crossAxisSpacing: responsive.wp(0.1),
          mainAxisSpacing: responsive.hp(0.2),
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(0, 0.3),
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
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        int totalProductCount = _getTotalProductCount();

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
                            color: AppColors.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            '$totalProductCount Products',
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
                    child: ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        String category = _categories[index];
                        int productCount = _getProductCountForCategory(category);
                        bool isSelected = selectedCategory == category;

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
                                setState(() {
                                  selectedCategory = category;
                                  _filterProducts(_searchController.text);
                                });
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
                                          fontSize: Responsive(context).sp(16),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Colors.white.withOpacity(0.2)
                                            : AppColors.primaryColor
                                                .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        '$productCount',
                                        style: TextStyle(
                                          color: isSelected
                                              ? Colors.white
                                              : AppColors.primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: Responsive(context).sp(12),
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

  int _getProductCountForCategory(String category) {
    if (category == 'All Categories') {
      return productsNotifier.value.length;
    }
    return productsNotifier.value
        .where((product) => product.category == category)
        .length;
  }

  int _getTotalProductCount() {
    return productsNotifier.value.length;
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