import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:zoyo_bathware/database/category_model.dart';
import 'package:zoyo_bathware/database/product_model.dart';

class PrivacySecurityScreen extends StatelessWidget {
  const PrivacySecurityScreen({super.key});

  Future<void> _clearCacheAndData(BuildContext context) async {
    await Hive.deleteFromDisk(); // Clears Hive Database
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cache and data cleared')),
    );
  }

  Future<void> _backupData(BuildContext context) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final backupDir = Directory('${appDir.path}/backup');
      if (!backupDir.existsSync()) {
        backupDir.createSync(recursive: true);
      }
      final backupFile = File('${backupDir.path}/hive_backup.hive');

      final box = await Hive.openBox('products');
      final boxData = box.toMap();

      backupFile.writeAsStringSync(boxData.toString());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Backup completed successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Backup failed: $e')),
      );
    }
  }

  Future<void> _backupDataToPdf(BuildContext context) async {
    try {
      final pdf = pw.Document();

      final header = pw.Header(
        level: 0,
        child: pw.Text('Zoyo Data Backup',
            style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
      );

      final productsBox = await Hive.openBox<Product>('products');
      final productsData = productsBox.toMap();
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                header,
                pw.SizedBox(height: 20),
                pw.Text("Products",
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Table.fromTextArray(
                  context: context,
                  border: pw.TableBorder.all(),
                  headers: [
                    'Code',
                    'Name',
                    'Qty',
                    'Purchase Rate',
                    'Sales Rate'
                  ],
                  data: productsData.entries.map((entry) {
                    final product = entry.value;
                    return [
                      product.productCode,
                      product.productName,
                      product.quantity,
                      '\$${product.purchaseRate.toStringAsFixed(2)}',
                      '\$${product.salesRate.toStringAsFixed(2)}',
                    ];
                  }).toList(),
                ),
              ],
            );
          },
        ),
      );

      final categoriesBox = await Hive.openBox<Category>('categories');
      final categoriesData = categoriesBox.toMap();
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                header,
                pw.SizedBox(height: 20),
                pw.Text("Categories",
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Table.fromTextArray(
                  context: context,
                  border: pw.TableBorder.all(),
                  headers: ['ID', 'Name'],
                  data: categoriesData.entries.map((entry) {
                    final category = entry.value;
                    return [
                      entry.key.toString(),
                      category.name,
                    ];
                  }).toList(),
                ),
              ],
            );
          },
        ),
      );

      final outputDir = await getApplicationDocumentsDirectory();
      final file = File('${outputDir.path}/hive_backup.pdf');
      await file.writeAsBytes(await pdf.save());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PDF backup created successfully')),
      );

      await Printing.sharePdf(
          bytes: await pdf.save(), filename: 'hive_backup.pdf');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF backup failed: $e')),
      );
    }
  }

  Future<void> _restoreData(BuildContext context) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final backupFile = File('${appDir.path}/backup/hive_backup.hive');

      if (!backupFile.existsSync()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No backup file found!')),
        );
        return;
      }

      final box = await Hive.openBox('products'); // Replace with your box name
      backupFile.readAsStringSync();

      box.clear(); // Clear existing data before restoring
      final Map<String, dynamic> parsedData =
          Map<String, dynamic>.from(box.toMap());

      for (var key in parsedData.keys) {
        box.put(key, parsedData[key]);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data restored successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Restore failed: $e')),
      );
    }
  }

  void _backupAndRestoreData(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.backup),
                title: const Text('Backup Data'),
                onTap: () {
                  Navigator.pop(context);
                  _backupData(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.picture_as_pdf),
                title: const Text('Backup to PDF'),
                onTap: () {
                  Navigator.pop(context);
                  _backupDataToPdf(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.restore),
                title: const Text('Restore Data'),
                onTap: () {
                  Navigator.pop(context);
                  _restoreData(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy & Security')),
      body: ListView(
        children: [
          ListTile(
              title: Text('Privacy Settings'), tileColor: Colors.grey[200]),
          ListTile(
            leading: const Icon(Icons.cloud_upload),
            title: const Text('Backup & Restore'),
            subtitle: const Text('Backup your data and restore if needed'),
            onTap: () => _backupAndRestoreData(context),
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Clear Cache & Data'),
            subtitle: const Text('Free up storage space'),
            onTap: () => _clearCacheAndData(context),
          ),
          const Divider(),
          ListTile(
              title: Text('Security Settings'), tileColor: Colors.grey[200]),
        ],
      ),
    );
  }
}
