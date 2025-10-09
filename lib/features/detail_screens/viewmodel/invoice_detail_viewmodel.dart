// invoice_detail_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class InvoiceDetailViewModel extends ChangeNotifier {
  final Map invoice;

  InvoiceDetailViewModel({required this.invoice});

  String get billNumber => invoice['billNumber']?.toString() ?? 'N/A';
  String get customerName => invoice['customerName'] ?? '';
  String get phoneNumber => invoice['phoneNumber'] ?? '';
  String get date => invoice['date'] ?? '';
  double get subtotal => invoice['subtotal']?.toDouble() ?? 0;
  double get discount => invoice['discount']?.toDouble() ?? 0;
  double get total => invoice['total']?.toDouble() ?? 0;
  List<dynamic> get items => invoice['items'] as List<dynamic>? ?? [];

  String formatDate(String isoDate) {
    try {
      final parsedDate = DateTime.parse(isoDate);
      return DateFormat('yyyy-MM-dd – kk:mm').format(parsedDate);
    } catch (e) {
      return isoDate;
    }
  }

  /// Build PDF document
  Future<pw.Document> buildPdf() async {
    final pdf = pw.Document();
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
              pw.Text('Date: ${formatDate(date)}'),
              pw.SizedBox(height: 20),
              pw.Text('Purchased Items:',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Table.fromTextArray(
                headers: ['S.No', 'Product', 'Rate', 'Qty', 'Total'],
                data: List.generate(items.length, (index) {
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
                      pw.Text('Subtotal: ₹$subtotal'),
                      pw.Text('Discount: ₹$discount'),
                      pw.Text('Total: ₹$total',
                          style:
                              pw.TextStyle(fontWeight: pw.FontWeight.bold)),
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

  /// Print PDF
  Future<void> printInvoice() async {
    final pdf = await buildPdf();
    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }
}
