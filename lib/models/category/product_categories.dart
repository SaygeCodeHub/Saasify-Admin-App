import 'package:hive/hive.dart';

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

  ProductCategories({required this.name, this.imagePath, this.categoryId = ''});

  Map<String, dynamic> toMap() {
    return {'name': name, 'image_path': imagePath, 'category_id': categoryId};
  }
}
