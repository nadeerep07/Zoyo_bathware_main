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
          "Sales  Analysis",
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
            // Sales Chart
            Expanded(
              child: FutureBuilder<List<SalesData>>(
                future: _fetchSalesData(_selectedPeriod),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No sales data available"));
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
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          legend: Legend(isVisible: true),
                          tooltipBehavior: TooltipBehavior(enable: true),
                          series: <LineSeries<SalesData, String>>[
                            LineSeries<SalesData, String>(
                              dataSource: snapshot.data!,
                              xValueMapper: (SalesData sales, _) =>
                                  sales.period,
                              yValueMapper: (SalesData sales, _) =>
                                  sales.currentPeriodSales,
                              name: 'Sales',
                              color: Colors.blue,
                              markerSettings: MarkerSettings(isVisible: true),
                              dataLabelSettings: DataLabelSettings(
                                  isVisible: true,
                                  textStyle: TextStyle(fontSize: 12)),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<SalesData>> _fetchSalesData(String period) async {
    var invoiceBox = await Hive.openBox('invoices');

    List<dynamic> invoices = invoiceBox.values.toList();
    Map<String, double> salesMap = {};

    for (var invoice in invoices) {
      double invoiceTotal = (invoice['total'] is num)
          ? invoice['total'].toDouble()
          : double.tryParse(invoice['total'].toString()) ?? 0;

      DateTime invoiceDate;
      try {
        invoiceDate = DateTime.parse(invoice['date']);
      } catch (e) {
        continue;
      }

      String periodKey = (period == 'Weekly')
          ? "${invoiceDate.day}-${invoiceDate.month}-${invoiceDate.year}"
          : "${invoiceDate.month}-${invoiceDate.year}";

      salesMap[periodKey] = (salesMap[periodKey] ?? 0) + invoiceTotal;
    }

    return salesMap.entries.map((e) => SalesData(e.key, e.value)).toList();
  }
}

class SalesData {
  final String period;
  final double currentPeriodSales;

  SalesData(this.period, this.currentPeriodSales);
}
