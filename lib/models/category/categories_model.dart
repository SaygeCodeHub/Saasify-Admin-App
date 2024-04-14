import 'package:hive/hive.dart';
import 'package:saasify/models/product/products.dart';

import '../../configs/hive_type_ids.dart';

part 'categories_model.g.dart';

@HiveType(typeId: HiveTypeIds.categories)
class CategoriesModel {
  @HiveField(0)
  String? name;

  @HiveField(1)
  String? imagePath;

  @HiveField(2)
  String? categoryId;
  @HiveField(3)
  bool? isUploadedToServer;

  List<Products>? products;

  CategoriesModel(
      {this.name = '',
      this.imagePath,
      this.categoryId = '',
      this.products,
      this.isUploadedToServer = false});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image_path': imagePath,
      'category_id': categoryId,
      'products': products = [],
      'isUploadedToServer': isUploadedToServer
    };
  }

  factory CategoriesModel.fromMap(Map<dynamic, dynamic> map) {
    return CategoriesModel(
      categoryId: map['categoryId'] as String?,
      name: map['name'] as String?,
      imagePath: map['imagePath'] as String?,
    );
  }
}
