// category_to_all_product_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import 'package:zoyo_bathware/core/models/category_model.dart';
import 'package:zoyo_bathware/features/detail_screens/viewmodel/category_product_viewmodel.dart';
import 'package:zoyo_bathware/widgets/product/product_card.dart';
import 'package:zoyo_bathware/widgets/custom_widgets/back_botton.dart';

class CategoryToAllProduct extends StatelessWidget {
  final ProductCategory category;

  const CategoryToAllProduct({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CategoryProductViewModel(categoryName: category.name),
      child: Consumer<CategoryProductViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            appBar: AppBar(
              leading: backButton(context),
              title: Text(category.name),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: Icon(vm.isGridView ? Icons.view_list : Icons.grid_view),
                  onPressed: vm.toggleView,
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: vm.products.isEmpty
                  ? const Center(
                      child: Text(
                        "No products found in this category",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : vm.isGridView
                      ? GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: kIsWeb ? 6 : 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.64,
                          ),
                          itemCount: vm.products.length,
                          itemBuilder: (context, index) {
                            return ProductCard(
                              product: vm.products[index],
                              isGridView: true,
                            );
                          },
                        )
                      : ListView.builder(
                          itemCount: vm.products.length,
                          itemBuilder: (context, index) {
                            return ProductCard(
                              product: vm.products[index],
                              isGridView: false,
                            );
                          },
                        ),
            ),
          );
        },
      ),
    );
  }
}
