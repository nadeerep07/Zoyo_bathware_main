// welcome_section_widget.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zoyo_bathware/constants/app_colors.dart';
import 'package:zoyo_bathware/widgets/responsive.dart';

class WelcomeSectionWidget extends StatelessWidget {
  const WelcomeSectionWidget({super.key,});

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor.withOpacity(0.1),
            AppColors.secondaryColor.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primaryColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to ZOYO',
                  style: TextStyle(
                    fontSize: kIsWeb ? 24 : res.sp(20),
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Discover premium bathware collections',
                  style: TextStyle(
                    fontSize: kIsWeb ? 16 : res.sp(14),
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.bathroom_outlined,
              size: kIsWeb ? 32 : res.wp(8),
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
