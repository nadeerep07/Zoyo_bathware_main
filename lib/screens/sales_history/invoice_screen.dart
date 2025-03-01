import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:zoyo_bathware/screens/detail_screens/invoice_detail_screen.dart';
import 'package:zoyo_bathware/services/app_colors.dart';
import 'package:zoyo_bathware/utilitis/invoice_widgets/date_range_picker.dart';
import 'package:zoyo_bathware/utilitis/invoice_widgets/invoice_list.dart';
import 'package:zoyo_bathware/utilitis/invoice_widgets/search_field.dart';

class InvoicesScreen extends StatefulWidget {
  const InvoicesScreen({super.key});

  @override
  State<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends State<InvoicesScreen> {
  List<dynamic> invoices = [];
  List<dynamic> filteredInvoices = [];
  final TextEditingController searchController = TextEditingController();

  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    loadInvoices();
    searchController.addListener(_filterInvoices);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadInvoices() async {
    var invoiceBox = await Hive.openBox('invoices');
    setState(() {
      invoices = invoiceBox.values.toList()
        ..sort((a, b) =>
            DateTime.parse(b['date']).compareTo(DateTime.parse(a['date'])));
      _applyFilters();
    });
  }

  void _filterInvoices() {
    _applyFilters();
  }

  void _applyFilters() {
    final query = searchController.text.toLowerCase();

    List<dynamic> temp = invoices.where((invoice) {
      final phone = (invoice['phoneNumber'] ?? '').toLowerCase();
      return phone.contains(query);
    }).toList();

    if (startDate != null && endDate != null) {
      temp = temp.where((invoice) {
        try {
          final invoiceDate = DateTime.parse(invoice['date']);
          final isSameDay = startDate!.year == endDate!.year &&
              startDate!.month == endDate!.month &&
              startDate!.day == endDate!.day;

          if (isSameDay) {
            final now = DateTime.now();
            return invoiceDate.year == now.year &&
                invoiceDate.month == now.month &&
                invoiceDate.day == now.day;
          } else {
            return invoiceDate
                    .isAfter(startDate!.subtract(const Duration(days: 1))) &&
                invoiceDate.isBefore(endDate!.add(const Duration(days: 1)));
          }
        } catch (e) {
          return false;
        }
      }).toList();
    }

    setState(() {
      filteredInvoices = temp;
    });
  }

  double get totalSalesForSelectedDateRange {
    double sum = 0;
    for (var invoice in filteredInvoices) {
      sum += (invoice['total'] is int || invoice['total'] is double)
          ? invoice['total']
          : double.tryParse(invoice['total'].toString()) ?? 0;
    }
    return sum;
  }

  Future<void> _pickStartDate() async {
    DateTime now = DateTime.now();
    final DateTime? datePicked = await showDatePicker(
      context: context,
      initialDate: startDate ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 1),
    );
    if (datePicked != null) {
      setState(() {
        startDate = datePicked;
      });
      _applyFilters();
    }
  }

  Future<void> _pickEndDate() async {
    DateTime now = DateTime.now();
    final DateTime? datePicked = await showDatePicker(
      context: context,
      initialDate: endDate ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 1),
    );
    if (datePicked != null) {
      setState(() {
        endDate = datePicked;
      });
      _applyFilters();
    }
  }

  void _clearDateFilter() {
    setState(() {
      startDate = null;
      endDate = null;
    });
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    final String dateRangeText =
        startDate != null && endDate != null ? 'Selected' : 'All Dates';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text('Invoices'),
        actions: [
          if (startDate != null || endDate != null)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _clearDateFilter,
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Date Range: $dateRangeText',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  'Total Sales: ₹${totalSalesForSelectedDateRange.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          DateRangePicker(
            startDate: startDate,
            endDate: endDate,
            onPickStartDate: _pickStartDate,
            onPickEndDate: _pickEndDate,
          ),
          SearchField(controller: searchController),
          InvoiceList(
            invoices: filteredInvoices,
            onTap: (invoice) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InvoiceDetailScreen(invoice: invoice),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
