import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomerDetailsCard extends StatelessWidget {
  final String billNumber;
  final TextEditingController customerNameController;
  final TextEditingController phoneController;

  const CustomerDetailsCard({
    required this.billNumber,
    required this.customerNameController,
    required this.phoneController,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Bill No: $billNumber",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                Text(
                    "Date: ${DateFormat('dd-MMM-yyyy').format(DateTime.now())}",
                    style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: customerNameController,
              decoration: const InputDecoration(
                  labelText: "Customer Name", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                  labelText: "Phone Number", border: OutlineInputBorder()),
            ),
          ],
        ),
      ),
    );
  }
}
