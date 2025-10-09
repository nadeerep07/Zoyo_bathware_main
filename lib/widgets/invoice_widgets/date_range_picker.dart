import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateRangePicker extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final Function() onPickStartDate;
  final Function() onPickEndDate;

  const DateRangePicker({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onPickStartDate,
    required this.onPickEndDate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onPickStartDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Start Date',
                  border: OutlineInputBorder(),
                ),
                child: Text(
                  startDate != null
                      ? DateFormat('dd-MMM-yyyy').format(startDate!)
                      : 'Select Start Date',
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: InkWell(
              onTap: onPickEndDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'End Date',
                  border: OutlineInputBorder(),
                ),
                child: Text(
                  endDate != null
                      ? DateFormat('dd-MMM-yyyy').format(endDate!)
                      : 'Select End Date',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
