import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:zoyo_bathware/database/product_model.dart';
import 'package:zoyo_bathware/features/search_screen/search_screen.dart';
import 'package:zoyo_bathware/services/app_colors.dart';
import 'package:zoyo_bathware/utilitis/Home_widgets/carousel_widets.dart';
import 'package:zoyo_bathware/utilitis/Home_widgets/drawer_widget.dart';
import 'package:zoyo_bathware/utilitis/Home_widgets/new_arraivals_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
  late ValueNotifier<List<Product>> productsNotifier =
      ValueNotifier<List<Product>>([]);
  List<String> _carouselImagePaths = [];
  final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  @override
  void initState() {
    super.initState();
    fetchProducts();
    _fetchCarouselImages();
  }

  Future<void> _fetchCarouselImages() async {
    final box = await Hive.openBox<String>('carousel_images');
    setState(() {
      _carouselImagePaths = box.values.toList();
    });
  }

  Future<void> fetchProducts() async {
    final box = await Hive.openBox<Product>('products');
    final products = box.values.toList();
    products
        .sort((a, b) => b.purchaseDate.first.compareTo(a.purchaseDate.first));
    productsNotifier.value = products.take(4).toList();
  }

  @override
  void didPopNext() {
    _fetchCarouselImages();
    super.didPopNext();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(
        this, ModalRoute.of(context)! as PageRoute<dynamic>);
  }

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    // Define responsive sizes
    double appBarHeight = kIsWeb ? 100 : res.hp(12);
    double imageHeight = kIsWeb ? 80 : res.hp(8);
    double iconSize = kIsWeb ? 28 : res.wp(7);
    double horizontalPadding = kIsWeb ? 24 : res.wp(5);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      drawer: const AppDrawer(),
      body: CustomScrollView(
        slivers: [
          // Modern App Bar
          SliverAppBar(
            expandedHeight: appBarHeight,
            floating: false,
            pinned: true,
            backgroundColor: Colors.white,
            surfaceTintColor:
                Colors.transparent, // <- prevents default Material tint
            scrolledUnderElevation: 0, // <- avoids dark overlay when scrolle
            elevation: 0,
            leading: Builder(
              builder: (context) => Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  icon: Icon(Icons.menu,
                      size: iconSize, color: const Color(0xFF475569)),
                ),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SearchScreen()));
                  },
                  icon: Icon(Icons.search,
                      size: iconSize, color: const Color(0xFF475569)),
                ),
              ),
              SizedBox(width: horizontalPadding - 16),
            ],
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Container(
                padding: const EdgeInsets.only(bottom: 8),
                child: Image.asset(
                  'assets/images/Screenshot 2025-02-03 at 8.38.37 PM.png',
                  height: imageHeight,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
              ),
            ),
          ),

          // Main Content
          SliverToBoxAdapter(
            child: Container(
              color: const Color(0xFFF8FAFC),
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),

                  // Welcome Section
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryColor.withOpacity(0.1),
                          AppColors.secondaryColor.withOpacity(0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.primaryColor.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome to ZOYO',
                                style: TextStyle(
                                  fontSize: kIsWeb ? 24 : res.sp(20),
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1E293B),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Discover premium bathware collections',
                                style: TextStyle(
                                  fontSize: kIsWeb ? 16 : res.sp(14),
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.bathroom_outlined,
                            size: kIsWeb ? 32 : res.wp(8),
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Carousel Section
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: _carouselImagePaths.isEmpty
                          ? Container(
                              height: kIsWeb ? 200 : res.hp(20),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.grey.shade100,
                                    Colors.grey.shade50,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.image_outlined,
                                      size: kIsWeb ? 48 : res.wp(12),
                                      color: Colors.grey.shade400,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'No images added yet',
                                      style: TextStyle(
                                        fontSize: kIsWeb ? 18 : res.sp(16),
                                        color: Colors.grey.shade500,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : CarouselWidget(imagePaths: _carouselImagePaths),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // New Arrivals Section
                  NewArrivalsWidget(productsNotifier: productsNotifier),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
      String title, IconData icon, Color color, Responsive res) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: kIsWeb ? 24 : res.wp(6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: kIsWeb ? 14 : res.sp(12),
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }
}
