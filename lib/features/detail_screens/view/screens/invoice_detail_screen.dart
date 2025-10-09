// invoice_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zoyo_bathware/features/detail_screens/viewmodel/invoice_detail_viewmodel.dart';

class InvoiceDetailScreen extends StatelessWidget {
  final Map invoice;

  const InvoiceDetailScreen({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => InvoiceDetailViewModel(invoice: invoice),
      child: Consumer<InvoiceDetailViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Invoice ${vm.billNumber} Details'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.print),
                  onPressed: vm.printInvoice,
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  _buildListTile('Bill Number', vm.billNumber),
                  _buildListTile('Customer Name', vm.customerName),
                  _buildListTile('Phone Number', vm.phoneNumber),
                  _buildListTile('Date', vm.formatDate(vm.date)),
                  const Divider(),
                  const Text(
                    'Purchased Items',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  ...vm.items.map((item) => ListTile(
                        title: Text(item['productName'] ?? ''),
                        subtitle: Text(
                            'Rate: ₹${item['rate']}   Qty: ${item['quantity']}'),
                        trailing: Text('₹${item['total']}'),
                      )),
                  const Divider(),
                  _buildListTile('Subtotal', '₹${vm.subtotal}'),
                  _buildListTile('Discount', '₹${vm.discount}'),
                  _buildListTile(
                    'Total',
                    '₹${vm.total}',
                    valueStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildListTile(String title, String value,
      {TextStyle? valueStyle}) {
    return ListTile(
      title: Text(title),
      trailing: Text(
        value,
        style: valueStyle ?? const TextStyle(fontWeight: FontWeight.normal),
      ),
    );
  }
}
