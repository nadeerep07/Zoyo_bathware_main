import 'dart:io';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:zoyo_bathware/database/product_model.dart';

/// Generates a PDF invoice using the provided details and returns the formatted bill number.
Future<void> generateInvoicePdf({
  required int billNumber,
  required String customerName,
  required String phone,
  required double totalAmount,
  required double discount,
  required List<Product> cartProducts,
}) async {
  final pdf = pw.Document();
  final formattedBillNumber = billNumber.toString().padLeft(4, '0');

  // Define a custom header style
  final headerStyle = pw.TextStyle(
    fontSize: 22,
    fontWeight: pw.FontWeight.bold,
    color: PdfColors.white,
  );

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4.applyMargin(
        left: 32,
        top: 32,
        right: 32,
        bottom: 32,
      ),
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            // Header with a background color
            pw.Container(
              padding: const pw.EdgeInsets.all(16),
              color: PdfColors.blue,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("Invoice", style: headerStyle),
                  pw.SizedBox(height: 4),
                  pw.Text("Bill No: $formattedBillNumber",
                      style:
                          pw.TextStyle(fontSize: 16, color: PdfColors.white)),
                  pw.Text(
                      "Date: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}",
                      style:
                          pw.TextStyle(fontSize: 16, color: PdfColors.white)),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
            // Customer details
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("Customer: $customerName",
                    style: pw.TextStyle(fontSize: 14)),
                pw.Text("Phone: $phone", style: pw.TextStyle(fontSize: 14)),
              ],
            ),
            pw.SizedBox(height: 20),
            // Items Table
            pw.Table.fromTextArray(
              headerStyle: pw.TextStyle(
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
              ),
              cellStyle: pw.TextStyle(fontSize: 12),
              headers: ["S.No", "Product", "Rate", "Qty", "Total"],
              data: List<List<String>>.generate(
                cartProducts.length,
                (index) {
                  final product = cartProducts[index];
                  return [
                    "${index + 1}",
                    product.productName,
                    "${product.salesRate}",
                    "${product.quantity}",
                    "${(product.salesRate * product.quantity).toStringAsFixed(2)}",
                  ];
                },
              ),
              border: pw.TableBorder.all(
                color: PdfColors.grey,
                width: 0.5,
              ),
              cellAlignment: pw.Alignment.centerLeft,
            ),
            pw.SizedBox(height: 20),
            // Totals
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("Subtotal: ${totalAmount.toStringAsFixed(2)}",
                        style: pw.TextStyle(fontSize: 14)),
                    pw.Text("Discount: ${discount.toStringAsFixed(2)}",
                        style: pw.TextStyle(fontSize: 14)),
                    pw.Text(
                        "Total: ${(totalAmount - discount).toStringAsFixed(2)}",
                        style: pw.TextStyle(
                            fontSize: 16, fontWeight: pw.FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    ),
  );

  final output = await getApplicationDocumentsDirectory();
  final file = File("${output.path}/invoice_$formattedBillNumber.pdf");
  await file.writeAsBytes(await pdf.save());
  OpenFile.open(file.path);
}
