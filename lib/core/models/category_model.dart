import 'package:hive/hive.dart';

part 'category_model.g.dart';

@HiveType(typeId: 1)
class ProductCategory {
  @HiveField(0)
  String name;

  @HiveField(1)
  String imagePath;

  @HiveField(2)
  String id;

  ProductCategory({required this.name, required this.imagePath, required this.id});
}
