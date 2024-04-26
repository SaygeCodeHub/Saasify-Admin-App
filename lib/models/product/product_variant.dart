import 'package:hive/hive.dart';
part 'product_variant.g.dart';

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
  ProductVariant({
    this.variantId = '',
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
    this.weight = '',
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
      'quantity': quantity,
      'isActive': isActive,
      'dateAdded': dateAdded?.toIso8601String(),
      'isUploadedToServer': isUploadedToServer,
      'minStockLevel': minStockLevel,
      'weight': weight,
      'localImagePath': localImagePath,
      'serverImagePath': serverImagePath,
    };
  }

  // Convert a map to a ProductVariant instance
  static ProductVariant fromMap(Map<String, dynamic> map) {
    return ProductVariant(
      variantId: map['variantId'] as String?,
      productId: map['productId'] as String?,
      variantName: map['variantName'] as String?,
      sellingPrice: map['sellingPrice'] as double?,
      purchasePrice: map['purchasePrice'] as double?,
      quantity: map['quantity'] as int?,
      isActive: map['isActive'] as bool?,
      dateAdded:
          map['dateAdded'] != null ? DateTime.parse(map['dateAdded']) : null,
      isUploadedToServer: map['isUploadedToServer'] as bool?,
      minStockLevel: map['minStockLevel'] as int?,
      weight: map['weight'] as String?,
      localImagePath: map['localImagePath'] as String?,
      serverImagePath: map['serverImagePath'] as String?,
    );
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
