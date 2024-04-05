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
  late double? price; // Price
  @HiveField(4)
  late double? cost; // Cost
  @HiveField(5)
  late int? quantityAvailable; // Quantity Available
  @HiveField(6)
  late bool? isActive; // Active/Inactive Status

  ProductVariant(
      {this.variantId = '',
      this.productId = '',
      this.variantName = '',
      this.price = 0.0,
      this.cost = 00,
      this.quantityAvailable = 0,
      this.isActive = true});

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
