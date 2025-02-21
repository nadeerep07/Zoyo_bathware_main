import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

class InvoiceDetailScreen extends StatelessWidget {
  final Map invoice;
  const InvoiceDetailScreen({super.key, required this.invoice});

  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      return DateFormat('yyyy-MM-dd – kk:mm').format(date);
    } catch (e) {
      return isoDate;
    }
  }

  /// Build a PDF document from the invoice data.
  Future<pw.Document> _buildPdf() async {
    final pdf = pw.Document();
    final billNumber = invoice['billNumber'] ?? 'N/A';
    final customerName = invoice['customerName'] ?? '';
    final phoneNumber = invoice['phoneNumber'] ?? '';
    final date = invoice['date'] ?? '';
    final subtotal = invoice['subtotal'] ?? 0;
    final discount = invoice['discount'] ?? 0;
    final total = invoice['total'] ?? 0;
    final items = invoice['items'] as List<dynamic>? ?? [];

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Invoice Details',
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text('Bill Number: $billNumber'),
              pw.Text('Customer: $customerName'),
              pw.Text('Phone: $phoneNumber'),
              pw.Text('Date: ${_formatDate(date)}'),
              pw.SizedBox(height: 20),
              pw.Text('Purchased Items:',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Table.fromTextArray(
                headers: ['S.No', 'Product', 'Rate', 'Qty', 'Total'],
                data: List<List<String>>.generate(items.length, (index) {
                  final item = items[index];
                  return [
                    '${index + 1}',
                    item['productName'] ?? '',
                    '₹${item['rate']}',
                    '${item['quantity']}',
                    '${item['total']}',
                  ];
                }),
              ),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Subtotal: $subtotal'),
                      pw.Text('Discount: $discount'),
                      pw.Text('Total: $total',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ],
                  )
                ],
              ),
            ],
          );
        },
      ),
    );
    return pdf;
  }

  Future<void> _printInvoice() async {
    final pdf = await _buildPdf();
    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    final billNumber = invoice['billNumber'] ?? 'N/A';
    final customerName = invoice['customerName'] ?? '';
    final phoneNumber = invoice['phoneNumber'] ?? '';
    final date = invoice['date'] ?? '';
    final subtotal = invoice['subtotal'] ?? 0;
    final discount = invoice['discount'] ?? 0;
    final total = invoice['total'] ?? 0;
    final items = invoice['items'] as List<dynamic>? ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice $billNumber Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: _printInvoice,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Header details
            ListTile(
              title: const Text('Bill Number'),
              subtitle: Text(billNumber.toString()),
            ),
            ListTile(
              title: const Text('Customer Name'),
              subtitle: Text(customerName),
            ),
            ListTile(
              title: const Text('Phone Number'),
              subtitle: Text(phoneNumber),
            ),
            ListTile(
              title: const Text('Date'),
              subtitle: Text(_formatDate(date)),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const Text(
              'Purchased Items',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            // Items List
            ...items.map((item) {
              return ListTile(
                title: Text(item['productName'] ?? ''),
                subtitle:
                    Text('Rate: ₹${item['rate']}   Qty: ${item['quantity']}'),
                trailing: Text('₹${item['total']}'),
              );
            }).toList(),
            const Divider(),
            // Totals
            ListTile(
              title: const Text('Subtotal'),
              trailing: Text('₹$subtotal'),
            ),
            ListTile(
              title: const Text('Discount'),
              trailing: Text('₹$discount'),
            ),
            ListTile(
              title: const Text(
                'Total',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                '₹$total',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
