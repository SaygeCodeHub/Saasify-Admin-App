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
  String? description;
  @HiveField(6)
  String? localImagePath;
  @HiveField(7)
  DateTime? dateAdded;
  @HiveField(8)
  bool? isActive;
  @HiveField(9)
  String? soldBy;
  List<ProductVariant>? variants;
  @HiveField(10)
  String? serverImagePath;
  @HiveField(11)
  bool? isUploadedToServer;

  // Constructor
  ProductsModel({
    this.productId,
    this.name,
    this.categoryId,
    this.tax,
    this.supplier,
    this.description,
    this.localImagePath,
    DateTime? dateAdded,
    bool? isActive,
    this.soldBy,
    this.variants,
    this.serverImagePath,
    bool? isUploadedToServer,
  }) {
    // Set default values for certain fields
    this.dateAdded = dateAdded ?? DateTime.now();
    this.isActive = isActive ?? true;
    this.isUploadedToServer = isUploadedToServer ?? false;
  }

  // Factory method to create a ProductsModel from a map
  factory ProductsModel.fromMap(Map<String, dynamic> map) {
    return ProductsModel(
        productId: map['productId'],
        name: map['name'],
        categoryId: map['categoryId'],
        tax: map['tax'],
        supplier: map['supplier'],
        description: map['description'],
        localImagePath: map['localImagePath'],
        dateAdded:
            map['dateAdded'] != null ? DateTime.parse(map['dateAdded']) : null,
        isActive: map['isActive'],
        soldBy: map['soldBy'],
        serverImagePath: map['serverImagePath'],
        isUploadedToServer: map['isUploadedToServer']);
  }

  // Convert the ProductsModel to a map
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'categoryId': categoryId,
      'tax': tax,
      'supplier': supplier,
      'description': description,
      'localImagePath': localImagePath,
      'dateAdded': dateAdded?.toIso8601String(),
      'isActive': isActive,
      'soldBy': soldBy,
      'variants': variants?.map((variant) => variant.toMap()).toList(),
      'serverImagePath': serverImagePath,
      'isUploadedToServer': isUploadedToServer,
    };
  }

  // toString() method for debugging and logging
  @override
  String toString() {
    return 'ProductsModel(productId: $productId, name: $name, categoryId: $categoryId, tax: $tax, supplier: $supplier, description: $description, localImagePath: $localImagePath, dateAdded: $dateAdded, isActive: $isActive, soldBy: $soldBy, serverImagePath: $serverImagePath, isUploadedToServer: $isUploadedToServer, variants: $variants)';
  }
}
