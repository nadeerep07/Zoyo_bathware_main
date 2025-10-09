import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:zoyo_bathware/constants/app_colors.dart';
import 'package:zoyo_bathware/features/all_categories/view/screens/all_categories_screen.dart';
import '../responsive.dart';

class NewArrivalsHeader extends StatelessWidget {
  final Responsive responsive;

  const NewArrivalsHeader({super.key, required this.responsive});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'New Arrivals',
                  style: TextStyle(
                    fontSize: kIsWeb ? 24 : responsive.sp(20),
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Latest products from our collection',
                  style: TextStyle(
                    fontSize: kIsWeb ? 16 : responsive.sp(14),
                    color: const Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          _viewAllButton(context),
        ],
      ),
    );
  }

  Widget _viewAllButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withValues(alpha:0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AllCategoriesScreen()),
        ),
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: kIsWeb ? 20 : responsive.wp(4),
            vertical: kIsWeb ? 12 : responsive.hp(1.2),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'View All',
              style: TextStyle(
                color: Colors.white,
                fontSize: kIsWeb ? 16 : responsive.sp(14),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
              size: kIsWeb ? 18 : responsive.sp(16),
            ),
          ],
        ),
      ),
    );
  }
}
