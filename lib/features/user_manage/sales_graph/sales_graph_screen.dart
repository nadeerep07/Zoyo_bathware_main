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
        title: const Text("Sales & Profit Analysis",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDropdown(),
            const SizedBox(height: 20),
            Expanded(
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    _buildTabBar(),
                    const SizedBox(height: 20),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildChartWithTable('Sales'),
                          _buildChartWithTable('Profit'),
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

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: _boxDecoration(),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedPeriod,
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() => _selectedPeriod = newValue);
            }
          },
          items: _periodOptions
              .map((value) => DropdownMenuItem(
                  value: value,
                  child: Text(value, style: const TextStyle(fontSize: 16))))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: _boxDecoration(),
      child: const TabBar(
        labelColor: Colors.blue,
        unselectedLabelColor: Colors.grey,
        tabs: [Tab(text: 'Sales'), Tab(text: 'Profit')],
      ),
    );
  }

  Widget _buildChartWithTable(String type) {
    return FutureBuilder<List<SalesData>>(
      future: _fetchSalesData(_selectedPeriod),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No data available"));
        }
        return Column(
          children: [
            _buildChart(snapshot.data!, type),
            const SizedBox(height: 20),
            _buildDataTable(snapshot.data!),
          ],
        );
      },
    );
  }

  Widget _buildChart(List<SalesData> data, String type) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          title: ChartTitle(
              text: " $type Trend - $_selectedPeriod",
              textStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          legend: Legend(isVisible: true),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <CartesianSeries<dynamic, dynamic>>[
            LineSeries<SalesData, String>(
              dataSource: data,
              xValueMapper: (sales, _) => sales.period,
              yValueMapper: (sales, _) =>
                  type == 'Sales' ? sales.currentPeriodSales : sales.profit,
              name: type,
              color: type == 'Sales' ? Colors.blue : Colors.green,
              markerSettings: const MarkerSettings(isVisible: true),
              dataLabelSettings: const DataLabelSettings(
                  isVisible: true, textStyle: TextStyle(fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataTable(List<SalesData> data) {
    return Expanded(
      child: SingleChildScrollView(
        child: DataTable(
          columns: const [
            DataColumn(
                label: Text('Date',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Sales',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Profit',
                    style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: data
              .map((sales) => DataRow(cells: [
                    DataCell(Text(sales.period)),
                    DataCell(Text(
                        '₹${sales.currentPeriodSales.toStringAsFixed(2)}')),
                    DataCell(Text('₹${sales.profit.toStringAsFixed(2)}')),
                  ]))
              .toList(),
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
        double invoiceTotal = invoice['total'] ?? 0;
        double invoiceProfit = invoice['profit'] ?? 0;
        DateTime invoiceDate =
            DateTime.tryParse(invoice['date'] ?? '') ?? DateTime(1970, 1, 1);
        if (invoiceDate.year == 1970) continue;

        String periodKey = (period == 'Weekly')
            ? "${invoiceDate.day}-${invoiceDate.month}-${invoiceDate.year}"
            : "${invoiceDate.month}-${invoiceDate.year}";

        salesMap.update(
          periodKey,
          (existing) => SalesData(
              periodKey,
              existing.currentPeriodSales + invoiceTotal,
              existing.profit + invoiceProfit),
          ifAbsent: () => SalesData(periodKey, invoiceTotal, invoiceProfit),
        );
      } catch (e) {
        print("Error processing invoice: $e");
      }
    }
    return salesMap.values.toList();
  }

  BoxDecoration _boxDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
        ],
      );
}

class SalesData {
  final String period;
  double currentPeriodSales;
  double profit;

  SalesData(this.period, this.currentPeriodSales, this.profit);
}
