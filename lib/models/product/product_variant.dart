import 'package:hive/hive.dart';

import '../../configs/hive_type_ids.dart';

part 'product_variant.g.dart';

@HiveType(typeId: HiveTypeIds.productVariants)
class ProductVariant {
  @HiveField(0)
  late int variantId; // Variant ID
  @HiveField(1)
  late int productId; // Product ID
  @HiveField(2)
  late String variantName; // Variant Name
  @HiveField(3)
  late double price; // Price
  @HiveField(4)
  late double cost; // Cost
  @HiveField(5)
  late int quantityAvailable; // Quantity Available
  @HiveField(6)
  late bool isActive; // Active/Inactive Status

  ProductVariant({
    required this.variantId,
    required this.productId,
    required this.variantName,
    required this.price,
    required this.cost,
    required this.quantityAvailable,
    required this.isActive,
  });

  Map<String, dynamic> toMap() {
    return {
      'variantId': productId,
      'productId': productId,
      'variantName': variantName,
      'price': price,
      'cost': cost,
      'quantityAvailable': quantityAvailable
    };
  }
}
