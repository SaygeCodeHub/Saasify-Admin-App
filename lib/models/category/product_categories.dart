import 'package:hive/hive.dart';
import 'package:saasify/models/product/products.dart';

import '../../configs/hive_type_ids.dart';

part 'product_categories.g.dart';

@HiveType(typeId: HiveTypeIds.productCategories)
class ProductCategories {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String? imagePath;

  @HiveField(2)
  final String? categoryId;

  List<Products> products;

  ProductCategories(
      {required this.name,
      this.imagePath,
      this.categoryId = '',
      required this.products});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image_path': imagePath,
      'category_id': categoryId,
      'products': products
    };
  }
}
