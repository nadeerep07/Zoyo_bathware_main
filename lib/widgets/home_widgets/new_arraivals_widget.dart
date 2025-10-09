import 'package:flutter/material.dart';
import 'package:zoyo_bathware/core/models/product_model.dart';
import 'package:zoyo_bathware/widgets/home_widgets/new_widget_header.dart';
import 'package:zoyo_bathware/widgets/home_widgets/product_grid.dart';
import 'package:zoyo_bathware/widgets/responsive.dart';


class NewArrivalsWidget extends StatelessWidget {
  final ValueNotifier<List<Product>> productsNotifier;

  const NewArrivalsWidget({super.key, required this.productsNotifier});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NewArrivalsHeader(responsive: responsive),
          ProductGrid(productsNotifier: productsNotifier, responsive: responsive),
        ],
      ),
    );
  }
}
