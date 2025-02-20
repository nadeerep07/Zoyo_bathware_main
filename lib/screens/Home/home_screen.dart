import 'dart:developer';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:zoyo_bathware/navigationSCreens/details_screen.dart';
import 'package:zoyo_bathware/screens/billing_section/billing_screen.dart';
import 'package:zoyo_bathware/screens/home/search_screen.dart';
import 'package:zoyo_bathware/screens/Products/all_categories.dart';
import 'package:zoyo_bathware/screens/cabinet_screen/cabinet_screen.dart';
import 'package:zoyo_bathware/screens/user_manage/manage_screen.dart';
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
    products
        .sort((a, b) => b.purchaseDate.first.compareTo(a.purchaseDate.first));
    productsNotifier.value = products.take(4).toList();
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
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CabinetScreen()),
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.15),
        child: AppBar(
          backgroundColor: AppColors.backgroundColor,
          foregroundColor: AppColors.primaryColor,
          leading: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.view_list,
              size: screenWidth * 0.08,
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchScreen()));
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
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.02),
                child: CustomCarouselSlider(
                  imagePaths: [
                    'assets/images/WhatsApp Image 2025-01-27 at 15.39.44 (1).jpeg',
                    'assets/images/WhatsApp Image 2025-01-27 at 15.39.44 (2).jpeg',
                    'assets/images/WhatsApp Image 2025-01-27 at 15.39.44.jpeg',
                  ],
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
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
                          builder: (context) => AllCategories(),
                        ));
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
            SizedBox(
              height: screenHeight * 0.25,
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
                                                  fontSize: screenWidth * 0.040,
                                                  fontWeight: FontWeight.w600,
                                                  color:
                                                      AppColors.secondaryColor,
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
