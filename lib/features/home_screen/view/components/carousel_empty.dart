// carousel_empty_widget.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zoyo_bathware/widgets/responsive.dart';

class CarouselEmptyWidget extends StatelessWidget {
  const CarouselEmptyWidget({super.key,});

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    return Container(
      height: kIsWeb ? 200 : res.hp(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey.shade100,
            Colors.grey.shade50,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_outlined,
              size: kIsWeb ? 48 : res.wp(12),
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            Text(
              'No images added yet',
              style: TextStyle(
                fontSize: kIsWeb ? 18 : res.sp(16),
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
