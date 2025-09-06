import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:zoyo_bathware/features/all_categories/all_categories_screen.dart';
import 'package:zoyo_bathware/features/billing_section/billing_screen.dart';
import 'package:zoyo_bathware/features/cabinet_screen/cabinet_screen.dart';
import 'package:zoyo_bathware/features/settings_screen/settings_screen.dart';
import 'package:zoyo_bathware/features/user_manage/add_edit/category_section/category_screen.dart';
import 'package:zoyo_bathware/features/user_manage/manage_screen_navigation/added_product_screen.dart';
import 'package:zoyo_bathware/features/user_manage/product_purchase/purchase_screen.dart';
import 'package:zoyo_bathware/features/user_manage/product_purchase/purchased_product_screen.dart';
import 'package:zoyo_bathware/features/user_manage/sales_graph/sales_graph_screen.dart';
import 'package:zoyo_bathware/features/user_manage/stock_managment_screen/stock_managment_screen.dart';
import 'package:zoyo_bathware/features/home_screen/view/screens/home_screen.dart';
import 'package:zoyo_bathware/services/app_colors.dart';
import 'package:zoyo_bathware/utilitis/custom_widgets/back_botton.dart';
import 'package:zoyo_bathware/utilitis/custom_widgets/bottom_navigation.dart';

class ManageScreen extends StatefulWidget {
  const ManageScreen({super.key});

  @override
  State<ManageScreen> createState() => _ManageScreenState();
}

class _ManageScreenState extends State<ManageScreen> {
  int _selectedIndex = 3;
  double totalSales = 0;
  double todaySales = 0;
  double last7DaysSales = 0;

  @override
  void initState() {
    super.initState();
    _calculateSales();
  }

  Future<void> _calculateSales() async {
    var invoiceBox = await Hive.openBox('invoices');
    List<dynamic> invoices = invoiceBox.values.toList();

    DateTime now = DateTime.now();
    DateTime sevenDaysAgo = now.subtract(Duration(days: 7));

    double total = 0;
    double todayTotal = 0;
    double last7DaysTotal = 0;

    for (var invoice in invoices) {
      double invoiceTotal =
          (invoice['total'] is int || invoice['total'] is double)
              ? invoice['total']
              : double.tryParse(invoice['total'].toString()) ?? 0;

      DateTime invoiceDate;
      try {
        invoiceDate = DateTime.parse(invoice['date']);
      } catch (e) {
        continue;
      }

      total += invoiceTotal;

      if (invoiceDate.year == now.year &&
          invoiceDate.month == now.month &&
          invoiceDate.day == now.day) {
        todayTotal += invoiceTotal;
      }

      if (invoiceDate.isAfter(sevenDaysAgo)) {
        last7DaysTotal += invoiceTotal;
      }
    }

    setState(() {
      totalSales = total;
      todaySales = todayTotal;
      last7DaysSales = last7DaysTotal;
    });
  }

  Widget _buildManageItem(
      BuildContext context, IconData icon, String title, Widget targetScreen) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: ListTile(
        leading: Icon(icon, color: Colors.black54),
        title: Text(title, style: TextStyle(fontSize: 16)),
        trailing:
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => targetScreen));
        },
      ),
    );
  }

  Widget _buildSalesColumn(BuildContext context, String title, double amount) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SalesGraphScreen()),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text(
            "₹${amount.toStringAsFixed(2)}",
            style: TextStyle(
                fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: backButton(context),
        title: Text("Manage Products"),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Sales Summary Card
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSalesColumn(context, "Total Sales", totalSales),
                    _buildSalesColumn(context, "Today's Sales", todaySales),
                    _buildSalesColumn(context, "Last 7 Days", last7DaysSales),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            _buildManageItem(
                context, Icons.category, "Category", CategoryScreen()),
            _buildManageItem(
                context, Icons.inventory_2, "Product", ProductScreen()),
            _buildManageItem(context, Icons.history, "Purchase History",
                PurchasedProductsScreen()),
            _buildManageItem(context, Icons.production_quantity_limits,
                "Purchase", PurchaseProductScreen()),
            _buildManageItem(context, Icons.assessment, "Stock Management",
                StockManagementScreen()),
            _buildManageItem(
                context, Icons.settings, "Settings", SettingsScreen())
          ],
        ),
      ),
    );
  }
}
