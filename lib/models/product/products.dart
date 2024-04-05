import 'package:hive/hive.dart';
import 'package:saasify/models/product/product_variant.dart';

import '../../configs/hive_type_ids.dart';

part 'products.g.dart';

@HiveType(typeId: HiveTypeIds.products)
class Products {
  @HiveField(0)
  late String? productId;
  @HiveField(1)
  late String? name;
  @HiveField(2)
  late String? categoryId; // Category/Department
  @HiveField(3)
  late double? tax; // Tax
  @HiveField(4)
  late String? supplier; // Supplier
  @HiveField(5)
  late int? minStockLevel; // Minimum Stock Level
  @HiveField(6)
  late String? description; // Product Description
  @HiveField(7)
  late String? imageUrl; // Image URL
  @HiveField(8)
  late DateTime? dateAdded; // Date Added/Last Updated
  @HiveField(9)
  late bool? isActive; // Variants
  @HiveField(10)
  late String? soldBy;
  @HiveField(11)
  late String? unit;
  List<ProductVariant>? variants;

  Products({
    this.productId = '',
    this.name = '',
    this.categoryId = '',
    this.tax = 0.0,
    this.supplier = '',
    this.minStockLevel = 0,
    this.description = '',
    this.imageUrl = '',
    DateTime? dateAdded,
    List<ProductVariant>? variants,
    bool isActive = false,
    this.soldBy = '',
    this.unit = '',
  })  : dateAdded = dateAdded ?? DateTime.now(),
        variants = variants ?? [];

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'categoryId': categoryId,
      'description': description,
      'imageUrl': imageUrl,
      'supplier': supplier,
      'tax': tax,
      'minStockLevel': minStockLevel,
      'dateAdded': dateAdded,
      'isActive': isActive = true,
      'soldBy': soldBy,
      'unit': unit,
      'variants': variants
    };
  }
}
