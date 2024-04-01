import '../../models/couponsAndDiscounts/coupons_and_discounts.dart';

abstract class CouponsAndDiscountsEvents {}

class AddCoupon extends CouponsAndDiscountsEvents {
  final CouponsAndDiscountsModel addCouponMap;

  AddCoupon({required this.addCouponMap});
}

class FetchCoupons extends CouponsAndDiscountsEvents {}
