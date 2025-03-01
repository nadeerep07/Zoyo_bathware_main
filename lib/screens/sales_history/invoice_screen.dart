import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:zoyo_bathware/screens/detail_screens/invoice_detail_screen.dart';
import 'package:zoyo_bathware/services/app_colors.dart';

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
      // Sort invoices by date in descending order (newest first)
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
            // If both dates are the same, check if the invoice date is today
            final now = DateTime.now();
            return invoiceDate.year == now.year &&
                invoiceDate.month == now.month &&
                invoiceDate.day == now.day;
          } else {
            // Otherwise, apply the date range filter
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

  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      return DateFormat('dd-MMM-yyyy').format(date);
    } catch (e) {
      return isoDate;
    }
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
          // Date range filter and total sales display
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
          // Start Date and End Date Pickers
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _pickStartDate,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Start Date',
                        border: OutlineInputBorder(),
                      ),
                      child: Text(
                        startDate != null
                            ? DateFormat('dd-MMM-yyyy').format(startDate!)
                            : 'Select Start Date',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    onTap: _pickEndDate,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'End Date',
                        border: OutlineInputBorder(),
                      ),
                      child: Text(
                        endDate != null
                            ? DateFormat('dd-MMM-yyyy').format(endDate!)
                            : 'Select End Date',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Search Field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Search by Phone Number',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          // Invoices List
          Expanded(
            child: filteredInvoices.isEmpty
                ? const Center(child: Text('No invoices found'))
                : ListView.separated(
                    itemCount: filteredInvoices.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final invoice = filteredInvoices[index] as Map;
                      final customerName = invoice['customerName'] ?? '';
                      final phoneNumber = invoice['phoneNumber'] ?? '';
                      final date = invoice['date'] ?? '';
                      final total = invoice['total'] ?? 0;

                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        leading: CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          child: Text('${index + 1}'),
                        ),
                        title: Text('Customer: $customerName'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Phone: $phoneNumber'),
                            Text('Date: ${_formatDate(date)}'),
                          ],
                        ),
                        trailing: Text('₹$total',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  InvoiceDetailScreen(invoice: invoice),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
