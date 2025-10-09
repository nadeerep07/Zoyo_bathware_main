import 'package:flutter/material.dart';

class TotalAmountSummary extends StatelessWidget {
  final double totalAmount;
  final double discount;

  const TotalAmountSummary({
    required this.totalAmount,
    required this.discount,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSummaryRow("Total Amount", totalAmount.toStringAsFixed(2)),
            const SizedBox(height: 8),
            _buildSummaryRow("Discount", discount.toStringAsFixed(2)),
            const SizedBox(height: 8),
            _buildSummaryRow(
                "Grand Total", (totalAmount - discount).toStringAsFixed(2),
                isBold: true),
          ],
        ),
      ),
    );
  }

  Row _buildSummaryRow(String title, String amount, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: 16)),
        Text("₹$amount",
            style: TextStyle(
                fontSize: 16,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }
}
