import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zoyo_bathware/constants/app_colors.dart';
import 'package:zoyo_bathware/features/detail_screens/view/screens/invoice_detail_screen.dart';
import 'package:zoyo_bathware/features/sales_history/viewmodel/invoice_viewmodel.dart';
import 'package:zoyo_bathware/widgets/invoice_widgets/date_range_picker.dart';
import 'package:zoyo_bathware/widgets/invoice_widgets/invoice_list.dart';
import 'package:zoyo_bathware/widgets/invoice_widgets/search_field.dart';

class InvoicesScreen extends StatelessWidget {
  const InvoicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => InvoicesViewModel(),
      child: Consumer<InvoicesViewModel>(
        builder: (context, vm, child) {
          final dateRangeText =
              vm.startDate != null && vm.endDate != null ? 'Selected' : 'All Dates';

          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.primaryColor,
              title: const Text('Invoices'),
              actions: [
                if (vm.startDate != null || vm.endDate != null)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: vm.clearDateFilter,
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
                        'Total Sales: ₹${vm.totalSalesForSelectedDateRange.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                DateRangePicker(
                  startDate: vm.startDate,
                  endDate: vm.endDate,
                  onPickStartDate: () => vm.pickStartDate(context),
                  onPickEndDate: () => vm.pickEndDate(context),
                ),
                SearchField(controller: vm.searchController),
                Expanded(
                  child: InvoiceList(
                    invoices: vm.filteredInvoices,
                    onTap: (invoice) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InvoiceDetailScreen(invoice: invoice),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
