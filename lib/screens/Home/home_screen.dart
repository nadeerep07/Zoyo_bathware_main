import 'dart:developer';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:zoyo_bathware/navigationSCreens/details_screen.dart';
import 'package:zoyo_bathware/screens/Cart%20Section/CArt_screen.dart';
import 'package:zoyo_bathware/screens/Home/search_screen.dart';
import 'package:zoyo_bathware/screens/Products/all_categories.dart';
import 'package:zoyo_bathware/screens/User%20manage/manage_screen.dart';
import 'package:zoyo_bathware/services/app_colors.dart';
import 'package:zoyo_bathware/database/product_model.dart';
import 'package:zoyo_bathware/utilitis/widgets/bottom_navigation.dart';
import 'package:zoyo_bathware/utilitis/widgets/carousel_silder.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ValueNotifier<List<Product>> productsNotifier =
      ValueNotifier<List<Product>>([]);

  Future<void> fetchProducts() async {
    final box = await Hive.openBox<Product>('products');
    log('data fetching: ${box.length}');
    final products = box.values.toList();
    products.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
    productsNotifier.value = products; // Update the notifier
  }

  List<Product> products = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AllCategories()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ManageScreen()),
        );
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: AppBar(
          backgroundColor: AppColors.backgroundColor,
          foregroundColor: AppColors.primaryColor,
          leading: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.view_list,
              size: 32,
            ),
          ),
          centerTitle: true,
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              Image.asset(
                'assets/images/Screenshot 2025-02-03 at 8.38.37 PM.png',
                height: 100,
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchScreen()));
              },
              icon: Icon(
                Icons.search,
                size: 32,
              ),
            ),
            SizedBox(width: 16),
          ],
        ),
      ),
      body: Container(
        color: AppColors.backgroundColor,
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: CustomCarouselSlider(
                  imagePaths: [
                    'assets/images/WhatsApp Image 2025-01-27 at 15.39.44 (1).jpeg',
                    'assets/images/WhatsApp Image 2025-01-27 at 15.39.44 (2).jpeg',
                    'assets/images/WhatsApp Image 2025-01-27 at 15.39.44.jpeg',
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'All Products',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllCategories(),
                        ));
                  },
                  child: Text(
                    'View All',
                    style: TextStyle(color: AppColors.buttonColor),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: ValueListenableBuilder<List<Product>>(
                valueListenable: productsNotifier,
                builder: (context, products, child) {
                  if (products.isEmpty) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return CarouselSlider.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index, realIndex) {
                        final product = products[index];
                        return Builder(
                          builder: (context) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ProductDetailScreen(
                                                productCode: product.id!)));
                              },
                              child: SizedBox(
                                width: 250,
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
                                          height: 150,
                                          width: double.infinity,
                                        ),
                                        // Gradient overlay for better text visibility
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
                                        // Product Details
                                        Positioned(
                                          bottom: 16,
                                          left: 16,
                                          right: 16,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                product.productName,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                'Code: ${product.productCode}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white70,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                'ZRP: ₹${product.salesRate.toStringAsFixed(2)}',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.buttonColor,
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
                        );
                      },
                      options: CarouselOptions(
                        height: 250,
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
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CartScreen()));
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.shopping_cart, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
