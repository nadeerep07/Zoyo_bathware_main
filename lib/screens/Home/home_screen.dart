import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:zoyo_bathware/database/product_model.dart';
import 'package:zoyo_bathware/screens/all_categories/all_categories_screen.dart';
import 'package:zoyo_bathware/screens/billing_section/billing_screen.dart';
import 'package:zoyo_bathware/screens/cabinet_screen/cabinet_screen.dart';
import 'package:zoyo_bathware/screens/search_screen/search_screen.dart';
import 'package:zoyo_bathware/screens/user_manage/manage_screen.dart';
import 'package:zoyo_bathware/services/app_colors.dart';
import 'package:zoyo_bathware/utilitis/Home_widgets/carousel_widets.dart';
import 'package:zoyo_bathware/utilitis/Home_widgets/drawer_widget.dart';
import 'package:zoyo_bathware/utilitis/Home_widgets/new_arraivals_widget.dart';
import 'package:zoyo_bathware/utilitis/custom_widgets/bottom_navigation.dart';

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

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AllCategories()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CabinetScreen()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ManageScreen()),
        );
        break;
      default:
        break;
    }
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
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;
        double screenHeight = constraints.maxHeight;

        // Define responsive sizes
        double appBarHeight = kIsWeb ? 100 : screenHeight * 0.15;
        double imageHeight = kIsWeb ? 95 : screenHeight * 0.1;
        double iconSize = kIsWeb ? 40 : screenWidth * 0.08;
        double padding = kIsWeb ? 20 : screenWidth * 0.04;

        return Scaffold(
          drawer: const AppDrawer(),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(appBarHeight),
            child: AppBar(
              backgroundColor: AppColors.backgroundColor,
              foregroundColor: AppColors.primaryColor,
              leading: Builder(
                builder: (context) => IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: Icon(Icons.menu, size: iconSize),
                ),
              ),
              centerTitle: true,
              flexibleSpace: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.005),
                  Image.asset(
                    'assets/images/Screenshot 2025-02-03 at 8.38.37 PM.png',
                    height: imageHeight,
                  ),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SearchScreen()));
                  },
                  icon: Icon(Icons.search, size: iconSize),
                ),
                SizedBox(width: screenWidth * 0.04),
              ],
            ),
          ),
          body: Container(
            color: AppColors.backgroundColor,
            width: double.infinity,
            height: double.infinity,
            padding: EdgeInsets.all(padding),
            child: Column(
              children: [
                // Carousel Slider
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(padding),
                    child: _carouselImagePaths.isEmpty
                        ? Center(
                            child: Text(
                              'No images added yet',
                              style: TextStyle(
                                fontSize: kIsWeb ? 22 : screenWidth * 0.05,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : CarouselWidget(imagePaths: _carouselImagePaths),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                // New Arrivals Section
                NewArrivalsWidget(productsNotifier: productsNotifier),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BillingScreen()));
            },
            backgroundColor: Colors.blue,
            child: const Icon(Icons.shopping_cart, color: Colors.white),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: CustomBottomNavigationBar(
            selectedIndex: _selectedIndex,
            onItemTapped: _onItemTapped,
          ),
        );
      },
    );
  }
}
