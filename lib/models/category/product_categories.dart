import 'package:hive/hive.dart';
import 'package:saasify/models/product/products.dart';

import '../../configs/hive_type_ids.dart';

part 'product_categories.g.dart';

@HiveType(typeId: HiveTypeIds.productCategories)
class ProductCategories {
  @HiveField(0)
  String? name;

  @HiveField(1)
  String? imagePath;

  @HiveField(2)
  String? categoryId;

  List<Products>? products;

  ProductCategories(
      {this.name = '', this.imagePath, this.categoryId = '', this.products});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image_path': imagePath,
      'category_id': categoryId,
      'products': products = []
    };
  }
}
