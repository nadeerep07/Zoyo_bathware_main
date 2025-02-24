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

  DateTime? selectedDate;

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
      invoices = invoiceBox.values.toList();
      _applyFilters();
    });
  }

  void _filterInvoices() {
    _applyFilters();
  }

  void _applyFilters() {
    final query = searchController.text.toLowerCase();
    // First filter by phone search
    List<dynamic> temp = invoices.where((invoice) {
      final phone = (invoice['phoneNumber'] ?? '').toLowerCase();
      return phone.contains(query);
    }).toList();

    // Then filter by selected date (if any)
    if (selectedDate != null) {
      final dateString = DateFormat('yyyy-MM-dd').format(selectedDate!);
      temp = temp.where((invoice) {
        // invoice['date'] assumed to be in ISO8601 format
        try {
          final invoiceDate =
              DateFormat('yyyy-MM-dd').format(DateTime.parse(invoice['date']));
          return invoiceDate == dateString;
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
      return DateFormat('yyyy-MM-dd').format(date);
    } catch (e) {
      return isoDate;
    }
  }

  double get totalSalesForSelectedDate {
    double sum = 0;
    for (var invoice in filteredInvoices) {
      sum += (invoice['total'] is int || invoice['total'] is double)
          ? invoice['total']
          : double.tryParse(invoice['total'].toString()) ?? 0;
    }
    return sum;
  }

  Future<void> _pickDate() async {
    DateTime now = DateTime.now();
    final DateTime? datePicked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 1),
    );
    if (datePicked != null) {
      setState(() {
        selectedDate = datePicked;
      });
      _applyFilters();
    }
  }

  void _clearDateFilter() {
    setState(() {
      selectedDate = null;
    });
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    final String dateFilterText = selectedDate != null
        ? DateFormat('yyyy-MM-dd').format(selectedDate!)
        : 'All Dates';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text('Invoices'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: _pickDate,
          ),
          if (selectedDate != null)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _clearDateFilter,
            ),
        ],
      ),
      body: Column(
        children: [
          // Date filter and total sales display
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Date: $dateFilterText',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  'Total Sales: ₹${totalSalesForSelectedDate.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
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
