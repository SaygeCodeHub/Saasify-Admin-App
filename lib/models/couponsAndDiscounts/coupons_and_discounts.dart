import 'package:hive/hive.dart';
import '../../configs/hive_type_ids.dart';
part 'coupons_and_discounts.g.dart';

@HiveType(typeId: HiveTypeIds.coupons)
class CouponsAndDiscountsModel {
  @HiveField(0)
  final String couponCode;

  @HiveField(1)
  final double? amount;

  @HiveField(2)
  final double? maximumAmount;

  @HiveField(3)
  final String? couponType;

  @HiveField(4)
  final DateTime? validTill;

  CouponsAndDiscountsModel(
      {required this.couponCode,
      required this.amount,
      required this.maximumAmount,
      required this.couponType,
      required this.validTill});

  Map<String, dynamic> toMap() {
    return {
      'couponCode': couponCode,
      'amount': amount,
      'maximumAmount': maximumAmount,
      'couponType': couponType,
      'validTill': validTill
    };
  }
}
