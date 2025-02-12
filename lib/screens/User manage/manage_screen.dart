import 'package:flutter/material.dart';
import 'package:zoyo_bathware/screens/User%20manage/NavigatingScreens/added_product_screen.dart';
import 'package:zoyo_bathware/screens/User%20manage/Add%20And%20Edit/Product%20section/product_add_edit.dart';
import 'package:zoyo_bathware/screens/User%20manage/Add%20And%20Edit/category%20section/category_screen.dart';
import 'package:zoyo_bathware/screens/User%20manage/Product_purchase/purchase_screen.dart';
import 'package:zoyo_bathware/screens/User%20manage/Product_purchase/purchased_product_screen.dart';
import 'package:zoyo_bathware/services/app_colors.dart';
import 'package:zoyo_bathware/utilitis/widgets/back_botton.dart';

class ManageScreen extends StatelessWidget {
  const ManageScreen({super.key});

  // Function to build manage options
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
          // Navigate to the respective screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => targetScreen),
          );
        },
      ),
    );
  }

  // Function to build sales summary columns
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
            // Manage Options List
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
    );
  }
}
