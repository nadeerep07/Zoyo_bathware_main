// home_screen.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zoyo_bathware/features/home_screen/view/components/carousel_empty.dart';
import 'package:zoyo_bathware/features/home_screen/view/widegts/new_arrivals_widget.dart';
import 'package:zoyo_bathware/features/home_screen/view/widegts/welcome_widget.dart';
import 'package:zoyo_bathware/features/home_screen/viewmodel/home_viewmodel.dart';
import 'package:zoyo_bathware/widgets/Home_widgets/carousel_widets.dart';
import 'package:zoyo_bathware/widgets/Home_widgets/drawer_widget.dart';
import 'package:zoyo_bathware/features/search_screen/view/screens/search_screen.dart';
import 'package:zoyo_bathware/widgets/responsive.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: Consumer<HomeViewModel>(
        builder: (context, vm, _) {
          double appBarHeight = kIsWeb ? 100 : res.hp(12);
          double imageHeight = kIsWeb ? 80 : res.hp(8);
          double iconSize = kIsWeb ? 28 : res.wp(7);
          double horizontalPadding = kIsWeb ? 24 : res.wp(5);

          return Scaffold(
            backgroundColor: const Color(0xFFF8FAFC),
            drawer: const AppDrawer(),
            body: vm.isLoading
                ? const Center(child: CircularProgressIndicator())
                : CustomScrollView(
                    slivers: [
                      // App Bar
                      SliverAppBar(
                        expandedHeight: appBarHeight,
                        pinned: true,
                        backgroundColor: Colors.white,
                        surfaceTintColor: Colors.transparent,
                        scrolledUnderElevation: 0,
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
                                      builder: (context) => const SearchScreen()),
                                );
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

                      SliverToBoxAdapter(
                        child: Container(
                          color: const Color(0xFFF8FAFC),
                          padding:
                              EdgeInsets.symmetric(horizontal: horizontalPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 24),
                              WelcomeSectionWidget(),
                              const SizedBox(height: 24),

                              // Carousel
                              vm.carouselImages.isEmpty
                                  ? CarouselEmptyWidget()
                                  : CarouselWidget(imagePaths: vm.carouselImages),
                              const SizedBox(height: 32),

                              // New Arrivals
                              NewArrivalsWidget(products: vm.newArrivals),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
