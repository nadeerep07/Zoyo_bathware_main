import 'package:flutter/material.dart';

class detail_row extends StatelessWidget {
  const detail_row({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
          Text(value,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
