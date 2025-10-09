import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InvoiceList extends StatelessWidget {
  final List<dynamic> invoices;
  final Function(Map) onTap;

  const InvoiceList({super.key, required this.invoices, required this.onTap});

  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      return DateFormat('dd-MMM-yyyy').format(date);
    } catch (e) {
      return isoDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: invoices.isEmpty
          ? const Center(child: Text('No invoices found'))
          : ListView.separated(
              itemCount: invoices.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final invoice = invoices[index] as Map;
                final customerName = invoice['customerName'] ?? '';
                final phoneNumber = invoice['phoneNumber'] ?? '';
                final date = invoice['date'] ?? '';
                final total = invoice['total'] ?? 0;

                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  onTap: () => onTap(invoice),
                );
              },
            ),
    );
  }
}
