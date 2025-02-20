import 'package:flutter/material.dart';
import 'package:zoyo_bathware/screens/billing_section/billing_screen.dart';
import 'package:zoyo_bathware/screens/home/home_screen.dart';
import 'package:zoyo_bathware/screens/user_manage/add_edit/category%20section/category_screen.dart';
import 'package:zoyo_bathware/screens/user_manage/manage_screen_navigation/added_product_screen.dart';
import 'package:zoyo_bathware/screens/user_manage/product_purchase/purchase_screen.dart';
import 'package:zoyo_bathware/screens/user_manage/product_purchase/purchased_product_screen.dart';
import 'package:zoyo_bathware/screens/cabinet_screen/cabinet_screen.dart';
import 'package:zoyo_bathware/services/app_colors.dart';
import 'package:zoyo_bathware/utilitis/widgets/back_botton.dart';
import 'package:zoyo_bathware/utilitis/widgets/bottom_navigation.dart';

import '../all_categories/all_categories.dart';

class ManageScreen extends StatefulWidget {
  const ManageScreen({super.key});

  @override
  State<ManageScreen> createState() => _ManageScreenState();
}

class _ManageScreenState extends State<ManageScreen> {
  int _selectedIndex = 3; // Set Manage as the selected tab

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

  // widget building card
  Widget _buildManageItem(
      BuildContext context, IconData icon, String title, Widget targetScreen) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 1,
      child: ListTile(
        leading: Icon(icon, color: Colors.black54),
        title: Text(title, style: TextStyle(fontSize: 16)),
        trailing:
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
        onTap: () {
          // navigating to clicking screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => targetScreen),
          );
        },
      ),
    );
  }

  // Sales card
  Widget _buildSalesColumn(String title, String amount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Text(amount,
            style: TextStyle(
                fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blue)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: backButton(context),
        title: Text("Manage Products"),
        backgroundColor: AppColors.backgroundColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Sales Summary Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSalesColumn("Total Sales", "12,00,900.00"),
                    _buildSalesColumn("Today's Sales", "50,9750.00"),
                    _buildSalesColumn("Last 7 Days", "1,19,360.00"),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            _buildManageItem(
                context, Icons.category, " Category", CategoryScreen()),
            _buildManageItem(
                context, Icons.inventory_2, "Product", ProductScreen()),
            _buildManageItem(context, Icons.history, "Purchase History",
                PurchasedProductsScreen()), // Optional
            _buildManageItem(context, Icons.production_quantity_limits,
                "Purchase ", PurchaseProductScreen()), // Optional

            // _buildManageItem(
            //     context, Icons.settings, "Settings", Settings()), // Optional
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
