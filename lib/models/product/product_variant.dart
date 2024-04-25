import 'package:hive/hive.dart';
import '../../configs/hive_type_ids.dart';

part 'product_variant.g.dart';

@HiveType(typeId: HiveTypeIds.productVariants)
class ProductVariant {
  @HiveField(0)
  late String? variantId; // Variant ID
  @HiveField(1)
  late String? productId; // Product ID
  @HiveField(2)
  late String? variantName; // Variant Name
  @HiveField(3)
  late double? sellingPrice; // Selling Price (previously price)
  @HiveField(4)
  late double? purchasePrice; // Purchase Price (previously cost)
  @HiveField(5)
  late int? quantityAvailable; // Quantity Available
  @HiveField(6)
  late bool? isActive; // Active/Inactive Status
  @HiveField(7)
  late DateTime? dateAdded; // Date added
  @HiveField(8)
  late bool? isUploadedToServer; // Uploaded to server status
  @HiveField(9)
  late int? minStockLevel; // Minimum stock level

  // Constructor with default values
  ProductVariant({
    this.variantId = '',
    this.productId = '',
    this.variantName = '',
    this.sellingPrice = 0.0,
    this.purchasePrice = 0.0,
    this.quantityAvailable = 0,
    this.isActive = true,
    DateTime? dateAdded,
    this.isUploadedToServer = false,
    this.minStockLevel = 0,
  }) {
    this.dateAdded = dateAdded ?? DateTime.now();
  }

  // Convert the ProductVariant to a map
  Map<String, dynamic> toMap() {
    return {
      'variantId': variantId,
      'productId': productId,
      'variantName': variantName,
      'sellingPrice': sellingPrice,
      'purchasePrice': purchasePrice,
      'quantityAvailable': quantityAvailable,
      'isActive': isActive,
      'dateAdded': dateAdded?.toIso8601String(),
      'isUploadedToServer': isUploadedToServer,
      'minStockLevel': minStockLevel,
    };
  }
}
