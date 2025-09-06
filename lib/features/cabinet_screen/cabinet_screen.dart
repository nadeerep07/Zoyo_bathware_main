import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:zoyo_bathware/database/category_model.dart';
import 'package:zoyo_bathware/database/data_operations/category_db.dart';
import 'package:zoyo_bathware/database/product_model.dart';
import 'package:zoyo_bathware/services/app_colors.dart';
import 'package:zoyo_bathware/utilitis/product_card.dart';
import 'package:zoyo_bathware/utilitis/custom_widgets/back_botton.dart';


class CabinetScreen extends StatefulWidget {
  const CabinetScreen({super.key});

  @override
  State<CabinetScreen> createState() => _CabinetScreenState();
}

class _CabinetScreenState extends State<CabinetScreen> {
  List<Product> filteredProducts = [];
  ValueNotifier<bool> isGridView = ValueNotifier<bool>(true);

  late Box<Category> _categoryBox;
  late Box<Product> _productBox;

  @override
  void initState() {
    super.initState();
    openHiveBoxes().then((_) {
      loadCabinetProducts();
    });
  }

  Future<void> openHiveBoxes() async {
    _categoryBox = await Hive.openBox<Category>(categoryBox);
    _productBox = await Hive.openBox<Product>('products');
  }

  void loadCabinetProducts() {
    final allProducts = _productBox.values.toList();

    final cabinetCategory = _categoryBox.values.firstWhere(
      (category) => category.name.toLowerCase().trim() == 'cabinet',
    );

    filteredProducts = allProducts.where((product) {
      return product.category.toString().trim() ==
          cabinetCategory.name.toString().trim();
    }).toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        leading: backButton(context),
        title: Text(
          'Cabinets',
          style: TextStyle(fontSize: res.sp(18)),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.view_list, size: res.sp(20)),
            onPressed: () {
              isGridView.value = !isGridView.value;
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(res.wp(4)), // responsive padding
        child: filteredProducts.isEmpty
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
                valueListenable: isGridView,
                builder: (context, isGrid, _) {
                  return isGrid
                      ? GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                res.width > 600 ? 3 : 2, // tablets get 3
                            crossAxisSpacing: res.wp(2.5),
                            mainAxisSpacing: res.hp(1.5),
                            childAspectRatio: res.width > 600 ? 0.7 : 0.54,
                          ),
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            return ProductCard(
                              product: filteredProducts[index],
                              isGridView: true,
                            );
                          },
                        )
                      : ListView.builder(
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: res.hp(1.2)),
                              child: ProductCard(
                                product: filteredProducts[index],
                                isGridView: false,
                              ),
                            );
                          },
                        );
                },
              ),
      ),
    );
  }
}
