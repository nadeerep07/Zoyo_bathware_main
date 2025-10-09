import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zoyo_bathware/core/models/product_model.dart';
import 'package:zoyo_bathware/widgets/home_widgets/new_product_card.dart';
import '../responsive.dart';

class ProductGrid extends StatelessWidget {
  final ValueNotifier<List<Product>> productsNotifier;
  final Responsive responsive;

  const ProductGrid({super.key, required this.productsNotifier, required this.responsive});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Product>>(
      valueListenable: productsNotifier,
      builder: (context, products, child) {
        if (products.isEmpty) return _emptyState();

        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: kIsWeb ? 3 : 2,
              crossAxisSpacing: kIsWeb ? 20 : 12,
              mainAxisSpacing: kIsWeb ? 20 : 12,
              childAspectRatio: kIsWeb ? 0.85 : 0.75,
            ),
            itemCount: products.length > 6 ? 6 : products.length,
            itemBuilder: (context, index) => ProductCard(product: products[index], responsive: responsive),
          ),
        );
      },
    );
  }

  Widget _emptyState() {
    return Container(
      height: responsive.hp(25),
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
              child: Icon(Icons.shopping_bag_outlined, size: kIsWeb ? 48 : responsive.wp(12), color: Colors.grey.shade400),
            ),
            SizedBox(height: responsive.hp(2)),
            Text('No products found', style: TextStyle(fontSize: kIsWeb ? 18 : responsive.sp(16), color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
            SizedBox(height: responsive.hp(0.5)),
            Text('Check back later for new arrivals', style: TextStyle(fontSize: kIsWeb ? 14 : responsive.sp(12), color: Colors.grey.shade500)),
          ],
        ),
      ),
    );
  }
}
