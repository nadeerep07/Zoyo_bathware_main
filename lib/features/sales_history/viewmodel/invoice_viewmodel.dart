import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class InvoicesViewModel extends ChangeNotifier {
  List<dynamic> _invoices = [];
  List<dynamic> _filteredInvoices = [];
  DateTime? _startDate;
  DateTime? _endDate;
  final TextEditingController searchController = TextEditingController();

  List<dynamic> get filteredInvoices => _filteredInvoices;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;

  double get totalSalesForSelectedDateRange {
    double sum = 0;
    for (var invoice in _filteredInvoices) {
      sum += (invoice['total'] is int || invoice['total'] is double)
          ? invoice['total']
          : double.tryParse(invoice['total'].toString()) ?? 0;
    }
    return sum;
  }

  InvoicesViewModel() {
    loadInvoices();
    searchController.addListener(_applyFilters);
  }

  Future<void> loadInvoices() async {
    var invoiceBox = await Hive.openBox('invoices');
    _invoices = invoiceBox.values.toList()
      ..sort((a, b) =>
          DateTime.parse(b['date']).compareTo(DateTime.parse(a['date'])));
    _applyFilters();
  }

  void pickStartDate(BuildContext context) async {
    DateTime now = DateTime.now();
    final DateTime? datePicked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 1),
    );
    if (datePicked != null) {
      _startDate = datePicked;
      _applyFilters();
    }
  }

  void pickEndDate(BuildContext context) async {
    DateTime now = DateTime.now();
    final DateTime? datePicked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 1),
    );
    if (datePicked != null) {
      _endDate = datePicked;
      _applyFilters();
    }
  }

  void clearDateFilter() {
    _startDate = null;
    _endDate = null;
    _applyFilters();
  }

  void _applyFilters() {
    final query = searchController.text.toLowerCase();

    List<dynamic> temp = _invoices.where((invoice) {
      final phone = (invoice['phoneNumber'] ?? '').toLowerCase();
      return phone.contains(query);
    }).toList();

    if (_startDate != null && _endDate != null) {
      temp = temp.where((invoice) {
        try {
          final invoiceDate = DateTime.parse(invoice['date']);
          final isSameDay = _startDate!.year == _endDate!.year &&
              _startDate!.month == _endDate!.month &&
              _startDate!.day == _endDate!.day;

          if (isSameDay) {
            final now = DateTime.now();
            return invoiceDate.year == now.year &&
                invoiceDate.month == now.month &&
                invoiceDate.day == now.day;
          } else {
            return invoiceDate
                    .isAfter(_startDate!.subtract(const Duration(days: 1))) &&
                invoiceDate.isBefore(_endDate!.add(const Duration(days: 1)));
          }
        } catch (e) {
          return false;
        }
      }).toList();
    }

    _filteredInvoices = temp;
    notifyListeners();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
