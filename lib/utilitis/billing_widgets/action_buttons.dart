import 'package:flutter/material.dart';
import 'package:zoyo_bathware/services/app_colors.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onPurchase;

  const ActionButtons({
    required this.onCancel,
    required this.onPurchase,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onCancel,
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 16)),
            child: const Text('Cancel', style: TextStyle(fontSize: 16)),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: onPurchase,
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16)),
            child: const Text('Purchase', style: TextStyle(fontSize: 16)),
          ),
        ),
      ],
    );
  }
}
