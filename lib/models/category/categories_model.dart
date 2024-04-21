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
  @HiveField(4)
  List<Products>? products;
  @HiveField(5)
  String? serverImagePath;

  CategoriesModel({
    this.name = '',
    this.imagePath,
    this.categoryId = '',
    this.isUploadedToServer = false,
    this.products,
    this.serverImagePath = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imagePath': imagePath,
      'categoryId': categoryId,
      'isUploadedToServer': isUploadedToServer,
      'products': products = [],
      'serverImagePath': serverImagePath
    };
  }

  factory CategoriesModel.fromMap(Map<dynamic, dynamic> map) {
    return CategoriesModel(
        categoryId: map['categoryId'] as String?,
        name: map['name'] as String?,
        imagePath: map['imagePath'] as String?,
        isUploadedToServer: map['isUploadedToServer'] as bool?,
        products: [],
        serverImagePath: map['serverImagePath'] as String?);
  }

  @override
  String toString() {
    return 'CategoriesModel(name: $name, imagePath: $imagePath, categoryId: $categoryId, isUploadedToServer: $isUploadedToServer, products: $products, serverImagePath:$serverImagePath)';
  }
}
