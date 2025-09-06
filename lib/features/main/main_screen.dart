import 'package:flutter/material.dart';
import 'package:zoyo_bathware/features/all_categories/all_categories_screen.dart';
import 'package:zoyo_bathware/features/billing_section/billing_screen.dart';
import 'package:zoyo_bathware/features/cabinet_screen/cabinet_screen.dart';
import 'package:zoyo_bathware/features/home_screen/view/screens/home_screen.dart';
import 'package:zoyo_bathware/features/user_manage/manage_screen.dart';
import 'package:zoyo_bathware/utilitis/custom_widgets/bottom_navigation.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // List of pages for bottom nav
  final List<Widget> _pages = [
    const HomeScreen(),      // old HomeScreen body moved here
    const AllCategories(),
    const CabinetScreen(),
    const ManageScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // 👉 change body on index
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const BillingScreen()));
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
