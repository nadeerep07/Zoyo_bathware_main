// cabinet_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zoyo_bathware/constants/app_colors.dart';
import 'package:zoyo_bathware/features/cabinet_screen/viewmodel/cabinet_viewmodel.dart';
import 'package:zoyo_bathware/widgets/product/product_card.dart';
import 'package:zoyo_bathware/widgets/custom_widgets/back_botton.dart';
import 'package:zoyo_bathware/widgets/responsive.dart';

class CabinetScreen extends StatelessWidget {
  const CabinetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    return ChangeNotifierProvider(
      create: (_) => CabinetViewModel(),
      child: Consumer<CabinetViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.primaryColor,
              automaticallyImplyLeading: false,
              title: Text(
                'Cabinets',
                style: TextStyle(fontSize: res.sp(18)),
              ),
              actions: [
                ValueListenableBuilder<bool>(
                  valueListenable: viewModel.isGridView,
                  builder: (context, isGrid, _) {
                    return IconButton(
                      icon: Icon(
                        isGrid ? Icons.view_list : Icons.grid_view,
                        size: res.sp(20),
                      ),
                      onPressed: viewModel.toggleView,
                    );
                  },
                ),
              ],
            ),
            body: Padding(
              padding: EdgeInsets.all(res.wp(4)),
              child: viewModel.filteredProducts.isEmpty
                  ? Center(
                      child: Text(
                        "No products found in this category",
                        style: TextStyle(
                          fontSize: res.sp(14),
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : ValueListenableBuilder<bool>(
                      valueListenable: viewModel.isGridView,
                      builder: (context, isGrid, _) {
                        return isGrid
                            ? GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: res.width > 600 ? 3 : 2,
                                  crossAxisSpacing: res.wp(2.5),
                                  mainAxisSpacing: res.hp(1.5),
                                  childAspectRatio:
                                      res.width > 600 ? 0.4 : 0.64,
                                ),
                                itemCount: viewModel.filteredProducts.length,
                                itemBuilder: (context, index) {
                                  return ProductCard(
                                    product: viewModel.filteredProducts[index],
                                    isGridView: true,
                                  );
                                },
                              )
                            : ListView.builder(
                                itemCount: viewModel.filteredProducts.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding:
                                        EdgeInsets.only(bottom: res.hp(1.2)),
                                    child: ProductCard(
                                      product:
                                          viewModel.filteredProducts[index],
                                      isGridView: false,
                                    ),
                                  );
                                },
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
