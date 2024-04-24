import 'package:hive/hive.dart';
import 'package:saasify/models/product/product_variant.dart';

import '../../configs/hive_type_ids.dart';

part 'product_model.g.dart';

@HiveType(typeId: HiveTypeIds.products)
class ProductsModel {
  @HiveField(0)
  String? productId;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? categoryId;
  @HiveField(3)
  double? tax;
  @HiveField(4)
  String? supplier;
  @HiveField(5)
  int? minStockLevel;
  @HiveField(6)
  String? description;
  @HiveField(7)
  String? localImagePath;
  @HiveField(8)
  DateTime? dateAdded;
  @HiveField(9)
  bool? isActive;
  @HiveField(10)
  String? soldBy;
  @HiveField(11)
  String? unit;
  List<ProductVariant>? variants;
  @HiveField(12)
  String? serverImagePath;
  @HiveField(13)
  bool? isUploadedToServer;

  ProductsModel(
      {this.productId,
      this.name,
      this.categoryId,
      this.tax,
      this.supplier,
      this.minStockLevel,
      this.description,
      this.localImagePath,
      this.dateAdded,
      this.isActive = true,
      this.soldBy,
      this.unit,
      this.variants,
      this.serverImagePath,
      this.isUploadedToServer});

  factory ProductsModel.fromMap(Map<String, dynamic> map) {
    return ProductsModel(
        productId: map['productId'],
        name: map['name'],
        categoryId: map['categoryId'],
        tax: map['tax'],
        supplier: map['supplier'],
        minStockLevel: map['minStockLevel'],
        description: map['description'],
        localImagePath: map['localImagePath'],
        dateAdded:
            map['dateAdded'] != null ? DateTime.parse(map['dateAdded']) : null,
        isActive: map['isActive'],
        soldBy: map['soldBy'],
        unit: map['unit'],
        serverImagePath: map['serverImagePath'],
        isUploadedToServer: map['isUploadedToServer']);
  }

  @override
  String toString() {
    return 'ProductsModel(productId: $productId, name: $name, categoryId: $categoryId, tax: $tax, supplier: $supplier, minStockLevel: $minStockLevel, description: $description, localImagePath: $localImagePath, dateAdded: $dateAdded, isActive: $isActive, soldBy: $soldBy, unit: $unit,serverImagePath: $serverImagePath,isUploadedToServer: $isUploadedToServer, variants: $variants)';
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'categoryId': categoryId,
      'tax': tax,
      'supplier': supplier,
      'minStockLevel': minStockLevel,
      'description': description,
      'localImagePath': localImagePath,
      'dateAdded': dateAdded?.toIso8601String(),
      'isActive': isActive,
      'soldBy': soldBy,
      'unit': unit,
      'variants': variants?.map((variant) => variant.toMap()).toList(),
      'serverImagePath': serverImagePath,
      'isUploadedToServer': isUploadedToServer
    };
  }
}
