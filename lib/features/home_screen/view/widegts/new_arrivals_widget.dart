// new_arrivals_widget.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zoyo_bathware/core/models/product_model.dart';
import 'package:zoyo_bathware/widgets/product/product_card.dart';
import 'package:zoyo_bathware/features/all_categories/view/screens/all_categories_screen.dart';
import 'package:zoyo_bathware/widgets/responsive.dart';

class NewArrivalsWidget extends StatelessWidget {
  final List<Product> products;
  const NewArrivalsWidget({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'New Arrivals',
                style: TextStyle(
                  fontSize: kIsWeb ? 24 : res.sp(20),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E293B),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AllCategoriesScreen()),
                  );
                },
                child: const Text("View All"),
              )
            ],
          ),
        ),

        // Grid
        products.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text('No products found'),
                ),
              )
            : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: kIsWeb ? 3 : 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemCount: products.length > 6 ? 6 : products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductCard(product: product, isGridView: true);
                },
              ),
      ],
    );
  }
}
