import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:zoyo_bathware/screens/all_categories/all_categories_screen.dart';
import 'package:zoyo_bathware/screens/billing_section/billing_screen.dart';
import 'package:zoyo_bathware/screens/cabinet_screen/cabinet_screen.dart';
import 'package:zoyo_bathware/screens/detail_screens/details_screen.dart';
import 'package:zoyo_bathware/screens/sales_history/invoice_screen.dart';
import 'package:zoyo_bathware/screens/search_screen/search_screen.dart';
import 'package:zoyo_bathware/screens/user_manage/manage_screen.dart';
import 'package:zoyo_bathware/services/app_colors.dart';
import 'package:zoyo_bathware/database/product_model.dart';
import 'package:zoyo_bathware/utilitis/widgets/bottom_navigation.dart';

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
    _fetchCarouselImages(); // Fetch carousel images
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
    _fetchCarouselImages(); // Refresh carousel images when returning to HomeScreen
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

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
            ),
            child: const Center(
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.receipt_long),
            title: const Text('Invoices'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const InvoicesScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Billing'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BillingScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      drawer: _buildDrawer(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.15),
        child: AppBar(
          backgroundColor: AppColors.backgroundColor,
          foregroundColor: AppColors.primaryColor,
          leading: Builder(
            builder: (context) => IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(
                Icons.menu,
                size: screenWidth * 0.08,
              ),
            ),
          ),
          centerTitle: true,
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.05),
              Image.asset(
                'assets/images/Screenshot 2025-02-03 at 8.38.37 PM.png',
                height: screenHeight * 0.1,
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
              icon: Icon(
                Icons.search,
                size: screenWidth * 0.08,
              ),
            ),
            SizedBox(width: screenWidth * 0.04),
          ],
        ),
      ),
      body: Container(
        color: AppColors.backgroundColor,
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          children: [
            // Carousel Slider at the top
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.02),
                child: _carouselImagePaths.isEmpty
                    ? Center(
                        child: Text(
                          'No images added yet',
                          style: TextStyle(
                            fontSize: screenWidth * 0.05,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : CarouselSlider.builder(
                        itemCount: _carouselImagePaths.length,
                        itemBuilder: (context, index, realIndex) {
                          return SizedBox(
                            width: double.infinity,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                File(_carouselImagePaths[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                        options: CarouselOptions(
                          autoPlay: true,
                          aspectRatio: 16 / 9,
                          enlargeCenterPage: true,
                          viewportFraction: 1.0,
                        ),
                      ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            // New Arrivals Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'New Arrivals',
                  style: TextStyle(
                    fontSize: screenWidth * 0.06,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AllCategories()),
                    );
                  },
                  child: Text(
                    'View All',
                    style: TextStyle(
                      color: AppColors.buttonColor,
                      fontSize: screenWidth * 0.05,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.02),
            // New Arrivals Carousel
            SizedBox(
              height: screenHeight * 0.25,
              child: ValueListenableBuilder<List<Product>>(
                valueListenable: productsNotifier,
                builder: (context, products, child) {
                  if (products.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return CarouselSlider.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index, realIndex) {
                        final product = products[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailScreen(
                                    productCode: product.id!),
                              ),
                            );
                          },
                          child: SizedBox(
                            width: screenWidth * 0.6,
                            child: Card(
                              elevation: 6,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Stack(
                                  children: [
                                    Image.file(
                                      File(product.imagePaths.first),
                                      fit: BoxFit.cover,
                                      height: screenHeight * 0.2,
                                      width: double.infinity,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.black.withOpacity(0.4),
                                            Colors.transparent,
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: screenHeight * 0.01,
                                      left: screenWidth * 0.04,
                                      right: screenWidth * 0.04,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.productName,
                                            style: TextStyle(
                                              fontSize: screenWidth * 0.05,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(
                                              height: screenHeight * 0.001),
                                          Text(
                                            'Code: ${product.productCode}',
                                            style: TextStyle(
                                              fontSize: screenWidth * 0.04,
                                              color: Colors.white70,
                                            ),
                                          ),
                                          SizedBox(
                                              height: screenHeight * 0.001),
                                          Text(
                                            'ZRP: ₹${product.salesRate.toStringAsFixed(2)}',
                                            style: TextStyle(
                                              fontSize: screenWidth * 0.04,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.secondaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      options: CarouselOptions(
                        height: screenHeight * 0.25,
                        enlargeCenterPage: true,
                        autoPlay: false,
                        aspectRatio: 16 / 9,
                        enableInfiniteScroll: true,
                      ),
                    );
                  }
                },
              ),
            )
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
