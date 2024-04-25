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
  late int? quantity; // Quantity Available
  @HiveField(6)
  late bool? isActive; // Active/Inactive Status
  @HiveField(7)
  late DateTime? dateAdded; // Date added
  @HiveField(8)
  late bool? isUploadedToServer; // Uploaded to server status
  @HiveField(9)
  late int? minStockLevel; // Minimum stock level
  @HiveField(10)
  late String? weight; // Variant Name
  @HiveField(11)
  late String? localImagePath; // Local Image Path
  @HiveField(12)
  late String? serverImagePath; // Server Image Path

  // Constructor with default values
  ProductVariant(
      {this.variantId = '',
      this.productId = '',
      this.variantName = '',
      this.sellingPrice = 0.0,
      this.purchasePrice = 0.0,
      this.quantity = 0,
      this.isActive = true,
      DateTime? dateAdded,
      this.isUploadedToServer = false,
      this.minStockLevel = 0,
      this.localImagePath = '',
      this.serverImagePath = '',
      this.weight = ''}) {
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
      'quantity': quantity,
      'isActive': isActive,
      'dateAdded': dateAdded?.toIso8601String(),
      'isUploadedToServer': isUploadedToServer,
      'minStockLevel': minStockLevel,
      'weight': weight,
      'localImagePath': localImagePath,
      'serverImagePath': serverImagePath
    };
  }

  @override
  String toString() {
    return 'ProductVariant('
        'variantId: $variantId, '
        'productId: $productId, '
        'variantName: $variantName, '
        'sellingPrice: $sellingPrice, '
        'purchasePrice: $purchasePrice, '
        'quantity: $quantity, '
        'isActive: $isActive, '
        'dateAdded: $dateAdded, '
        'isUploadedToServer: $isUploadedToServer, '
        'minStockLevel: $minStockLevel, '
        'weight: $weight, '
        'localImagePath: $localImagePath, '
        'serverImagePath: $serverImagePath'
        ')';
  }
}
