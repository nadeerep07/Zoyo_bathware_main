import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:hive/hive.dart';
import 'package:zoyo_bathware/services/app_colors.dart';

class SalesGraphScreen extends StatefulWidget {
  const SalesGraphScreen({super.key});

  @override
  State<SalesGraphScreen> createState() => _SalesGraphScreenState();
}

class _SalesGraphScreenState extends State<SalesGraphScreen> {
  String _selectedPeriod = 'Weekly';
  final List<String> _periodOptions = ['Weekly', 'Monthly'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Sales & Profit Analysis",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown for period selection
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedPeriod,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedPeriod = newValue!;
                    });
                  },
                  items: _periodOptions
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(fontSize: 16)),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // TabBar to switch between Sales and Profit charts
            Expanded(
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    // TabBar
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TabBar(
                        labelColor: Colors.blue,
                        unselectedLabelColor: Colors.grey,
                        tabs: const [
                          Tab(text: 'Sales'),
                          Tab(text: 'Profit'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // TabBarView for Sales and Profit charts
                    Expanded(
                      child: TabBarView(
                        children: [
                          // Sales Chart
                          FutureBuilder<List<SalesData>>(
                            future: _fetchSalesData(_selectedPeriod),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text("Error: ${snapshot.error}"));
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return const Center(
                                    child: Text("No sales data available"));
                              } else {
                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: SfCartesianChart(
                                      primaryXAxis: CategoryAxis(),
                                      title: ChartTitle(
                                        text: "Sales Trend - $_selectedPeriod",
                                        textStyle: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      legend: Legend(isVisible: true),
                                      tooltipBehavior:
                                          TooltipBehavior(enable: true),
                                      series: <CartesianSeries<dynamic,
                                          dynamic>>[
                                        LineSeries<SalesData, String>(
                                          dataSource: snapshot.data!,
                                          xValueMapper: (SalesData sales, _) =>
                                              sales.period,
                                          yValueMapper: (SalesData sales, _) =>
                                              sales.currentPeriodSales,
                                          name: 'Sales',
                                          color: Colors.blue,
                                          markerSettings:
                                              MarkerSettings(isVisible: true),
                                          dataLabelSettings: DataLabelSettings(
                                              isVisible: true,
                                              textStyle:
                                                  TextStyle(fontSize: 12)),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                          // Profit Chart
                          FutureBuilder<List<SalesData>>(
                            future: _fetchSalesData(_selectedPeriod),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text("Error: ${snapshot.error}"));
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return const Center(
                                    child: Text("No profit data available"));
                              } else {
                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: SfCartesianChart(
                                      primaryXAxis: CategoryAxis(),
                                      title: ChartTitle(
                                        text: "Profit Trend - $_selectedPeriod",
                                        textStyle: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      legend: Legend(isVisible: true),
                                      tooltipBehavior:
                                          TooltipBehavior(enable: true),
                                      series: <CartesianSeries<dynamic,
                                          dynamic>>[
                                        LineSeries<SalesData, String>(
                                          dataSource: snapshot.data!,
                                          xValueMapper: (SalesData sales, _) =>
                                              sales.period,
                                          yValueMapper: (SalesData sales, _) =>
                                              sales.profit,
                                          name: 'Profit',
                                          color: Colors.green,
                                          markerSettings:
                                              MarkerSettings(isVisible: true),
                                          dataLabelSettings: DataLabelSettings(
                                              isVisible: true,
                                              textStyle:
                                                  TextStyle(fontSize: 12)),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<SalesData>> _fetchSalesData(String period) async {
    var invoiceBox = Hive.box('invoices');

    List<dynamic> invoices = invoiceBox.values.toList();
    Map<String, SalesData> salesMap = {};

    for (var invoice in invoices) {
      try {
        double invoiceTotal = (invoice['total'] is num)
            ? invoice['total'].toDouble()
            : double.tryParse(invoice['total'].toString()) ?? 0;

        double salesRate = (invoice['salesRate'] is num)
            ? invoice['salesRate'].toDouble()
            : double.tryParse(invoice['salesRate'].toString()) ?? 0;

        double purchaseRate = (invoice['purchaseRate'] is num)
            ? invoice['purchaseRate'].toDouble()
            : double.tryParse(invoice['purchaseRate'].toString()) ?? 0;

        int quantity = (invoice['quantity'] is int)
            ? invoice['quantity']
            : int.tryParse(invoice['quantity'].toString()) ?? 0;

        double discount = (invoice['discount'] is num)
            ? invoice['discount'].toDouble()
            : double.tryParse(invoice['discount'].toString()) ?? 0;

        // Ensure invoice date is valid
        DateTime invoiceDate =
            DateTime.tryParse(invoice['date'] ?? '') ?? DateTime(1970, 1, 1);

        if (invoiceDate.year == 1970) continue;

        String periodKey = (period == 'Weekly')
            ? "${invoiceDate.day}-${invoiceDate.month}-${invoiceDate.year}"
            : "${invoiceDate.month}-${invoiceDate.year}";

        double profit =
            (salesRate * quantity) - (purchaseRate * quantity) - discount;

        print(
            "Sales Rate: $salesRate, Purchase Rate: $purchaseRate, Quantity: $quantity, Discount: $discount");
        print("Invoice Total: $invoiceTotal, Calculated Profit: $profit");

        if (salesMap.containsKey(periodKey)) {
          salesMap[periodKey]!.currentPeriodSales += invoiceTotal;
          salesMap[periodKey]!.profit += profit;
        } else {
          salesMap[periodKey] = SalesData(periodKey, invoiceTotal, profit);
        }
      } catch (e) {
        print("Error processing invoice: $e");
      }
    }

    return salesMap.values.toList();
  }
}

class SalesData {
  final String period;
  double currentPeriodSales;
  double profit;

  SalesData(this.period, this.currentPeriodSales, this.profit);
}
