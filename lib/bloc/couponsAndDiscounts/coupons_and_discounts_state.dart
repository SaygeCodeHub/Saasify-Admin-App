import '../../models/couponsAndDiscounts/coupons_and_discounts.dart';

abstract class CouponsAndDiscountsStates {}

class CouponInitial extends CouponsAndDiscountsStates {}

class AddingCoupon extends CouponsAndDiscountsStates {}

class CouponAdded extends CouponsAndDiscountsStates {
  final String successMessage;

  CouponAdded({required this.successMessage});
}

class CouponNotAdded extends CouponsAndDiscountsStates {
  final String errorMessage;

  CouponNotAdded({required this.errorMessage});
}

class FetchingCoupons extends CouponsAndDiscountsStates {}

class CouponsFetched extends CouponsAndDiscountsStates {
  final List<CouponsAndDiscountsModel> coupons;
  final String imagePath;

  CouponsFetched({this.imagePath = '', required this.coupons});
}

class CouponsNotFetched extends CouponsAndDiscountsStates {
  final String errorMessage;

  CouponsNotFetched({required this.errorMessage});
}
